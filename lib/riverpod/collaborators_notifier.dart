import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:githubinsights/constants.dart';
import 'package:githubinsights/shared_preferences.dart';
import 'package:githubinsights/data/git_operations.dart';
import 'package:githubinsights/data/models/collaborator.dart';
import 'package:githubinsights/data/models/repository_collaborators.dart';

part 'collaborators_notifier.g.dart';

@riverpod
class CollaboratorsNotifier
    extends AutoDisposeAsyncNotifier<List<RepositoryCollaborators>> {
  CollaboratorsNotifier() : super();

  GitOperations? _ops;
  List<Map<String, String>> _selectedRepos = [];

  @override
  Future<List<RepositoryCollaborators>> build() async {
    printInDebug('CollaboratorsNotifier.build() called');
    final token = await getAccessToken();
    printInDebug('Token obtained: ${token.isNotEmpty ? 'Yes' : 'No'}');
    _ops = GitOperations(token: token);
    final box = await Hive.openBox<RepositoryCollaborators>(
        'repository_collaborators_box');
    printInDebug('Hive box opened, contains ${box.length} items');
    return _loadDataFromBox(box);
  }

  Future<List<RepositoryCollaborators>> _loadDataFromBox(
      Box<RepositoryCollaborators> box) async {
    final data = box.values.toList();
    printInDebug('Loaded ${data.length} items from Hive box');
    for (final item in data) {
      printInDebug('Box item: ${item.repositoryName} with ${item.collaborators.length} collaborators');
    }
    return data;
  }

  Future<void> _fetchAndCacheRepos(Box<RepositoryCollaborators> box) async {
    try {
      printInDebug('Starting to fetch collaborators for ${_selectedRepos.length} repositories');
      printInDebug('Selected repos: $_selectedRepos');
      
      if (_ops == null) {
        throw Exception('GitOperations not initialized');
      }

      final Map<String, List<dynamic>> rawCollaboratorsData =
          await _ops!.getCollaboratorsForSelectedRepos(_selectedRepos);

      printInDebug('Raw collaborators data received: ${rawCollaboratorsData.length} repositories');
      printInDebug('Raw data keys: ${rawCollaboratorsData.keys.toList()}');

      final Map<String, List<Collaborator>> collaboratorsData = {};

      for (final entry in rawCollaboratorsData.entries) {
        final repoName = entry.key;
        final dynamic collaborators = entry.value;

        printInDebug('Processing repo: $repoName with ${collaborators.length} raw collaborators');
        printInDebug('Raw collaborators type: ${collaborators.runtimeType}');
        printInDebug('Raw collaborators data: $collaborators');

        final collaboratorList = (collaborators as List)
            .map((data) {
              printInDebug('Processing collaborator data: $data');
              printInDebug('Data type: ${data.runtimeType}');
              return Collaborator.fromMap(data as Map<String, dynamic>);
            })
            .toList();

        collaboratorsData[repoName] = collaboratorList;
        printInDebug('Processed ${collaboratorList.length} collaborators for $repoName');
        
        // Debug: Show processed collaborators
        for (final collaborator in collaboratorList) {
          printInDebug('  Processed: ${collaborator.login} (${collaborator.roleName})');
        }
      }

      printInDebug('Collaborators data processed');
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
        printInDebug('Created RepositoryCollaborators for $repoName with ${collaborators.length} collaborators');
      }

      // Clear old data for these repositories before adding new data
      await _clearOldDataForRepos(box, repositoryCollaboratorsMap.keys.toList());

      // Store each repository separately with a unique key
      for (final entry in repositoryCollaboratorsMap.entries) {
        final repoName = entry.key;
        final repoData = entry.value;
        
        // Use a unique key format to avoid conflicts
        final uniqueKey = 'repo_${repoName}_${DateTime.now().millisecondsSinceEpoch}';
        await box.put(uniqueKey, repoData);
        printInDebug('Saved $repoName with key $uniqueKey and ${repoData.collaborators.length} collaborators');
      }
      
      printInDebug('Data saved to box');
      printInDebug('Box now contains ${box.length} items');
      
      // Verify data was saved
      for (final entry in repositoryCollaboratorsMap.entries) {
        final repoName = entry.key;
        final savedItems = box.values.where((item) => item.repositoryName == repoName).toList();
        if (savedItems.isNotEmpty) {
          printInDebug('Verified: ${repoName} saved with ${savedItems.first.collaborators.length} collaborators');
        } else {
          printInDebug('ERROR: ${repoName} was not saved properly');
        }
      }
      
      printInDebug(repositoryCollaboratorsMap.values.toList());
    } catch (e, stackTrace) {
      printInDebug('Error caught in _fetchAndCacheRepos: $e');
      printInDebug('Stack trace: $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Helper method to clear old data for specific repositories
  Future<void> _clearOldDataForRepos(Box<RepositoryCollaborators> box, List<String> repoNames) async {
    for (final repoName in repoNames) {
      // Find all keys that contain this repository name
      final keysToDelete = <String>[];
      for (final key in box.keys) {
        if (key.toString().contains('repo_${repoName}_')) {
          keysToDelete.add(key.toString());
        }
      }
      
      // Delete old data
      for (final key in keysToDelete) {
        await box.delete(key);
        printInDebug('Deleted old data for $repoName with key: $key');
      }
    }
  }

  // Method to manually clear all data (useful for debugging)
  Future<void> clearAllData() async {
    final box = await Hive.openBox<RepositoryCollaborators>(
        'repository_collaborators_box');
    await box.clear();
    printInDebug('All data cleared from Hive box');
    state = const AsyncValue.data([]);
  }

  // Method to show current box contents for debugging
  Future<void> debugBoxContents() async {
    final box = await Hive.openBox<RepositoryCollaborators>(
        'repository_collaborators_box');
    printInDebug('=== DEBUG: Current Box Contents ===');
    printInDebug('Total items in box: ${box.length}');
    printInDebug('Box keys: ${box.keys.toList()}');
    
    for (final item in box.values) {
      printInDebug('Item: ${item.repositoryName} - ${item.collaborators.length} collaborators');
      for (final collaborator in item.collaborators) {
        printInDebug('  - ${collaborator.login} (${collaborator.roleName})');
      }
    }
    printInDebug('=== END DEBUG ===');
  }

  // Method to force refresh data (clear and fetch fresh)
  Future<void> forceRefresh() async {
    printInDebug('Force refresh triggered - clearing all data and fetching fresh');
    
    // Clear all data first
    await clearAllData();
    
    // Wait a moment for the clear to complete
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Fetch fresh data if we have selected repos
    if (_selectedRepos.isNotEmpty) {
      printInDebug('Fetching fresh data after clear');
      await updateSelectedRepos(_selectedRepos);
    } else {
      printInDebug('No selected repos to refresh');
    }
  }

  Future<void> updateSelectedRepos(
      List<Map<String, String>> selectedRepos) async {
    printInDebug('updateSelectedRepos called with ${selectedRepos.length} repositories');
    printInDebug('Selected repos: $selectedRepos');
    
    _selectedRepos = selectedRepos;

    if (_selectedRepos.isEmpty) {
      printInDebug('No repos selected, clearing state');
      // No repos selected, clear state
      state = const AsyncValue.data([]);
      return;
    }

    final box = await Hive.openBox<RepositoryCollaborators>(
        'repository_collaborators_box');
    
    // Always fetch fresh data instead of checking cache
    printInDebug('Always fetching fresh data for selected repositories');
    
    // Set loading state before fetching
    state = const AsyncValue.loading();

    // Always fetch fresh data
    await _fetchAndCacheRepos(box);

    // Update the state with the freshly fetched data
    final updatedRepos = _selectedRepos
        .map((repo) {
          final repoName = repo['repo'];
          // Look for all items in the box that match this repository name
          final savedItems = box.values.where((item) => item.repositoryName == repoName).toList();
          printInDebug('Looking for $repoName in box: Found ${savedItems.length} items');
          
          if (savedItems.isNotEmpty) {
            // Take the most recent one (last in the list)
            final saved = savedItems.last;
            printInDebug('$repoName has ${saved.collaborators.length} collaborators');
            return saved;
          }
          return null;
        })
        .where((repo) => repo != null)
        .cast<RepositoryCollaborators>()
        .toList();

    printInDebug('Updated repos count: ${updatedRepos.length}');
    if (updatedRepos.isNotEmpty) {
      printInDebug(
          "Filtered repositories to update state with: ${updatedRepos[0].repositoryName}");
      for (final repo in updatedRepos) {
        printInDebug('Repo: ${repo.repositoryName} with ${repo.collaborators.length} collaborators');
        // Print each collaborator for debugging
        for (final collaborator in repo.collaborators) {
          printInDebug('  - ${collaborator.login} (${collaborator.roleName})');
        }
      }
    } else {
      printInDebug("No repositories found to update the state with.");
      printInDebug("Available keys in box: ${box.keys.toList()}");
      printInDebug("Selected repo names: ${_selectedRepos.map((r) => r['repo']).toList()}");
      
      // Debug: Show all items in the box
      printInDebug("All items in box:");
      for (final item in box.values) {
        printInDebug("  ${item.repositoryName}: ${item.collaborators.length} collaborators");
      }
    }

    // Update the state with the final data
    state = AsyncValue.data(updatedRepos);
    printInDebug('State updated with ${updatedRepos.length} repositories');
  }
}
