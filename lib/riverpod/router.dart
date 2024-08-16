import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_rest/riverpod/auth_provider.dart';
import 'package:git_rest/routes/routes.dart';
import 'package:git_rest/screens/error_screen.dart';
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
