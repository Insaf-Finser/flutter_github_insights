import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:githubinsights/riverpod/user_info_notifier.dart';
import 'package:githubinsights/routes/route_names.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user info when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userInfoProvider.notifier).fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(userInfoProvider.notifier).fetchUserInfo();
            },
          ),
        ],
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userState.error != null
              ? _buildErrorWidget(userState.error!)
              : _buildUserProfile(userState),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading user data',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(userInfoProvider.notifier).clearError();
              ref.read(userInfoProvider.notifier).fetchUserInfo();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(UserInfoState state) {
    final userInfo = state.userInfo;
    if (userInfo == null) {
      return const Center(child: Text('No user information available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          _buildUserProfileSection(userInfo),
          const SizedBox(height: 24),
          
          // Organizations Section
          _buildOrganizationsSection(state.organizations),
          const SizedBox(height: 24),
          
          // All Repositories Section
          _buildRepositoriesSection(state.allRepositories),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(Map<String, dynamic> userInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(userInfo['avatar_url'] ?? ''),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo['name'] ?? userInfo['login'] ?? 'Unknown',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (userInfo['login'] != null)
                        Text(
                          '@${userInfo['login']}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      if (userInfo['bio'] != null)
                        Text(
                          userInfo['bio'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildUserStats(userInfo),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats(Map<String, dynamic> userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Repositories', userInfo['public_repos']?.toString() ?? '0'),
        _buildStatItem('Followers', userInfo['followers']?.toString() ?? '0'),
        _buildStatItem('Following', userInfo['following']?.toString() ?? '0'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationsSection(List<dynamic> organizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organizations (${organizations.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (organizations.isEmpty)
              const Text('No organizations found')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  final org = organizations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(org['avatar_url'] ?? ''),
                    ),
                    title: Text(org['login'] ?? 'Unknown'),
                    subtitle: Text(org['description'] ?? ''),
                    onTap: () {
                      // Navigate to organization details or repositories
                      _showOrganizationRepositories(org['login']);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoriesSection(List<dynamic> repositories) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Repositories (${repositories.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (repositories.isEmpty)
              const Text('No repositories found')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: repositories.length,
                itemBuilder: (context, index) {
                  final repo = repositories[index];
                  return ListTile(
                    leading: Icon(
                      repo['private'] == true ? Icons.lock : Icons.public,
                      color: repo['private'] == true ? Colors.orange : Colors.green,
                    ),
                    title: Text(repo['name'] ?? 'Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (repo['description'] != null)
                          Text(repo['description']),
                        Text(
                          '${repo['owner']['login']} • ${repo['language'] ?? 'Unknown'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(repo['stargazers_count']?.toString() ?? '0'),
                        const SizedBox(width: 8),
                        Icon(Icons.call_split, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(repo['forks_count']?.toString() ?? '0'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to repository details
                      Navigator.pushNamed(
                        context,
                        Routes.repoContentScreen,
                        arguments: {
                          'owner': repo['owner']['login'],
                          'repo': repo['name'],
                        },
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showOrganizationRepositories(String orgName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$orgName Repositories'),
        content: FutureBuilder<List<dynamic>>(
          future: ref.read(userInfoProvider.notifier).fetchRepositoriesWithPagination(
            type: 'org',
            orgName: orgName,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            
            final repos = snapshot.data ?? [];
            if (repos.isEmpty) {
              return const Text('No repositories found');
            }
            
            return SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: repos.length,
                itemBuilder: (context, index) {
                  final repo = repos[index];
                  return ListTile(
                    title: Text(repo['name'] ?? 'Unknown'),
                    subtitle: Text(repo['description'] ?? ''),
                    trailing: Icon(
                      repo['private'] == true ? Icons.lock : Icons.public,
                      color: repo['private'] == true ? Colors.orange : Colors.green,
                    ),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 