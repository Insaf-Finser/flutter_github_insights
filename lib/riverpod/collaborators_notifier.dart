import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:git_rest/constants.dart';
import 'package:git_rest/shared_preferences.dart';
import 'package:git_rest/data/git_operations.dart';
import 'package:git_rest/data/models/collaborator.dart';
import 'package:git_rest/data/models/repository_collaborators.dart';

part 'collaborators_notifier.g.dart';

@riverpod
class CollaboratorsNotifier
    extends AutoDisposeAsyncNotifier<List<RepositoryCollaborators>> {
  CollaboratorsNotifier() : super();

  GitOperations? _ops;
  List<Map<String, String>> _selectedRepos = [];

  @override
  Future<List<RepositoryCollaborators>> build() async {
    final token = await getAccessToken();
    _ops = GitOperations(token: token);
    final box = await Hive.openBox<RepositoryCollaborators>(
        'repository_collaborators_box');
    return _loadDataFromBox(box);
  }

  Future<List<RepositoryCollaborators>> _loadDataFromBox(
      Box<RepositoryCollaborators> box) async {
    return box.values.toList();
  }

  Future<void> _fetchAndCacheRepos(Box<RepositoryCollaborators> box) async {
    try {
      if (_ops == null) {
        throw Exception('GitOperations not initialized');
      }

      final Map<String, List<dynamic>> rawCollaboratorsData =
          await _ops!.getCollaboratorsForSelectedRepos(_selectedRepos);

      final Map<String, List<Collaborator>> collaboratorsData = {};

      for (final entry in rawCollaboratorsData.entries) {
        final repoName = entry.key;
        final dynamic collaborators = entry.value;

        final collaboratorList = (collaborators as List)
            .map((data) => Collaborator.fromMap(data as Map<String, dynamic>))
            .toList();

        collaboratorsData[repoName] = collaboratorList;
      }

      printInDebug('Collaborators data processed'); // Debugging
      printInDebug(collaboratorsData);

      final Map<String, RepositoryCollaborators> repositoryCollaboratorsMap =
          {};

      for (final entry in collaboratorsData.entries) {
        final repoName = entry.key;
        final collaborators = entry.value;

        final repositoryCollaborators = RepositoryCollaborators(
          repositoryName: repoName,
          collaborators: collaborators,
        );

        repositoryCollaboratorsMap[repoName] = repositoryCollaborators;
      }

      await box.putAll(repositoryCollaboratorsMap);
      printInDebug('Data saved to box'); // Debugging
      printInDebug(repositoryCollaboratorsMap.values.toList());
    } catch (e, stackTrace) {
      printInDebug('Error caught: $e'); // Debugging
      state = AsyncValue.error(e, stackTrace);
    }
  }
Future<void> updateSelectedRepos(
    List<Map<String, String>> selectedRepos) async {
  _selectedRepos = selectedRepos;

  if (_selectedRepos.isEmpty) {
    // No repos selected, clear state
    state = const AsyncValue.data([]);
    return;
  }

  final box = await Hive.openBox<RepositoryCollaborators>(
      'repository_collaborators_box');
  final cachedRepos =
      box.values.toList().map((repo) => repo.repositoryName).toSet();

  final reposToFetch = _selectedRepos
      .map((repo) => repo['repo'])
      .where(
          (repoName) => repoName != null && !cachedRepos.contains(repoName))
      .toList();

  // Set loading state before fetching
  state = const AsyncValue.loading();

  if (reposToFetch.isNotEmpty) {
    await _fetchAndCacheRepos(box);
  }

  // Update the state with the fetched or cached data
  final updatedRepos = _selectedRepos
      .map((repo) => box.get(repo['repo']))
      .where((repo) => repo != null)
      .cast<RepositoryCollaborators>()
      .toList();

  if (updatedRepos.isNotEmpty) {
    printInDebug(
        "Filtered repositories to update state with: ${updatedRepos[0].repositoryName}");
  } else {
    printInDebug("No repositories found to update the state with.");
  }

  // Update the state with the final data
  state = AsyncValue.data(updatedRepos);
}


}
