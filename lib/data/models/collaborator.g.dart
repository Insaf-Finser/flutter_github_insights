// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollaboratorAdapter extends TypeAdapter<Collaborator> {
  @override
  final int typeId = 5;

  @override
  Collaborator read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collaborator(
      login: fields[0] as String,
      id: fields[1] as int,
      nodeId: fields[2] as String,
      avatarUrl: fields[3] as String,
      url: fields[4] as String,
      htmlUrl: fields[5] as String,
      followersUrl: fields[6] as String,
      followingUrl: fields[7] as String,
      gistsUrl: fields[8] as String,
      starredUrl: fields[9] as String,
      subscriptionsUrl: fields[10] as String,
      organizationsUrl: fields[11] as String,
      reposUrl: fields[12] as String,
      eventsUrl: fields[13] as String,
      receivedEventsUrl: fields[14] as String,
      type: fields[15] as String,
      siteAdmin: fields[16] as bool,
      permissions: (fields[17] as Map).cast<String, bool>(),
      roleName: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Collaborator obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.nodeId)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.htmlUrl)
      ..writeByte(6)
      ..write(obj.followersUrl)
      ..writeByte(7)
      ..write(obj.followingUrl)
      ..writeByte(8)
      ..write(obj.gistsUrl)
      ..writeByte(9)
      ..write(obj.starredUrl)
      ..writeByte(10)
      ..write(obj.subscriptionsUrl)
      ..writeByte(11)
      ..write(obj.organizationsUrl)
      ..writeByte(12)
      ..write(obj.reposUrl)
      ..writeByte(13)
      ..write(obj.eventsUrl)
      ..writeByte(14)
      ..write(obj.receivedEventsUrl)
      ..writeByte(15)
      ..write(obj.type)
      ..writeByte(16)
      ..write(obj.siteAdmin)
      ..writeByte(17)
      ..write(obj.permissions)
      ..writeByte(18)
      ..write(obj.roleName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollaboratorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
