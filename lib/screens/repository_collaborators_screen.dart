import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/constants.dart';
import 'package:githubinsights/data/models/repository_collaborators.dart';
import 'package:githubinsights/riverpod/commit_notifier.dart';
import 'package:githubinsights/riverpod/collaborators_notifier.dart';
import 'package:githubinsights/routes/route_names.dart';
import 'package:go_router/go_router.dart';

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
  // Variable to track the selected repository
  String? _selectedRepository;

  // Separate controllers for start and end dates
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(collaboratorsNotifierProvider.notifier)
            .updateSelectedRepos(widget.selectedRepos);
      });
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collaboratorsAsyncValue = ref.watch(collaboratorsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Repository Collaborators')),
      body: collaboratorsAsyncValue.when(
        data: (collaboratorsList) {
          // Filter the list based on the search query
          final filteredCollaboratorsList =
              collaboratorsList.where((repoCollaborators) {
            return repoCollaborators.repositoryName
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                repoCollaborators.collaborators.any((collaborator) =>
                    collaborator.login
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()));
          }).toList();

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
              // Dropdown to select repository
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedRepository,
                  hint: const Text('Select Repository'),
                  items: widget.selectedRepos
                      .map((repo) => DropdownMenuItem<String>(
                            value: repo['repo'],
                            child: Text(repo['repo'] ?? ''),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRepository = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              // Show collaborators for the selected repository
              if (_selectedRepository != null)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final repoCollaborators = filteredCollaboratorsList.firstWhere(
                        (repo) => repo.repositoryName == _selectedRepository,
                        orElse: () => RepositoryCollaborators(
                          repositoryName: _selectedRepository!,
                          collaborators: [],
                        ),
                      );
                      if (repoCollaborators.collaborators.isEmpty) {
                        return const Center(child: Text('No collaborators found.'));
                      }
                      final selectedSet = selectedCollaborators.putIfAbsent(
                          repoCollaborators.repositoryName, () => <String>{});
                      return ListView(
                        children: repoCollaborators.collaborators.map((collaborator) {
                          return CheckboxListTile(
                            title: Text(collaborator.login),
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
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Collect selected collaborators for all repositories
                    final selectedRepos = selectedCollaborators.entries
                        .where((entry) => entry.value.isNotEmpty)
                        .map((entry) => {
                              'owner': entry.value.toString(),
                              'repo': entry.key
                            })
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
                      context.goNamed(Routes.chartScreen);
                    }
                  },
                  child: const Text('Fetch Commits'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
