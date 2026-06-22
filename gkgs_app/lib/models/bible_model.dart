class BibleVerse {
  final String vnumber;
  final String text;

  BibleVerse({required this.vnumber, required this.text});
}

class BibleChapter {
  final String cnumber;
  final List<BibleVerse> verses;

  BibleChapter({required this.cnumber, required this.verses});
}

class BibleBook {
  final String name;
  final List<BibleChapter> chapters;

  BibleBook({required this.name, required this.chapters});
}
