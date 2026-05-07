class FamilyAltar {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String bibleVerse;
  final String content;

  FamilyAltar({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.bibleVerse,
    required this.content,
  });

  // Fungsi untuk mengubah JSON dari NestJS menjadi Object Flutter
  factory FamilyAltar.fromJson(Map<String, dynamic> json) {
    return FamilyAltar(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      bibleVerse: json['bibleVerse'],
      content: json['content'],
    );
  }
}