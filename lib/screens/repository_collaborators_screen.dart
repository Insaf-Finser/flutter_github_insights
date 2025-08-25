import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/constants.dart';
import 'package:githubinsights/data/models/repository_collaborators.dart';
import 'package:githubinsights/riverpod/commit_notifier.dart';
import 'package:githubinsights/riverpod/collaborators_notifier.dart';
import 'package:githubinsights/routes/route_names.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // Added for Timer

class RepositoryCollaboratorsScreen extends ConsumerStatefulWidget {
  const RepositoryCollaboratorsScreen({super.key, this.selectedRepos = const []});
  final List<Map<String, String>> selectedRepos;
  
  @override
  ConsumerState<RepositoryCollaboratorsScreen> createState() =>
      _RepositoryCollaboratorsScreenState();
}

class _RepositoryCollaboratorsScreenState
    extends ConsumerState<RepositoryCollaboratorsScreen> {
  // Map to store the selected collaborators for each repository
  final selectedCollaborators = <String, Set<String>>{};

  // Separate controllers for start and end dates
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Loading state for refresh operations
  bool _isRefreshing = false;
  
  // Success message state
  String? _successMessage;
  Timer? _successTimer;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? DateTime.now().subtract(const Duration(days: 365))
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        
        // Format the date as YYYY-MM-DD, which is compatible with DateTime.parse
        final formattedDate =
            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';

        if (isStartDate) {
          _startDateController.text = formattedDate;
        } else {
          _endDateController.text = formattedDate;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Ensure only collaborators for repos selected earlier are loaded
    if (widget.selectedRepos.isNotEmpty) {
      printInDebug('Selected repos in initState: ${widget.selectedRepos}');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Clear old data first
        await ref
            .read(collaboratorsNotifierProvider.notifier)
            .clearAllData();
        
        // Then fetch fresh data
        await ref
            .read(collaboratorsNotifierProvider.notifier)
            .updateSelectedRepos(widget.selectedRepos);
      });
    } else {
      printInDebug('No selected repos in initState');
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _searchController.dispose();
    
    // Cancel any pending timers
    _successTimer?.cancel();
    
    // Clear data when page is disposed to prevent stale data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(collaboratorsNotifierProvider.notifier)
            .clearAllData();
      }
    });
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collaboratorsAsyncValue = ref.watch(collaboratorsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repository Collaborators'),
        actions: [
          IconButton(
            icon: _isRefreshing 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : () async {
              printInDebug('Manual refresh triggered');
              printInDebug('Selected repos: ${widget.selectedRepos}');
              
              setState(() {
                _isRefreshing = true;
              });
              
              try {
                // Use force refresh to clear old data and fetch fresh
                await ref
                    .read(collaboratorsNotifierProvider.notifier)
                    .forceRefresh();
                
                // Show success message
                setState(() {
                  _successMessage = 'Data refreshed successfully!';
                });
                
                // Clear success message after 3 seconds
                _successTimer?.cancel();
                _successTimer = Timer(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      _successMessage = null;
                    });
                  }
                });
              } finally {
                if (mounted) {
                  setState(() {
                    _isRefreshing = false;
                  });
                }
              }
            },
            tooltip: _isRefreshing ? 'Refreshing...' : 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: collaboratorsAsyncValue.when(
              data: (collaboratorsList) {
                printInDebug('Collaborators data received: ${collaboratorsList.length} repositories');
                printInDebug('Selected repos: ${widget.selectedRepos}');
                
                // Filter to only show collaborators for repositories selected in the previous page
                final selectedRepoNames = widget.selectedRepos.map((repo) => repo['repo']).toSet();
                printInDebug('Selected repo names: $selectedRepoNames');
                
                // Simplified filtering - first filter by selected repos, then by search
                var filteredCollaboratorsList = collaboratorsList
                    .where((repoCollaborators) => selectedRepoNames.contains(repoCollaborators.repositoryName))
                    .toList();
                
                printInDebug('After repo filtering: ${filteredCollaboratorsList.length} repositories');
                
                // Apply search filter only if there's a search query
                if (_searchQuery.isNotEmpty) {
                  filteredCollaboratorsList = filteredCollaboratorsList
                      .where((repoCollaborators) {
                    return repoCollaborators.repositoryName
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        repoCollaborators.collaborators.any((collaborator) =>
                            collaborator.login
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()));
                  }).toList();
                  printInDebug('After search filtering: ${filteredCollaboratorsList.length} repositories');
                }

                printInDebug('Filtered collaborators list: ${filteredCollaboratorsList.length} repositories');
                for (final repo in filteredCollaboratorsList) {
                  printInDebug('Repo: ${repo.repositoryName}, Collaborators: ${repo.collaborators.length}');
                  // Debug: Print each collaborator
                  for (final collaborator in repo.collaborators) {
                    printInDebug('  - ${collaborator.login} (${collaborator.roleName})');
                  }
                }

                // Additional debug: Check if any repositories are missing collaborators
                final missingRepos = selectedRepoNames.difference(
                  filteredCollaboratorsList.map((r) => r.repositoryName).toSet()
                );
                if (missingRepos.isNotEmpty) {
                  printInDebug('WARNING: Missing collaborators for repositories: $missingRepos');
                }

                // Debug: Check if data might be truncated
                printInDebug('=== DATA INTEGRITY CHECK ===');
                printInDebug('Total collaborators in all repos: ${filteredCollaboratorsList.fold<int>(0, (sum, repo) => sum + repo.collaborators.length)}');
                printInDebug('Repository breakdown:');
                for (final repo in filteredCollaboratorsList) {
                  printInDebug('  ${repo.repositoryName}: ${repo.collaborators.length} collaborators');
                  if (repo.collaborators.length == 1) {
                    printInDebug('    WARNING: Only 1 collaborator - this might indicate truncation');
                  }
                }
                printInDebug('=== END DATA INTEGRITY CHECK ===');

                if (filteredCollaboratorsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No collaborators found',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selected repositories: ${selectedRepoNames.join(', ')}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(collaboratorsNotifierProvider.notifier)
                                .updateSelectedRepos(widget.selectedRepos);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Repositories or Collaborators',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    // Start Date Picker
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                    // End Date Picker
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                    // Show collaborators for all selected repositories
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCollaboratorsList.length,
                        itemBuilder: (context, index) {
                          final repoCollaborators = filteredCollaboratorsList[index];
                          final selectedSet = selectedCollaborators.putIfAbsent(
                              repoCollaborators.repositoryName, () => <String>{});
                          
                          return Card(
                            elevation: 0,
                            child: ExpansionTile(
                              title: Text(repoCollaborators.repositoryName),
                              subtitle: Text('${repoCollaborators.collaborators.length} collaborators'),
                              children: repoCollaborators.collaborators.map((collaborator) {
                                return CheckboxListTile(
                                  title: Text(collaborator.login),
                                  subtitle: Text(collaborator.roleName.isNotEmpty ? collaborator.roleName : 'No role'),
                                  value: selectedSet.contains(collaborator.login),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedSet.add(collaborator.login);
                                      } else {
                                        selectedSet.remove(collaborator.login);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Store context before async operations
                          final navigatorContext = context;
                          
                          // Create a map of repository names to their owners from the selected repos
                          final repoOwnerMap = <String, String>{};
                          for (final repo in widget.selectedRepos) {
                            repoOwnerMap[repo['repo']!] = repo['owner']!;
                          }

                          // Collect selected collaborators for all repositories
                          final selectedRepos = selectedCollaborators.entries
                              .where((entry) => entry.value.isNotEmpty)
                              .map((entry) => {
                                    'owner': repoOwnerMap[entry.key] ?? '',
                                    'repo': entry.key
                                  })
                              .where((repo) => repo['owner']!.isNotEmpty)
                              .toList();

                          final allSelectedCollaborators = selectedCollaborators
                              .values
                              .expand((collaborators) => collaborators)
                              .toList();

                          if (selectedRepos.isEmpty ||
                              allSelectedCollaborators.isEmpty) {
                            printInDebug('No repositories or collaborators selected');
                            return;
                          }

                          printInDebug('Selected repos: $selectedRepos');
                          printInDebug('Selected collaborators: $allSelectedCollaborators');

                          // Use selected start and end dates or default to last 5 years
                          final since = _startDateController.text.isNotEmpty
                              ? DateTime.parse(_startDateController.text)
                              : DateTime.now()
                                  .subtract(const Duration(days: 365 * 5));
                          final until = _endDateController.text.isNotEmpty
                              ? DateTime.parse(_endDateController.text)
                              : DateTime.now();

                          // Call the CommitsNotifier to fetch commits for the selected repos and collaborators
                          await ref
                              .read(commitsNotifierProvider.notifier)
                              .fetchAndCacheRepos(
                                selectedRepos: selectedRepos,
                                selectedCollaborators: allSelectedCollaborators,
                                since: since,
                                until: until,
                              );
                          await ref
                              .read(commitsNotifierProvider.notifier)
                              .fetchCommitFiles();

                          if (mounted) {
                            navigatorContext.goNamed(Routes.chartScreen);
                          }
                        },
                        child: const Text('Fetch Commits'),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(collaboratorsNotifierProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
