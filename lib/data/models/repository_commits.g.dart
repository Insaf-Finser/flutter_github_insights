// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_commits.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepositoryCommitsAdapter extends TypeAdapter<RepositoryCommits> {
  @override
  final int typeId = 8;

  @override
  RepositoryCommits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepositoryCommits(
      repositoryName: fields[0] as String,
      commits: (fields[1] as List).cast<Commit>(),
    );
  }

  @override
  void write(BinaryWriter writer, RepositoryCommits obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.repositoryName)
      ..writeByte(1)
      ..write(obj.commits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepositoryCommitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
