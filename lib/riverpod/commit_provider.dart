import 'package:git_rest/data/git_operations.dart';
import 'package:git_rest/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'commit_provider.g.dart'; 

@riverpod
Future<Map<String, List<Map<String, dynamic>>>> commitProvider(
  CommitProviderRef ref, {
  required List<Map<String, String>> selectedRepos,
  required List<String> selectedCollaborators,
  required DateTime since,
  required DateTime until,
}) async {
  final token = await getAccessToken();
  final gitOps = GitOperations(token: token); 
  return gitOps.getCommitsForSelectedRepos(
    selectedRepos: selectedRepos,
    selectedCollaborators: selectedCollaborators,
    since: since,
    until: until,
  );
}
