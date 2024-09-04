import 'package:hive_flutter/hive_flutter.dart';

import 'collaborator.dart';

part 'repository_collaborators.g.dart';

@HiveType(typeId: 6)
class RepositoryCollaborators extends HiveObject {
  @HiveField(0)
  final String repositoryName;

  @HiveField(1)
  final List<Collaborator> collaborators;

  RepositoryCollaborators({
    required this.repositoryName,
    required this.collaborators,
  });
}
