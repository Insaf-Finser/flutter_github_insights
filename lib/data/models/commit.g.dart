// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommitAdapter extends TypeAdapter<Commit> {
  @override
  final int typeId = 7;

  @override
  Commit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Commit(
      sha: fields[0] as String,
      message: fields[1] as String,
      author: fields[2] as String,
      date: fields[3] as DateTime,
      url: fields[4] as String,
      stats: fields[5] as CommitStats?,
      files: (fields[6] as List?)?.cast<CommitFile>(),
    );
  }

  @override
  void write(BinaryWriter writer, Commit obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.sha)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.stats)
      ..writeByte(6)
      ..write(obj.files);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommitStatsAdapter extends TypeAdapter<CommitStats> {
  @override
  final int typeId = 9;

  @override
  CommitStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommitStats(
      additions: fields[0] as int,
      deletions: fields[1] as int,
      total: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CommitStats obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.additions)
      ..writeByte(1)
      ..write(obj.deletions)
      ..writeByte(2)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommitFileAdapter extends TypeAdapter<CommitFile> {
  @override
  final int typeId = 10;

  @override
  CommitFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommitFile(
      filename: fields[0] as String,
      status: fields[1] as String,
      changes: fields[2] as int,
      additions: fields[3] as int,
      deletions: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CommitFile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.filename)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.changes)
      ..writeByte(3)
      ..write(obj.additions)
      ..writeByte(4)
      ..write(obj.deletions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
