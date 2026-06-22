class CommunityPost {
  final String id;
  final String content;
  final String type;
  final DateTime createdAt;
  final String userName;

  CommunityPost({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.userName,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      content: json['content'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      userName: json['user']['name'],
    );
  }
}