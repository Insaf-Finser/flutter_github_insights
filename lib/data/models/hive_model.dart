import 'package:hive_flutter/hive_flutter.dart';
part 'hive_model.g.dart';
@HiveType(typeId: 1)
class Permissions {
  @HiveField(0)
  final bool admin;

  @HiveField(1)
  final bool? maintain;

  @HiveField(2)
  final bool push;

  @HiveField(3)
  final bool? triage;

  @HiveField(4)
  final bool pull;

  Permissions({
    required this.admin,
    this.maintain,
    required this.push,
    this.triage,
    required this.pull,
  });
}

@HiveType(typeId: 2)
class License extends HiveObject {
  @override
  @HiveField(0)
  final String? key;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? spdxId;

  @HiveField(3)
  final String? url;

  @HiveField(4)
  final String? nodeId;

  License({
    this.key,
    this.name,
    this.spdxId,
    this.url,
    this.nodeId,
  });
}

@HiveType(typeId: 3)
class Organization extends HiveObject {
  @HiveField(0)
  final String? login;

  @HiveField(1)
  final int? id;

  @HiveField(2)
  final String? nodeId;

  @HiveField(3)
  final String? url;

  @HiveField(4)
  final String? reposUrl;

  @HiveField(5)
  final String? eventsUrl;

  @HiveField(6)
  final String? hooksUrl;

  @HiveField(7)
  final String? issuesUrl;

  @HiveField(8)
  final String? membersUrl;

  @HiveField(9)
  final String? publicMembersUrl;

  @HiveField(10)
  final String? avatarUrl;

  @HiveField(11)
  final String? description;

  Organization({
    this.login,
    this.id,
    this.nodeId,
    this.url,
    this.reposUrl,
    this.eventsUrl,
    this.hooksUrl,
    this.issuesUrl,
    this.membersUrl,
    this.publicMembersUrl,
    this.avatarUrl,
    this.description,
  });
}

@HiveType(typeId: 4)
class Owner extends HiveObject {
  @HiveField(0)
  final String login;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String? nodeId;

  @HiveField(3)
  final String avatarUrl;

  @HiveField(4)
  final String? gravatarId;

  @HiveField(5)
  final String? url;

  @HiveField(6)
  final String? htmlUrl;

  @HiveField(7)
  final String? followersUrl;

  @HiveField(8)
  final String? followingUrl;

  @HiveField(9)
  final String? gistsUrl;

  @HiveField(10)
  final String? starredUrl;

  @HiveField(11)
  final String? subscriptionsUrl;

  @HiveField(12)
  final String? organizationsUrl;

  @HiveField(13)
  final String? reposUrl;

  @HiveField(14)
  final String? eventsUrl;

  @HiveField(15)
  final String? receivedEventsUrl;

  @HiveField(16)
  final String? type;

  @HiveField(17)
  final bool? siteAdmin;

  Owner({
    required this.login,
    required this.id,
    this.nodeId,
    required this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
  });
}

@HiveType(typeId: 0)
class Repo {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? nodeId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String fullName;

  @HiveField(4)
  final Owner? owner;

  @HiveField(5)
  final bool private;

  @HiveField(6)
  final String? htmlUrl;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final bool? fork;

  @HiveField(9)
  final String? url;

  @HiveField(10)
  final String? forksUrl;

  @HiveField(11)
  final String? keysUrl;

  @HiveField(12)
  final String? collaboratorsUrl;

  @HiveField(13)
  final String? teamsUrl;

  @HiveField(14)
  final String? hooksUrl;

  @HiveField(15)
  final String? issueEventsUrl;

  @HiveField(16)
  final String? eventsUrl;

  @HiveField(17)
  final String? assigneesUrl;

  @HiveField(18)
  final String? branchesUrl;

  @HiveField(19)
  final String? tagsUrl;

  @HiveField(20)
  final String? blobsUrl;

  @HiveField(21)
  final String? gitTagsUrl;

  @HiveField(22)
  final String? gitRefsUrl;

  @HiveField(23)
  final String? treesUrl;

  @HiveField(24)
  final String? statusesUrl;

  @HiveField(25)
  final String? languagesUrl;

  @HiveField(26)
  final String? stargazersUrl;

  @HiveField(27)
  final String? contributorsUrl;

  @HiveField(28)
  final String? subscribersUrl;

  @HiveField(29)
  final String? subscriptionUrl;

  @HiveField(30)
  final String? commitsUrl;

  @HiveField(31)
  final String? gitCommitsUrl;

  @HiveField(32)
  final String? commentsUrl;

  @HiveField(33)
  final String? issueCommentUrl;

  @HiveField(34)
  final String? contentsUrl;

