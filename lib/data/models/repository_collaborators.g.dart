// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_collaborators.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepositoryCollaboratorsAdapter
    extends TypeAdapter<RepositoryCollaborators> {
  @override
  final int typeId = 6;

  @override
  RepositoryCollaborators read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepositoryCollaborators(
      repositoryName: fields[0] as String,
      collaborators: (fields[1] as List).cast<Collaborator>(),
    );
  }

  @override
  void write(BinaryWriter writer, RepositoryCollaborators obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.repositoryName)
      ..writeByte(1)
      ..write(obj.collaborators);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepositoryCollaboratorsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
