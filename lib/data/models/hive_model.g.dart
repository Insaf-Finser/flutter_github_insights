// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PermissionsAdapter extends TypeAdapter<Permissions> {
  @override
  final int typeId = 1;

  @override
  Permissions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Permissions(
      admin: fields[0] as bool,
      maintain: fields[1] as bool?,
      push: fields[2] as bool,
      triage: fields[3] as bool?,
      pull: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Permissions obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.admin)
      ..writeByte(1)
      ..write(obj.maintain)
      ..writeByte(2)
      ..write(obj.push)
      ..writeByte(3)
      ..write(obj.triage)
      ..writeByte(4)
      ..write(obj.pull);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LicenseAdapter extends TypeAdapter<License> {
  @override
  final int typeId = 2;

  @override
  License read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return License(
      key: fields[0] as String?,
      name: fields[1] as String?,
      spdxId: fields[2] as String?,
      url: fields[3] as String?,
      nodeId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, License obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.spdxId)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.nodeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrganizationAdapter extends TypeAdapter<Organization> {
  @override
  final int typeId = 3;

  @override
  Organization read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Organization(
      login: fields[0] as String?,
      id: fields[1] as int?,
      nodeId: fields[2] as String?,
      url: fields[3] as String?,
      reposUrl: fields[4] as String?,
      eventsUrl: fields[5] as String?,
      hooksUrl: fields[6] as String?,
      issuesUrl: fields[7] as String?,
      membersUrl: fields[8] as String?,
      publicMembersUrl: fields[9] as String?,
      avatarUrl: fields[10] as String?,
      description: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Organization obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.nodeId)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.reposUrl)
      ..writeByte(5)
      ..write(obj.eventsUrl)
      ..writeByte(6)
      ..write(obj.hooksUrl)
      ..writeByte(7)
      ..write(obj.issuesUrl)
      ..writeByte(8)
      ..write(obj.membersUrl)
      ..writeByte(9)
      ..write(obj.publicMembersUrl)
      ..writeByte(10)
      ..write(obj.avatarUrl)
      ..writeByte(11)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OwnerAdapter extends TypeAdapter<Owner> {
  @override
  final int typeId = 4;

  @override
  Owner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Owner(
      login: fields[0] as String,
      id: fields[1] as int,
      nodeId: fields[2] as String?,
      avatarUrl: fields[3] as String,
      gravatarId: fields[4] as String?,
      url: fields[5] as String?,
      htmlUrl: fields[6] as String?,
      followersUrl: fields[7] as String?,
      followingUrl: fields[8] as String?,
      gistsUrl: fields[9] as String?,
      starredUrl: fields[10] as String?,
      subscriptionsUrl: fields[11] as String?,
      organizationsUrl: fields[12] as String?,
      reposUrl: fields[13] as String?,
      eventsUrl: fields[14] as String?,
      receivedEventsUrl: fields[15] as String?,
      type: fields[16] as String?,
      siteAdmin: fields[17] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Owner obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.nodeId)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.gravatarId)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.htmlUrl)
      ..writeByte(7)
      ..write(obj.followersUrl)
      ..writeByte(8)
      ..write(obj.followingUrl)
      ..writeByte(9)
      ..write(obj.gistsUrl)
      ..writeByte(10)
      ..write(obj.starredUrl)
      ..writeByte(11)
      ..write(obj.subscriptionsUrl)
      ..writeByte(12)
      ..write(obj.organizationsUrl)
      ..writeByte(13)
      ..write(obj.reposUrl)
      ..writeByte(14)
      ..write(obj.eventsUrl)
      ..writeByte(15)
      ..write(obj.receivedEventsUrl)
      ..writeByte(16)
      ..write(obj.type)
      ..writeByte(17)
      ..write(obj.siteAdmin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepoAdapter extends TypeAdapter<Repo> {
  @override
  final int typeId = 0;

  @override
  Repo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repo(
      id: fields[0] as int,
      nodeId: fields[1] as String?,
      name: fields[2] as String,
      fullName: fields[3] as String,
      owner: fields[4] as Owner?,
      private: fields[5] as bool,
      htmlUrl: fields[6] as String?,
      description: fields[7] as String?,
      fork: fields[8] as bool?,
      url: fields[9] as String?,
      forksUrl: fields[10] as String?,
      keysUrl: fields[11] as String?,
      collaboratorsUrl: fields[12] as String?,
      teamsUrl: fields[13] as String?,
      hooksUrl: fields[14] as String?,
      issueEventsUrl: fields[15] as String?,
      eventsUrl: fields[16] as String?,
      assigneesUrl: fields[17] as String?,
      branchesUrl: fields[18] as String?,
      tagsUrl: fields[19] as String?,
      blobsUrl: fields[20] as String?,
      gitTagsUrl: fields[21] as String?,
      gitRefsUrl: fields[22] as String?,
      treesUrl: fields[23] as String?,
      statusesUrl: fields[24] as String?,
      languagesUrl: fields[25] as String?,
      stargazersUrl: fields[26] as String?,
      contributorsUrl: fields[27] as String?,
      subscribersUrl: fields[28] as String?,
      subscriptionUrl: fields[29] as String?,
      commitsUrl: fields[30] as String?,
      gitCommitsUrl: fields[31] as String?,
      commentsUrl: fields[32] as String?,
      issueCommentUrl: fields[33] as String?,
      contentsUrl: fields[34] as String?,
      compareUrl: fields[35] as String?,
      mergesUrl: fields[36] as String?,
      archiveUrl: fields[37] as String?,
      downloadsUrl: fields[38] as String?,
      issuesUrl: fields[39] as String?,
      pullsUrl: fields[40] as String?,
      milestonesUrl: fields[41] as String?,
      notificationsUrl: fields[42] as String?,
      labelsUrl: fields[43] as String?,
      releasesUrl: fields[44] as String?,
      deploymentsUrl: fields[45] as String?,
      createdAt: fields[46] as DateTime?,
      updatedAt: fields[47] as DateTime?,
      pushedAt: fields[48] as DateTime?,
      gitUrl: fields[49] as String?,
      sshUrl: fields[50] as String?,
      cloneUrl: fields[51] as String?,
      svnUrl: fields[52] as String?,
      homepage: fields[53] as String?,
      size: fields[54] as int?,
      stargazersCount: fields[55] as int?,
      watchersCount: fields[56] as int?,
      language: fields[57] as String?,
      hasIssues: fields[58] as bool?,
      hasProjects: fields[59] as bool?,
      hasDownloads: fields[60] as bool?,
      hasWiki: fields[61] as bool?,
      hasPages: fields[62] as bool?,
      forksCount: fields[63] as int?,
      mirrorUrl: fields[64] as dynamic,
      archived: fields[65] as bool?,
      disabled: fields[66] as bool?,
      openIssuesCount: fields[67] as int?,
      license: fields[68] as License?,
      allowForking: fields[69] as bool?,
      isTemplate: fields[70] as bool?,
      webCommitSignoffRequired: fields[71] as bool?,
      topics: (fields[72] as List?)?.cast<dynamic>(),
      visibility: fields[73] as String?,
      forks: fields[74] as int?,
      openIssues: fields[75] as int?,
      watchers: fields[76] as int?,
      defaultBranch: fields[77] as String,
      permissions: fields[78] as Permissions?,
      tempCloneToken: fields[79] as String?,
      organization: fields[80] as Organization?,
      networkCount: fields[81] as int?,
      subscribersCount: fields[82] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Repo obj) {
    writer
      ..writeByte(83)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nodeId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.owner)
      ..writeByte(5)
      ..write(obj.private)
      ..writeByte(6)
      ..write(obj.htmlUrl)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.fork)
      ..writeByte(9)
      ..write(obj.url)
      ..writeByte(10)
      ..write(obj.forksUrl)
      ..writeByte(11)
      ..write(obj.keysUrl)
      ..writeByte(12)
      ..write(obj.collaboratorsUrl)
      ..writeByte(13)
      ..write(obj.teamsUrl)
      ..writeByte(14)
      ..write(obj.hooksUrl)
      ..writeByte(15)
      ..write(obj.issueEventsUrl)
      ..writeByte(16)
      ..write(obj.eventsUrl)
      ..writeByte(17)
      ..write(obj.assigneesUrl)
      ..writeByte(18)
      ..write(obj.branchesUrl)
      ..writeByte(19)
      ..write(obj.tagsUrl)
      ..writeByte(20)
      ..write(obj.blobsUrl)
      ..writeByte(21)
      ..write(obj.gitTagsUrl)
      ..writeByte(22)
      ..write(obj.gitRefsUrl)
      ..writeByte(23)
      ..write(obj.treesUrl)
      ..writeByte(24)
      ..write(obj.statusesUrl)
      ..writeByte(25)
      ..write(obj.languagesUrl)
      ..writeByte(26)
      ..write(obj.stargazersUrl)
      ..writeByte(27)
      ..write(obj.contributorsUrl)
      ..writeByte(28)
      ..write(obj.subscribersUrl)
      ..writeByte(29)
      ..write(obj.subscriptionUrl)
      ..writeByte(30)
      ..write(obj.commitsUrl)
      ..writeByte(31)
      ..write(obj.gitCommitsUrl)
      ..writeByte(32)
      ..write(obj.commentsUrl)
      ..writeByte(33)
      ..write(obj.issueCommentUrl)
      ..writeByte(34)
      ..write(obj.contentsUrl)
      ..writeByte(35)
      ..write(obj.compareUrl)
      ..writeByte(36)
      ..write(obj.mergesUrl)
      ..writeByte(37)
      ..write(obj.archiveUrl)
      ..writeByte(38)
      ..write(obj.downloadsUrl)
      ..writeByte(39)
      ..write(obj.issuesUrl)
      ..writeByte(40)
      ..write(obj.pullsUrl)
      ..writeByte(41)
      ..write(obj.milestonesUrl)
      ..writeByte(42)
      ..write(obj.notificationsUrl)
      ..writeByte(43)
      ..write(obj.labelsUrl)
      ..writeByte(44)
      ..write(obj.releasesUrl)
      ..writeByte(45)
      ..write(obj.deploymentsUrl)
      ..writeByte(46)
      ..write(obj.createdAt)
      ..writeByte(47)
      ..write(obj.updatedAt)
      ..writeByte(48)
      ..write(obj.pushedAt)
      ..writeByte(49)
      ..write(obj.gitUrl)
      ..writeByte(50)
      ..write(obj.sshUrl)
      ..writeByte(51)
      ..write(obj.cloneUrl)
      ..writeByte(52)
      ..write(obj.svnUrl)
      ..writeByte(53)
      ..write(obj.homepage)
      ..writeByte(54)
      ..write(obj.size)
      ..writeByte(55)
      ..write(obj.stargazersCount)
      ..writeByte(56)
      ..write(obj.watchersCount)
      ..writeByte(57)
      ..write(obj.language)
      ..writeByte(58)
      ..write(obj.hasIssues)
      ..writeByte(59)
      ..write(obj.hasProjects)
      ..writeByte(60)
      ..write(obj.hasDownloads)
      ..writeByte(61)
      ..write(obj.hasWiki)
      ..writeByte(62)
      ..write(obj.hasPages)
      ..writeByte(63)
      ..write(obj.forksCount)
      ..writeByte(64)
      ..write(obj.mirrorUrl)
      ..writeByte(65)
      ..write(obj.archived)
      ..writeByte(66)
      ..write(obj.disabled)
      ..writeByte(67)
      ..write(obj.openIssuesCount)
      ..writeByte(68)
      ..write(obj.license)
      ..writeByte(69)
      ..write(obj.allowForking)
      ..writeByte(70)
      ..write(obj.isTemplate)
      ..writeByte(71)
      ..write(obj.webCommitSignoffRequired)
      ..writeByte(72)
      ..write(obj.topics)
      ..writeByte(73)
      ..write(obj.visibility)
      ..writeByte(74)
      ..write(obj.forks)
      ..writeByte(75)
      ..write(obj.openIssues)
      ..writeByte(76)
      ..write(obj.watchers)
      ..writeByte(77)
      ..write(obj.defaultBranch)
      ..writeByte(78)
      ..write(obj.permissions)
      ..writeByte(79)
      ..write(obj.tempCloneToken)
      ..writeByte(80)
      ..write(obj.organization)
      ..writeByte(81)
      ..write(obj.networkCount)
      ..writeByte(82)
      ..write(obj.subscribersCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
