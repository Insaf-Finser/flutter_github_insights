import 'package:githubinsights/data/git_operations.dart';
import 'package:githubinsights/data/models/git_repo_model.dart';
import 'package:githubinsights/routes/route_names.dart';
import 'package:githubinsights/screens/chart_screen.dart';
import 'package:githubinsights/screens/home_screen.dart';
import 'package:githubinsights/screens/repo_contents_screen.dart';
import 'package:githubinsights/screens/repository_collaborators_screen.dart';

import 'package:githubinsights/screens/welome_screen.dart';
// Import the new screen

import 'package:go_router/go_router.dart';

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
          return const RepositoryCollaboratorsScreen();
        },
      ),
      GoRoute(
        path: 'chartScreen', // Path for ChartScreen
        name: Routes.chartScreen, // Name for ChartScreen
        builder: (context, state) {
          return const ChartScreen(); // Returning the ChartScreen widget
        },
      ),
    ],
  ),
];
