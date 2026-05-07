class CommunityPost {
  final String id;
  final String content;
  final String type; // 'PRAYER' atau 'TESTIMONY'
  final DateTime createdAt;
  final String userName; // Nama yang posting

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
      userName: json['user']['name'], // Mengambil nama dari relasi user di NestJS
    );
  }
}