import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class WartaJemaatScreen extends StatefulWidget {
  const WartaJemaatScreen({super.key});

  @override
  State<WartaJemaatScreen> createState() => _WartaJemaatScreenState();
}

class _WartaJemaatScreenState extends State<WartaJemaatScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>?> _wartaFuture;

  @override
  void initState() {
    super.initState();
    _wartaFuture = _apiService.getLatestWarta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // clean, airy background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1C30)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Warta Jemaat',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _wartaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Belum ada warta jemaat terbaru."));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroImage(data['imageUrl']),
                const SizedBox(height: 24),
                _buildTitleSection(data),
                const SizedBox(height: 32),
                _buildContentSection(data),
                const SizedBox(height: 32),
                const SizedBox(height: 32), // Safe area bottom
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroImage(String? imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl) as ImageProvider
              : const NetworkImage(
                  'https://images.unsplash.com/photo-1438032005730-c779502df39b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return isoDate;
    }
  }

  Widget _buildTitleSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFDCE9FF), // surface-container-high
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            _formatDate(data['tanggal'] ?? ''),
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          data['judul'] ?? 'Warta Jemaat Minggu Ini',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26, // headline-lg
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(Map<String, dynamic> data) {
    final khotbahJudul = data['khotbahJudul'] ?? '';
    final khotbahAyat = data['khotbahAyat'] ?? '';
    final khotbahIsi = data['khotbahIsi'] ?? '';
    final jadwalPelayanan = data['jadwalPelayanan'] as String? ?? '';
    final infoPenting = data['infoPenting'] as String? ?? '';

    // 1. Parsing Jadwal Pelayanan
    List<String> jadwalList = jadwalPelayanan
        .replaceAll('\\n', '\n') // Membaca ketikan \n manual dari Prisma
        .split(RegExp(r'\n|\r\n')) // Membaca tombol Enter dari Mac/Windows
        .where((s) => s.trim().isNotEmpty)
        .toList();

    // 2. Parsing Informasi Penting
    List<String> infoList = infoPenting
        .replaceAll('\\n', '\n') // Membaca ketikan \n manual dari Prisma
        .split(RegExp(r'\n|\r\n')) // Membaca tombol Enter dari Mac/Windows
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BAGIAN KHOTBAH YANG BARU ---

        // Judul Khotbah dan Ayat (Bold)
        Text(
          '"$khotbahJudul" ($khotbahAyat)',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),

        // Isi/Deskripsi Khotbah (Regular)
        Text(
          khotbahIsi,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF0B1C30),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // --------------------------------
        _buildSectionHeader('Jadwal Pelayanan'),
        const SizedBox(height: 12),
        if (jadwalList.isEmpty)
          const Text(
            'Belum ada jadwal pelayanan.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16),
          ),
        ...jadwalList.map((j) {
          final parts = j.split(':');
          if (parts.length >= 2) {
            return _buildListItem(
              parts[0].trim(),
              parts.sublist(1).join(':').trim(),
            );
          }
          return _buildListItem('Tugas', j.trim());
        }),
        const SizedBox(height: 24),

        _buildSectionHeader('Informasi Penting'),
        const SizedBox(height: 12),
        if (infoList.isEmpty)
          const Text(
            'Belum ada informasi penting.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16),
          ),
        ...infoList.map((i) => _buildBulletPoint(i.trim())),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildListItem(String role, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              role,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF45464D),
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF45464D),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFF0B1C30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(fontSize: 18, color: Colors.black, height: 1.2),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFF0B1C30),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
