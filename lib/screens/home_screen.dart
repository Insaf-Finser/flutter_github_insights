import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/constants.dart';
import 'package:githubinsights/data/git_operations.dart';
import 'package:githubinsights/data/models/git_repo_model.dart';
import 'package:githubinsights/riverpod/collaborators_notifier.dart';
import 'package:githubinsights/riverpod/repo_notifier.dart';
import 'package:githubinsights/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final RepoNotifier repoNotifier;
  late final CollaboratorsNotifier collaboratorsNotifier;
  List<Map<String, String>> selectedRepos =
      []; // List to keep track of selected repos
  bool get _hasSelectedRepos =>
      selectedRepos.isNotEmpty; // Check if any checkboxes are selected
  final TextEditingController searchController =
      TextEditingController(); // Controller for search input
  String searchQuery = ''; // Variable to store search query

  @override
  void initState() {
    super.initState();
    repoNotifier = ref.read(repoNotifierProvider.notifier);
    collaboratorsNotifier = ref.read(collaboratorsNotifierProvider.notifier);

    repoNotifier.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final asyncRepos = ref.watch(repoNotifierProvider);

    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search repositories...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value
                      .toLowerCase(); // Update the search query on text change
                });
              },
            ),
          ),
          Expanded(
            child: asyncRepos.when(
              data: (repos) {
                final filteredRepos = repos.where((repo) {
                  final repoName = repo.name.toLowerCase();
                  final ownerName = repo.owner?.login?.toLowerCase() ?? '';
                  return repoName.contains(searchQuery) ||
                      ownerName.contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredRepos.length,
                  itemBuilder: (context, index) {
                    final repo = filteredRepos[index];
                    final isChecked = selectedRepos.any(
                      (item) =>
                          item['repo'] == repo.name &&
                          item['owner'] == repo.owner?.login,
                    );

                    return Card(
                      elevation: 0,
                      child: ListTile(
                        trailing: Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedRepos.add({
                                  'repo': repo.name,
                                  'owner': repo.owner?.login ?? '',
                                });
                              } else {
                                selectedRepos.removeWhere(
                                  (item) =>
                                      item['repo'] == repo.name &&
                                      item['owner'] == repo.owner?.login,
                                );
                              }
                            });
                          },
                        ),
                        title: Text(repo.name),
                        subtitle: Text(repo.owner?.login ?? ''),
                        onTap: () => context.pushNamed(
                          Routes.repoContentScreen,
                          extra: {
                            'repo': GitRepo(
                                id: repo.id,
                                nodeId: repo.nodeId,
                                name: repo.name,
                                fullName: repo.fullName,
                                owner: Owner(
                                    login: repo.owner!.login,
                                    id: repo.owner!.id,
                                    avatarUrl: repo.owner!.avatarUrl),
                                private: repo.private,
                                defaultBranch: repo.defaultBranch,
                                permissions: Permissions(
                                    admin: repo.permissions!.admin,
                                    push: repo.permissions!.push,
                                    pull: repo.permissions!.pull)),
                            'ops': repoNotifier.ops
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: Fab(repoNotifier: repoNotifier),
    );
  }

  AppBar customAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          foregroundImage: NetworkImage(
            FirebaseAuth.instance.currentUser?.providerData
                    .firstWhere((element) => element.providerId == 'github.com')
                    .photoURL ??
                '',
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            repoNotifier.updateCache();
          },
          tooltip: 'Update Cache',
        ),
        if (_hasSelectedRepos)
          IconButton(
            icon: const Icon(Icons.arrow_circle_right),
            onPressed: () async {
              await collaboratorsNotifier.updateSelectedRepos(selectedRepos);
              context.pushNamed(Routes.repositoryCollaboratorsScreen);
            },
            tooltip: 'Update repo',
          ),
      ],
    );
  }
}

class Fab extends StatelessWidget {
  const Fab({
    super.key,
    required this.repoNotifier,
  });

  final RepoNotifier repoNotifier;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              NewRepoDialog(gitOperations: repoNotifier.ops),
            ],
          ),
        );

        repoNotifier.updateCache();
      },
      child: const Icon(Icons.add),
    );
  }
}

class NewRepoDialog extends StatefulWidget {
  const NewRepoDialog({
    super.key,
    required this.gitOperations,
  });
  final GitOperations gitOperations;

  @override
  State<NewRepoDialog> createState() => _NewRepoDialogState();
}

class _NewRepoDialogState extends State<NewRepoDialog> {
  bool isPrivate = false;
  final nameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Create New Repo:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 15),
          Card(
            elevation: 0,
            child: TextFormField(
              controller: nameC,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixText: ' Name: ',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Public ',
                style:
                    TextStyle(fontWeight: !isPrivate ? FontWeight.bold : null),
              ),
              Switch(
                value: isPrivate,
                onChanged: (val) => setState(() => isPrivate = val),
              ),
              Text(
                ' Private',
                style:
                    TextStyle(fontWeight: isPrivate ? FontWeight.bold : null),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                onPressed: () async {
                  try {
                    await widget.gitOperations
                        .createRepository(nameC.text, isPrivate)
                        .then((_) => context.pop());
                  } on Exception catch (e) {
                    printInDebug(e.toString());
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
