import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_rest/constants.dart';
import 'package:git_rest/riverpod/commit_notifier.dart';
import 'package:git_rest/riverpod/collaborators_notifier.dart';
import 'package:git_rest/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class RepositoryCollaboratorsScreen extends ConsumerStatefulWidget {
  const RepositoryCollaboratorsScreen({super.key});

  @override
  ConsumerState<RepositoryCollaboratorsScreen> createState() =>
      _RepositoryCollaboratorsScreenState();
}

class _RepositoryCollaboratorsScreenState
    extends ConsumerState<RepositoryCollaboratorsScreen> {
  // Map to store the selected collaborators for each repository
  final selectedCollaborators = <String, Set<String>>{};

  // Date controllers for start and end date
  DateTime? _startDate;
  DateTime? _endDate;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now().subtract(const Duration(days: 365))
          : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
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
              // Date pickers for start and end dates
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              hintText: _startDate != null
                                  ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                  : 'Select Start Date',
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              hintText: _endDate != null
                                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                  : 'Select End Date',
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCollaboratorsList.length,
                  itemBuilder: (context, index) {
                    final repoCollaborators = filteredCollaboratorsList[index];
                    // Initialize set of selected collaborators for the current repository
                    final selectedSet = selectedCollaborators.putIfAbsent(
                        repoCollaborators.repositoryName, () => <String>{});

                    return Card(
                      elevation: 0,
                      child: ExpansionTile(
                        title: Text(repoCollaborators.repositoryName),
                        children:
                            repoCollaborators.collaborators.map((collaborator) {
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
                      ),
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
                        .map((entry) =>
                            {'owner': 'Harsh-Vipin', 'repo': entry.key})
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
                    final since = _startDate ??
                        DateTime.now().subtract(const Duration(days: 365 * 5));
                    final until = _endDate ?? DateTime.now();

                    // Call the CommitsNotifier to fetch commits for the selected repos and collaborators
                    ref
                        .read(commitsNotifierProvider.notifier)
                        .fetchAndCacheRepos(
                          selectedRepos: selectedRepos,
                          selectedCollaborators: allSelectedCollaborators,
                          since: since,
                          until: until,
                        );
                    ref
                        .read(commitsNotifierProvider.notifier)
                        .fetchCommitFiles();

                    context.goNamed(Routes.chartScreen);
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
