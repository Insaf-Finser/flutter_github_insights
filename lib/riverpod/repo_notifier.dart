import 'package:git_rest/constants.dart';
import 'package:git_rest/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:git_rest/data/git_operations.dart';
import 'package:git_rest/data/models/git_repo_model.dart';
import 'package:git_rest/data/models/hive_model.dart' as hive_model;
import 'package:hive_flutter/hive_flutter.dart';

part 'repo_notifier.g.dart';

@riverpod
class RepoNotifier extends AutoDisposeAsyncNotifier<List<hive_model.Repo>> {
  RepoNotifier() : super();

  GitOperations? _ops;

  @override
  Future<List<hive_model.Repo>> build() async {
    // Initialize the repository data
    return await initialize();
  }

  GitOperations get ops {
    if (_ops == null) {
      throw StateError('GitOperations is not initialized');
    }
    return _ops!;
  }

  Future<List<hive_model.Repo>> initialize() async {
    final token = await getAccessToken();
    _ops = GitOperations(token: token);
    try {
      final box = await Hive.openBox<hive_model.Repo>('gitReposBox');

      if (box.isNotEmpty) {
        printInDebug("box not empty");
        return box.values.toList();
      } else {
        printInDebug("box empty");
        await _fetchAndCacheRepos();
        return state.asData?.value ?? [];
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<void> _fetchAndCacheRepos() async {
    try {
      if (_ops == null) {
        throw Exception('GitOperations not initialized');
      }

      final box = await Hive.openBox<hive_model.Repo>('gitReposBox');
      await box.clear();

      final data = await _ops!.listRepositories(true);
      final repos = data.map((repoData) => GitRepo.fromMap(repoData)).toList();
      // final List<Map<String, String>> selectedRepos = [
      //   {'owner': 'Harsh-Vipin', 'repo': 'acm-hack'},
      //   {'owner': 'Harsh-Vipin', 'repo': 'bbbb'},
      // ];
      // final d = await _ops!.getCollaboratorsForSelectedRepos(selectedRepos);
      // printInDebug(d);

      final List<hive_model.Repo> r = [];
      for (var repo in repos) {
        final hiveRepo = hive_model.Repo(
          id: repo.id,
          nodeId: repo.nodeId,
          name: repo.name,
          fullName: repo.fullName,
          owner: hive_model.Owner(
            login: repo.owner.login,
            id: repo.owner.id,
            avatarUrl: repo.owner.avatarUrl,
          ),
          private: repo.private,
          defaultBranch: repo.defaultBranch,
          permissions: hive_model.Permissions(
            admin: repo.permissions.admin,
            push: repo.permissions.push,
            pull: repo.permissions.pull,
          ),
        );
        await box.put(repo.id, hiveRepo);
        r.add(hiveRepo);
      }

      state = AsyncValue.data(r);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateCache() async {
    if (_ops == null) {
      final token = await getAccessToken();
      _ops = GitOperations(token: token);
    }
    await _fetchAndCacheRepos();
    printInDebug("cache updated");
  }
}
