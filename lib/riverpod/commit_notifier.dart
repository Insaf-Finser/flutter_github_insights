import 'package:git_rest/constants.dart';
import 'package:git_rest/data/git_operations.dart';
import 'package:git_rest/data/models/commit.dart';

import 'package:git_rest/data/models/repository_commits.dart';
import 'package:git_rest/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'commit_notifier.g.dart';

@riverpod
class CommitsNotifier
    extends AutoDisposeAsyncNotifier<List<RepositoryCommits>> {
  CommitsNotifier() : super();

  GitOperations? _ops;

  @override
  Future<List<RepositoryCommits>> build() async {
    return await initialize();
  }

  GitOperations get ops {
    if (_ops == null) {
      throw StateError('GitOperations is not initialized');
    }
    return _ops!;
  }

  Future<List<RepositoryCommits>> initialize() async {
    final token = await getAccessToken();
    _ops = GitOperations(token: token);

    try {
      final box = await Hive.openBox<RepositoryCommits>('gitCommitsBox');

      if (box.isNotEmpty) {
        printInDebug("box not empty");
        return box.values.toList();
      } else {
        printInDebug("box empty");
        await fetchAndCacheRepos(
          selectedRepos: [
            {'owner': 'Harsh-Vipin', 'repo': 'acmhack'}, // Example data
            {'owner': 'Harsh-Vipin', 'repo': 'da_two'}
          ],
          selectedCollaborators: ['Harsh-Vipin'],
          since: DateTime.now().subtract(const Duration(days: 365 * 2)),
          until: DateTime.now(),
        );
        return state.asData?.value ?? [];
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<void> fetchAndCacheRepos({
    required List<Map<String, String>> selectedRepos,
    required List<String> selectedCollaborators,
    required DateTime since,
    required DateTime until,
  }) async {
    printInDebug(selectedRepos);
    final token = await getAccessToken();
    _ops = GitOperations(token: token);

    final box = await Hive.openBox<RepositoryCommits>('gitCommitsBox');
    await box.clear();

    final data = await _ops!.getCommitsForSelectedRepos(
      selectedRepos: selectedRepos,
      selectedCollaborators: selectedCollaborators,
      since: since,
      until: until,
    );

    // Convert API data to Hive models
    final repositoryCommitsList = data.entries.map((entry) {
      final commits = entry.value.map((commitData) {
        return Commit(
          sha: commitData['sha'],
          message: commitData['message'],
          author: commitData['author'],
          date: DateTime.parse(commitData['date']),
          url: commitData['url'],
        );
      }).toList();

      return RepositoryCommits(
        repositoryName: entry.key,
        commits: commits,
      );
    }).toList();

    // Save to Hive
    for (final repoCommits in repositoryCommitsList) {
      await box.put(repoCommits.repositoryName, repoCommits);
    }
    printInDebug(repositoryCommitsList);
    // Update the Riverpod state
    state = AsyncValue.data(repositoryCommitsList);
    printInDebug("cache updated with fetched data");
  }

  Future<void> updateCache({
    required List<Map<String, String>> selectedRepos,
    required List<String> selectedCollaborators,
    required DateTime since,
    required DateTime until,
  }) async {
    if (_ops == null) {
      final token = await getAccessToken();
      _ops = GitOperations(token: token);
    }
    await fetchAndCacheRepos(
      selectedRepos: selectedRepos,
      selectedCollaborators: selectedCollaborators,
      since: since,
      until: until,
    );
  }

  Future<void> fetchCommitFiles() async {
    try {
      final token = await getAccessToken();
      final ops = GitOperations(token: token);

      final box = await Hive.openBox<RepositoryCommits>('gitCommitsBox');

      final repositoryCommitsList = box.values.toList();
     

      for (var repoCommits in repositoryCommitsList) {
        if (repoCommits.commits.isEmpty) {
          continue;
        }

        List<Commit> updatedCommits = [];

        for (var commit in repoCommits.commits) {
          final data = await ops.getCommitDetails(
            owner: commit.author,
            repo: repoCommits.repositoryName,
            ref: commit.sha,
          );

           


          // Parse commit stats
          final commitStats = data['stats'] != null
              ? CommitStats(
                  additions: data['stats']['additions'] ?? 0,
                  deletions: data['stats']['deletions'] ?? 0,
                  total: data['stats']['total'] ?? 0,
                )
              : null;

          // Parse commit files
          final commitFiles = data['files'] != null
              ? List<CommitFile>.from(data['files'].map((file) {
                  return CommitFile(
                    filename: file['filename'],
                    status: file['status'],
                    changes: file['changes'],
                    additions: file['additions'],
                    deletions: file['deletions'],
                  );
                }))
              : null;

          // Update the existing commit with stats and files
          final updatedCommit = Commit(
            sha: commit.sha,
            message: commit.message,
            author: commit.author,
            date: commit.date,
            url: commit.url,
            stats: commitStats,
            files: commitFiles,
          );

          // Collect updated commits
          updatedCommits.add(updatedCommit);
        }

        // Update the repository commits with the updated commit data
        await box.put(
          repoCommits.repositoryName,
          RepositoryCommits(
            repositoryName: repoCommits.repositoryName,
            commits: updatedCommits,
          ),
        );
      }

      // Update the Riverpod state with the new data
      state = AsyncValue.data(box.values.toList());
    } catch (e, stackTrace) {
   
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
