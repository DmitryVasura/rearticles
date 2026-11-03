class AuthorProfile {
  final int id;
  final String username;
  final int articlesCount;
  final int likesReceived;

  const AuthorProfile({
    required this.id,
    required this.username,
    required this.articlesCount,
    required this.likesReceived,
  });

  factory AuthorProfile.fromJson(Map<String, dynamic> json) {
    return AuthorProfile(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      articlesCount: (json['articlesCount'] as num?)?.toInt() ?? 0,
      likesReceived: (json['likesReceived'] as num?)?.toInt() ?? 0,
    );
  }
}