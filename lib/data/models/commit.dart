import 'package:hive_flutter/hive_flutter.dart';

part 'commit.g.dart';

@HiveType(typeId: 7)
class Commit extends HiveObject {
  @HiveField(0)
  String sha;

  @HiveField(1)
  String message;

  @HiveField(2)
  String author;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String url;

  @HiveField(5)
  CommitStats? stats;

  @HiveField(6)
  List<CommitFile>? files;

  Commit({
    required this.sha,
    required this.message,
    required this.author,
    required this.date,
    required this.url,
     this.stats,
    this.files,
  });
}

@HiveType(typeId: 9)
class CommitStats extends HiveObject {
  @HiveField(0)
  int additions;

  @HiveField(1)
  int deletions;

  @HiveField(2)
  int total;

  CommitStats({
    required this.additions,
    required this.deletions,
    required this.total,
  });
}

@HiveType(typeId: 10)
class CommitFile extends HiveObject {
  @HiveField(0)
  String filename;

  @HiveField(1)
  String status;

  @HiveField(2)
  int changes;

  @HiveField(3)
  int additions;

  @HiveField(4)
  int deletions;

  CommitFile({
    required this.filename,
    required this.status,
    required this.changes,
    required this.additions,
    required this.deletions,
  });
}