  @HiveField(35)
  final String? compareUrl;

  @HiveField(36)
  final String? mergesUrl;

  @HiveField(37)
  final String? archiveUrl;

  @HiveField(38)
  final String? downloadsUrl;

  @HiveField(39)
  final String? issuesUrl;

  @HiveField(40)
  final String? pullsUrl;

  @HiveField(41)
  final String? milestonesUrl;

  @HiveField(42)
  final String? notificationsUrl;

  @HiveField(43)
  final String? labelsUrl;

  @HiveField(44)
  final String? releasesUrl;

  @HiveField(45)
  final String? deploymentsUrl;

  @HiveField(46)
  final DateTime? createdAt;

  @HiveField(47)
  final DateTime? updatedAt;

  @HiveField(48)
  final DateTime? pushedAt;

  @HiveField(49)
  final String? gitUrl;

  @HiveField(50)
  final String? sshUrl;

  @HiveField(51)
  final String? cloneUrl;

  @HiveField(52)
  final String? svnUrl;

  @HiveField(53)
  final String? homepage;

  @HiveField(54)
  final int? size;

  @HiveField(55)
  final int? stargazersCount;

  @HiveField(56)
  final int? watchersCount;

  @HiveField(57)
  final String? language;

  @HiveField(58)
  final bool? hasIssues;

  @HiveField(59)
  final bool? hasProjects;

  @HiveField(60)
  final bool? hasDownloads;

  @HiveField(61)
  final bool? hasWiki;

  @HiveField(62)
  final bool? hasPages;

  @HiveField(63)
  final int? forksCount;

  @HiveField(64)
  final dynamic mirrorUrl;

  @HiveField(65)
  final bool? archived;

  @HiveField(66)
  final bool? disabled;

  @HiveField(67)
  final int? openIssuesCount;

  @HiveField(68)
  final License? license;

  @HiveField(69)
  final bool? allowForking;

  @HiveField(70)
  final bool? isTemplate;

  @HiveField(71)
  final bool? webCommitSignoffRequired;

  @HiveField(72)
  final List<dynamic>? topics;

  @HiveField(73)
  final String? visibility;

  @HiveField(74)
  final int? forks;

  @HiveField(75)
  final int? openIssues;

  @HiveField(76)
  final int? watchers;

  @HiveField(77)
  final String defaultBranch;

  @HiveField(78)
  final Permissions? permissions;

  @HiveField(79)
  final String? tempCloneToken;

  @HiveField(80)
  final Organization? organization;

  @HiveField(81)
  final int? networkCount;

  @HiveField(82)
  final int? subscribersCount;

  Repo({
    required this.id,
    required this.nodeId,
    required this.name,
    required this.fullName,
    this.owner,
    required this.private,
    this.htmlUrl,
    this.description,
    this.fork,
    this.url,
    this.forksUrl,
    this.keysUrl,
    this.collaboratorsUrl,
    this.teamsUrl,
    this.hooksUrl,
    this.issueEventsUrl,
    this.eventsUrl,
    this.assigneesUrl,
    this.branchesUrl,
    this.tagsUrl,
    this.blobsUrl,
    this.gitTagsUrl,
    this.gitRefsUrl,
    this.treesUrl,
    this.statusesUrl,
    this.languagesUrl,
    this.stargazersUrl,
    this.contributorsUrl,
    this.subscribersUrl,
    this.subscriptionUrl,
    this.commitsUrl,
    this.gitCommitsUrl,
    this.commentsUrl,
    this.issueCommentUrl,
    this.contentsUrl,
    this.compareUrl,
    this.mergesUrl,
    this.archiveUrl,
    this.downloadsUrl,
    this.issuesUrl,
    this.pullsUrl,
    this.milestonesUrl,
    this.notificationsUrl,
    this.labelsUrl,
    this.releasesUrl,
    this.deploymentsUrl,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.gitUrl,
    this.sshUrl,
    this.cloneUrl,
    this.svnUrl,
    this.homepage,
    this.size,
    this.stargazersCount,
    this.watchersCount,
    this.language,
    this.hasIssues,
    this.hasProjects,
    this.hasDownloads,
    this.hasWiki,
    this.hasPages,
    this.forksCount,
    this.mirrorUrl,
    this.archived,
    this.disabled,
    this.openIssuesCount,
    this.license,
    this.allowForking,
    this.isTemplate,
    this.webCommitSignoffRequired,
    this.topics,
    this.visibility,
    this.forks,
    this.openIssues,
    this.watchers,
    required this.defaultBranch,
     this.permissions,
    this.tempCloneToken,
    this.organization,
    this.networkCount,
    this.subscribersCount,
  });
}
