import 'package:flutter/material.dart';
import '../models/bible_model.dart';
import '../services/bible_service.dart';

class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  List<BibleBook> _books = [];
  bool _isLoading = true;

  BibleBook? _selectedBook;
  BibleChapter? _selectedChapter;

  bool _isPerjanjianBaru = false;

  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  /// Daftar kitab yang difilter berdasarkan perjanjian yang dipilih
  /// PL: indeks 0-38 (Kejadian - Maleakhi), PB: indeks 39-65 (Matius - Wahyu)
  List<BibleBook> get _filteredBooks {
    if (_books.isEmpty) return [];
    if (_isPerjanjianBaru) {
      // Perjanjian Baru: indeks 39 sampai akhir
      return _books.sublist(39 < _books.length ? 39 : _books.length);
    } else {
      // Perjanjian Lama: indeks 0 sampai 38
      return _books.sublist(0, 39 < _books.length ? 39 : _books.length);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBibleData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBibleData() async {
    final books = await BibleService.loadBible();
    if (mounted) {
      setState(() {
        _books = books;
        if (books.isNotEmpty) {
          _selectedBook = books[0];
          if (books[0].chapters.isNotEmpty) {
            _selectedChapter = books[0].chapters[0];
          }
        }
        _isLoading = false;
      });
    }
  }

  void _searchBook(String query) {
    if (query.trim().isEmpty) return;

    final lowerQuery = query.trim().toLowerCase();
    final found = _books.cast<BibleBook?>().firstWhere(
      (book) => book!.name.toLowerCase().contains(lowerQuery),
      orElse: () => null,
    );

    if (found != null) {
      final bookIndex = _books.indexOf(found);
      setState(() {
        _selectedBook = found;
        _selectedChapter = found.chapters.isNotEmpty
            ? found.chapters.first
            : null;
        _isPerjanjianBaru = bookIndex >= 39;
      });
      _searchController.clear();
      _scrollToTop();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kitab "$query" tidak ditemukan.',
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _goToPreviousChapter() {
    if (_selectedBook == null || _selectedChapter == null) return;

    final currentIndex = _selectedBook!.chapters.indexOf(_selectedChapter!);
    if (currentIndex > 0) {
      setState(() {
        _selectedChapter = _selectedBook!.chapters[currentIndex - 1];
      });
      _scrollToTop();
    } else {
      final bookIndex = _books.indexOf(_selectedBook!);
      if (bookIndex > 0) {
        final prevBook = _books[bookIndex - 1];
        setState(() {
          _selectedBook = prevBook;
          _selectedChapter = prevBook.chapters.isNotEmpty
              ? prevBook.chapters.last
              : null;
          _isPerjanjianBaru = (bookIndex - 1) >= 39;
        });
        _scrollToTop();
      }
    }
  }

  void _goToNextChapter() {
    if (_selectedBook == null || _selectedChapter == null) return;

    final currentIndex = _selectedBook!.chapters.indexOf(_selectedChapter!);
    if (currentIndex < _selectedBook!.chapters.length - 1) {
      setState(() {
        _selectedChapter = _selectedBook!.chapters[currentIndex + 1];
      });
      _scrollToTop();
    } else {
      final bookIndex = _books.indexOf(_selectedBook!);
      if (bookIndex < _books.length - 1) {
        final nextBook = _books[bookIndex + 1];
        setState(() {
          _selectedBook = nextBook;
          _selectedChapter = nextBook.chapters.isNotEmpty
              ? nextBook.chapters.first
              : null;
          _isPerjanjianBaru = (bookIndex + 1) >= 39;
        });
        _scrollToTop();
      }
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.black),
            SizedBox(height: 16),
            Text(
              'Memuat Alkitab...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFF45464D),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildTestamentSelector(),
          const SizedBox(height: 16),
          _buildDropdowns(),
          const SizedBox(height: 24),
          _buildChapterHeader(),
          const SizedBox(height: 24),
          _buildVersesList(),
          const SizedBox(height: 32),
          _buildPagination(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
        textInputAction: TextInputAction.search,
        onSubmitted: _searchBook,
        decoration: InputDecoration(
          hintText: 'Cari nama kitab (misal: Yohanes)...',
          hintStyle: const TextStyle(color: Color(0xFF76777D)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF76777D)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              _searchBook(_searchController.text);
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTestamentSelector() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTestamentTab(
            title: 'Perjanjian Lama',
            isSelected: !_isPerjanjianBaru,
            onTap: () {
              if (_isPerjanjianBaru) {
                setState(() {
                  _isPerjanjianBaru = false;
                  final plBooks = _filteredBooks;
                  if (plBooks.isNotEmpty) {
                    _selectedBook = plBooks.first;
                    _selectedChapter = plBooks.first.chapters.isNotEmpty
                        ? plBooks.first.chapters.first
                        : null;
                  }
                });
                _scrollToTop();
              }
            },
          ),
          _buildTestamentTab(
            title: 'Perjanjian Baru',
            isSelected: _isPerjanjianBaru,
            onTap: () {
              if (!_isPerjanjianBaru) {
                setState(() {
                  _isPerjanjianBaru = true;
                  final pbBooks = _filteredBooks;
                  if (pbBooks.isNotEmpty) {
                    _selectedBook = pbBooks.first;
                    _selectedChapter = pbBooks.first.chapters.isNotEmpty
                        ? pbBooks.first.chapters.first
                        : null;
                  }
                });
                _scrollToTop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestamentTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black : const Color(0xFF45464D),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC6C6CD).withOpacity(0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<BibleBook>(
                value: _selectedBook,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF45464D),
                ),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0B1C30),
                ),
                dropdownColor: const Color(0xFFF8F9FF),
                menuMaxHeight: 400,
                items: _filteredBooks.map((book) {
                  return DropdownMenuItem<BibleBook>(
                    value: book,
                    child: Text(book.name),
                  );
                }).toList(),
                onChanged: (book) {
                  if (book != null) {
                    setState(() {
                      _selectedBook = book;
                      _selectedChapter = book.chapters.isNotEmpty
                          ? book.chapters.first
                          : null;
                    });
                    _scrollToTop();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC6C6CD).withOpacity(0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<BibleChapter>(
                value: _selectedChapter,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF45464D),
                ),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0B1C30),
                ),
                dropdownColor: const Color(0xFFF8F9FF),
                menuMaxHeight: 400,
                items: (_selectedBook?.chapters ?? []).map((chapter) {
                  return DropdownMenuItem<BibleChapter>(
                    value: chapter,
                    child: Text('Pasal ${chapter.cnumber}'),
                  );
                }).toList(),
                onChanged: (chapter) {
                  if (chapter != null) {
                    setState(() {
                      _selectedChapter = chapter;
                    });
                    _scrollToTop();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterHeader() {
    final bookName = _selectedBook?.name ?? '';
    final chapterNum = _selectedChapter?.cnumber ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$bookName $chapterNum',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.menu_book, size: 18, color: Color(0xFF7C839B)),
            SizedBox(width: 4),
            Text(
              'TB (Terjemahan Baru)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7C839B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(color: Color(0xFFC6C6CD), thickness: 0.5),
      ],
    );
  }

  Widget _buildVersesList() {
    final verses = _selectedChapter?.verses ?? [];

    if (verses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Text(
            'Tidak ada ayat untuk ditampilkan.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF45464D),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verse = verses[index];
        return _buildVerseItem(verse.vnumber, verse.text);
      },
    );
  }

  Widget _buildVerseItem(String verseNumber, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                verseNumber,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0B1C30), 
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final bool canGoPrev;
    if (_selectedBook == null || _selectedChapter == null) {
      canGoPrev = false;
    } else {
      final chapterIndex = _selectedBook!.chapters.indexOf(_selectedChapter!);
      final bookIndex = _books.indexOf(_selectedBook!);
      canGoPrev = chapterIndex > 0 || bookIndex > 0;
    }

    final bool canGoNext;
    if (_selectedBook == null || _selectedChapter == null) {
      canGoNext = false;
    } else {
      final chapterIndex = _selectedBook!.chapters.indexOf(_selectedChapter!);
      final bookIndex = _books.indexOf(_selectedBook!);
      canGoNext =
          chapterIndex < _selectedBook!.chapters.length - 1 ||
          bookIndex < _books.length - 1;
    }

    return Container(
      padding: const EdgeInsets.only(top: 24.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: canGoPrev ? _goToPreviousChapter : null,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF45464D),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: canGoPrev
                      ? const Color(0xFF45464D)
                      : const Color(0xFFC6C6CD),
                ),
                const SizedBox(width: 4),
                Text(
                  'Sebelumnya',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: canGoPrev
                        ? const Color(0xFF45464D)
                        : const Color(0xFFC6C6CD),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: canGoNext ? _goToNextChapter : null,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF45464D),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              children: [
                Text(
                  'Selanjutnya',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: canGoNext
                        ? const Color(0xFF45464D)
                        : const Color(0xFFC6C6CD),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: canGoNext
                      ? const Color(0xFF45464D)
                      : const Color(0xFFC6C6CD),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
