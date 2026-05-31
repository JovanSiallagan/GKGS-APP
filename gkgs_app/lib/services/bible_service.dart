import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import '../models/bible_model.dart';

class BibleService {
  /// Memuat dan mem-parse file XML Alkitab dari assets.
  /// Menggunakan compute() agar parsing berjalan di background thread
  /// sehingga UI tidak freeze.
  static Future<List<BibleBook>> loadBible() async {
    // 1. Baca file XML dari assets sebagai string
    final xmlString = await rootBundle.loadString('assets/data/Alkitab_TB.xml');

    // 2. Parse di background thread menggunakan compute()
    return compute(_parseBibleXml, xmlString);
  }

  /// Fungsi top-level (atau static) yang akan dijalankan di isolate terpisah.
  /// compute() membutuhkan fungsi top-level atau static.
  static List<BibleBook> _parseBibleXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final books = <BibleBook>[];

    // Cari semua elemen <BIBLEBOOK>
    for (final bookElement in document.findAllElements('BIBLEBOOK')) {
      final bookName = bookElement.getAttribute('bname') ?? 'Tanpa Nama';
      final chapters = <BibleChapter>[];

      // Cari semua elemen <CHAPTER> di dalam setiap <BIBLEBOOK>
      for (final chapterElement in bookElement.findElements('CHAPTER')) {
        final chapterNumber = chapterElement.getAttribute('cnumber') ?? '0';
        final verses = <BibleVerse>[];

        // Cari semua elemen <VERS> di dalam setiap <CHAPTER>
        for (final verseElement in chapterElement.findElements('VERS')) {
          final verseNumber = verseElement.getAttribute('vnumber') ?? '0';
          final verseText = verseElement.innerText;

          verses.add(BibleVerse(vnumber: verseNumber, text: verseText));
        }

        chapters.add(BibleChapter(cnumber: chapterNumber, verses: verses));
      }

      books.add(BibleBook(name: bookName, chapters: chapters));
    }

    return books;
  }
}
