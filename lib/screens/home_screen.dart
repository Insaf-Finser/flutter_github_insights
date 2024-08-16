import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_rest/constants.dart';
import 'package:git_rest/data/git_operations.dart';
import 'package:git_rest/data/models/git_repo_model.dart';
import 'package:git_rest/routes/route_names.dart';
import 'package:git_rest/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GitOperations ops = GitOperations(token: '');
  final User user = FirebaseAuth.instance.currentUser!;

  List<GitRepo> gitRepos = [];

  fetchToken() async {
    var token = await getAccessToken();
    ops = GitOperations(token: token);

    setState(() {});
  }

  fetchAllRepos() async {
    final data = await ops.listRepositories(true);
    for (var repoData in data) {
      gitRepos.add(GitRepo.fromMap(repoData));
    }

    setState(() {});
  }

  initialise() async {
    await fetchToken();
    await fetchAllRepos();
  }

  @override
  void initState() {
    initialise();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final githubProvider = user.providerData
        .firstWhere((element) => element.providerId == 'github.com');

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            foregroundImage: NetworkImage(githubProvider.photoURL!),
          ),
        ),
      ),
      body: ops.token.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gitRepos.length,
              itemBuilder: (context, index) {
                final repo = gitRepos.elementAt(index);

                return Card(
                  elevation: 0,
                  child: ListTile(
                    title: Text(repo.name),
                    onTap: () => context.pushNamed(Routes.repoContentScreen,
                        extra: {'repo': repo, 'ops': ops}),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              children: [
                NewRepoDialog(gitOperations: ops),
              ],
            ),
          );

          await fetchAllRepos();
        },
        child: const Icon(Icons.add),
      ),
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
          Wrap(children: [
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
                      Theme.of(context).colorScheme.secondaryContainer)),
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
          ])
        ],
      ),
    );
  }
}
