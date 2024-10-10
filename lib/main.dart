import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_rest/data/models/collaborator.dart';
import 'package:git_rest/data/models/commit.dart';
import 'package:git_rest/data/models/hive_model.dart';
import 'package:git_rest/data/models/repository_collaborators.dart';
import 'package:git_rest/data/models/repository_commits.dart';
import 'package:git_rest/firebase_options.dart';
import 'package:git_rest/riverpod/auth_provider.dart';
import 'package:git_rest/riverpod/router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); //flutterfire config (firebase_options.dart)
  await Hive.initFlutter();

  Hive.registerAdapter(RepoAdapter());
  Hive.registerAdapter(OwnerAdapter());
  Hive.registerAdapter(PermissionsAdapter());
  Hive.registerAdapter(CollaboratorAdapter());
  Hive.registerAdapter(RepositoryCollaboratorsAdapter());
  Hive.registerAdapter(CommitAdapter());
  Hive.registerAdapter(RepositoryCommitsAdapter());
  Hive.registerAdapter(CommitStatsAdapter());
  Hive.registerAdapter(CommitFileAdapter());

  // Hive.deleteBoxFromDisk('gitReposBox');
  // Hive.deleteBoxFromDisk('repository_collaborators_box');
  await Hive.openBox<Repo>('gitReposBox');
  await Hive.openBox<RepositoryCollaborators>('repository_collaborators_box');
  await Hive.openBox<RepositoryCommits>('gitCommitsBox');

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authProvider).checkAuthStatus();

    return MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
