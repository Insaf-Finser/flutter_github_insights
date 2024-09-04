import 'package:git_rest/data/git_operations.dart';
import 'package:git_rest/data/models/git_repo_model.dart';
import 'package:git_rest/routes/route_names.dart';
import 'package:git_rest/screens/home_screen.dart';
import 'package:git_rest/screens/repo_contents_screen.dart';

import 'package:git_rest/screens/welome_screen.dart';
 // Import the new screen

import 'package:go_router/go_router.dart';

import '../screens/repository_collaborators_screen';

final List<GoRoute> routes = [
  GoRoute(
    path: '/',
    name: Routes.welcomeScreen,
    builder: (context, state) => const WelcomeScreen(),
  ),
  GoRoute(
    path: '/${Routes.homeScreen}',
    name: Routes.homeScreen,
    builder: (context, state) => const HomeScreen(),
    routes: [
      GoRoute(
        path: Routes.repoContentScreen,
        name: Routes.repoContentScreen,
        builder: (context, state) {
          var map = state.extra! as Map;
          return RepoContentScreen(
            repo: map['repo'] as GitRepo,
            ops: map['ops'] as GitOperations,
          );
        },
      ),
      GoRoute(
        path: 'repositoryCollaborators', // Updated path
        name: 'repositoryCollaborators', // Updated name
        builder: (context, state) {
          // No need for extra data for this screen
          return  RepositoryCollaboratorsScreen();
        },
      ),
    ],
  ),
];
