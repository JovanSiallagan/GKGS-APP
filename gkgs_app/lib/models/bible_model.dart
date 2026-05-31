/// Model untuk satu ayat Alkitab
class BibleVerse {
  final String vnumber; // Nomor ayat (dari atribut vnumber)
  final String text;    // Isi teks ayat

  BibleVerse({required this.vnumber, required this.text});
}

/// Model untuk satu pasal (chapter)
class BibleChapter {
  final String cnumber;        // Nomor pasal (dari atribut cnumber)
  final List<BibleVerse> verses; // Daftar ayat dalam pasal ini

  BibleChapter({required this.cnumber, required this.verses});
}

/// Model untuk satu kitab (book)
class BibleBook {
  final String name;               // Nama kitab (dari atribut bname)
  final List<BibleChapter> chapters; // Daftar pasal dalam kitab ini

  BibleBook({required this.name, required this.chapters});
}
