import 'package:git_rest/data/models/commit.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'repository_commits.g.dart';

@HiveType(typeId: 8)
class RepositoryCommits extends HiveObject {
  @HiveField(0)
  String repositoryName;

  @HiveField(1)
  List<Commit> commits;

  RepositoryCommits({
    required this.repositoryName,
    required this.commits,
  });
}
