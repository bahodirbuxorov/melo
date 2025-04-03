class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String avatarUrl;
  final bool isOnline;
  final DateTime? lastSeen;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isOnline,
    this.lastSeen,
  });
}
