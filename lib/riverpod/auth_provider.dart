import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_rest/constants.dart';
import 'package:git_rest/shared_preferences.dart';
import 'package:go_router/go_router.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

// class TokenNotifier extends StateNotifier<String> {
//   TokenNotifier() : super('0'); // Initialize with the default value

//   Future<void> updateAuthToken(String newToken) async {
//     state = newToken;
//   }
// }

// String firebaseToken = '0';

// Future<String> updateFirebaseToken() async {
//   var user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     firebaseToken = (await user.getIdToken())!;
//   }
//   return firebaseToken;
// }

class AuthProvider extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.initial;
  AuthStatus get authStatus => _authStatus;

  void checkAuthStatus() async {
    final auth = FirebaseAuth.instance;
    _authStatus = auth.currentUser != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  Future<void> signInWithGitHub() async {
    try {
      _authStatus = AuthStatus.loading;
      notifyListeners();

      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      githubAuthProvider.addScope('repo');
      githubAuthProvider.addScope('public_repo');

      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
      final token = userCredential.credential!.accessToken!;
      await setAccessToken(token);

      _authStatus = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      printInDebug(e.toString());
      _authStatus = AuthStatus.initial;

      notifyListeners();
    }
  }

  String? redirect({required GoRouterState state}) {
    final bool isAuthenticated = _authStatus == AuthStatus.authenticated;
    final currentPath = state.fullPath;

    if (!isAuthenticated && currentPath != '/') {
      return '/'; // Redirect to login if not logged in and not on login page
    }

    if (isAuthenticated && currentPath == '/') {
      return '/home'; // Redirect to home if logged in and on login page
    }

    return null; // No redirect needed
  }

  logOut() async {
    await FirebaseAuth.instance.signOut();

    _authStatus = AuthStatus.initial;

    notifyListeners();
  }
}
