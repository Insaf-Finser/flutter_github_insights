import 'package:hive_flutter/hive_flutter.dart';

part 'collaborator.g.dart';

@HiveType(typeId: 5)
class Collaborator extends HiveObject {
  @HiveField(0)
  final String login;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String nodeId;

  @HiveField(3)
  final String avatarUrl;

  @HiveField(4)
  final String url;

  @HiveField(5)
  final String htmlUrl;

  @HiveField(6)
  final String followersUrl;

  @HiveField(7)
  final String followingUrl;

  @HiveField(8)
  final String gistsUrl;

  @HiveField(9)
  final String starredUrl;

  @HiveField(10)
  final String subscriptionsUrl;

  @HiveField(11)
  final String organizationsUrl;

  @HiveField(12)
  final String reposUrl;

  @HiveField(13)
  final String eventsUrl;

  @HiveField(14)
  final String receivedEventsUrl;

  @HiveField(15)
  final String type;

  @HiveField(16)
  final bool siteAdmin;

  @HiveField(17)
  final Map<String, bool> permissions;

  @HiveField(18)
  final String roleName;

  Collaborator({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.siteAdmin,
    required this.permissions,
    required this.roleName,
  });
factory Collaborator.fromMap(Map<String, dynamic> map) {
  try {
    return Collaborator(
      login: map['login'] ?? '',
      id: map['id'] ?? 0,
      nodeId: map['node_id'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
      url: map['url'] ?? '',
      htmlUrl: map['html_url'] ?? '',
      followersUrl: map['followers_url'] ?? '',
      followingUrl: map['following_url'] ?? '',
      gistsUrl: map['gists_url'] ?? '',
      starredUrl: map['starred_url'] ?? '',
      subscriptionsUrl: map['subscriptions_url'] ?? '',
      organizationsUrl: map['organizations_url'] ?? '',
      reposUrl: map['repos_url'] ?? '',
      eventsUrl: map['events_url'] ?? '',
      receivedEventsUrl: map['received_events_url'] ?? '',
      type: map['type'] ?? '',
      siteAdmin: map['site_admin'] ?? false,
      permissions: Map<String, bool>.from(map['permissions'] ?? {}),
      roleName: map['role_name'] ?? '',
    );
  } catch (e) {
    print('Error in Collaborator.fromMap: $e');
    throw e;
  }
}

}
