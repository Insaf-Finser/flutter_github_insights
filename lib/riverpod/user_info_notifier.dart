import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/data/git_operations.dart';
import 'package:githubinsights/shared_preferences.dart';

final userInfoProvider = StateNotifierProvider<UserInfoNotifier, UserInfoState>((ref) {
  return UserInfoNotifier();
});

class UserInfoState {
  final Map<String, dynamic>? userInfo;
  final List<dynamic> organizations;
  final List<dynamic> allRepositories;
  final bool isLoading;
  final String? error;

  UserInfoState({
    this.userInfo,
    this.organizations = const [],
    this.allRepositories = const [],
    this.isLoading = false,
    this.error,
  });

  UserInfoState copyWith({
    Map<String, dynamic>? userInfo,
    List<dynamic>? organizations,
    List<dynamic>? allRepositories,
    bool? isLoading,
    String? error,
  }) {
    return UserInfoState(
      userInfo: userInfo ?? this.userInfo,
      organizations: organizations ?? this.organizations,
      allRepositories: allRepositories ?? this.allRepositories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserInfoNotifier extends StateNotifier<UserInfoState> {
  UserInfoNotifier() : super(UserInfoState());

  Future<void> fetchUserInfo() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final token = await getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final gitOps = GitOperations(token: token);
      
      // Fetch user information
      final userInfo = await gitOps.getUserInfo();
      
      // Fetch user organizations
      final organizations = await gitOps.getUserOrganizations();
      
      // Fetch all repositories (user + organizations)
      final allRepositories = await gitOps.getAllRepositories();
      
      state = state.copyWith(
        userInfo: userInfo,
        organizations: organizations,
        allRepositories: allRepositories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchOrganizationRepositories(String orgName) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final gitOps = GitOperations(token: token);
      final orgRepos = await gitOps.getOrganizationRepositories(orgName);
      
      // Update all repositories with new org repos
      final updatedRepos = [...state.allRepositories, ...orgRepos];
      state = state.copyWith(allRepositories: updatedRepos);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<List<dynamic>> fetchRepositoriesWithPagination({
    required String type,
    String? orgName,
    int page = 1,
    int perPage = 100,
    String? visibility,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final gitOps = GitOperations(token: token);
      return await gitOps.getRepositoriesWithPagination(
        type: type,
        orgName: orgName,
        page: page,
        perPage: perPage,
        visibility: visibility,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
} 