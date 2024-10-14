import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/riverpod/auth_provider.dart';
import 'package:githubinsights/routes/routes.dart';
import 'package:githubinsights/screens/error_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) {
    final auth = ref.watch(authProvider);
    return GoRouter(
      refreshListenable: auth,
      redirect: (context, state) => auth.redirect(state: state),
      errorPageBuilder: (context, state) =>
          const MaterialPage(child: ErrorScreen()),
      initialLocation: '/',
      routes: routes,
    );
  },
);
