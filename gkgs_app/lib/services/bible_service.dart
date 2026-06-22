import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import '../models/bible_model.dart';

class BibleService {

  static Future<List<BibleBook>> loadBible() async {
    final xmlString = await rootBundle.loadString('assets/data/Alkitab_TB.xml');

    return compute(_parseBibleXml, xmlString);
  }

  static List<BibleBook> _parseBibleXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final books = <BibleBook>[];

    for (final bookElement in document.findAllElements('BIBLEBOOK')) {
      final bookName = bookElement.getAttribute('bname') ?? 'Tanpa Nama';
      final chapters = <BibleChapter>[];

      for (final chapterElement in bookElement.findElements('CHAPTER')) {
        final chapterNumber = chapterElement.getAttribute('cnumber') ?? '0';
        final verses = <BibleVerse>[];

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
