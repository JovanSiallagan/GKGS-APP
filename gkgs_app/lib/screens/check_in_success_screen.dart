import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CheckInSuccessScreen extends StatefulWidget {
  // 1. TAMBAHKAN PARAMETER PENERIMA DATA DI SINI
  final String keterangan;
  final String tanggalAcara;
  final String judulAcara;

  const CheckInSuccessScreen({
    super.key,
    required this.keterangan,
    required this.tanggalAcara,
    required this.judulAcara,
  });

  @override
  State<CheckInSuccessScreen> createState() => _CheckInSuccessScreenState();
}

class _CheckInSuccessScreenState extends State<CheckInSuccessScreen> {
  String userName = 'Memuat...';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedName = prefs.getString('user_name');
    if (cachedName != null && mounted) {
      setState(() {
        userName = cachedName;
      });
    }

    final apiService = ApiService();
    final profile = await apiService.getUserProfile();
    if (profile != null && profile['name'] != null) {
      await prefs.setString('user_name', profile['name']);
      if (mounted) {
        setState(() {
          userName = profile['name'];
        });
      }
    }
  }

  // Fungsi untuk memformat tanggal (Jika format dari DB berupa ISO '2026-05-30')
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agt',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return isoDate; // Kembalikan teks asli jika bukan format ISO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD3E4FE),
                    shape: BoxShape.circle,
                  ),
                ).applyBlur(sigma: 40),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSuccessIcon(),
                    const SizedBox(height: 24),
                    _buildHeadlines(),
                    const SizedBox(height: 40),
                    _buildDetailsCard(),
                    const SizedBox(height: 40),
                    _buildPrimaryAction(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.church_outlined, color: Color(0xFF45464D)),
        onPressed: () {},
      ),
      title: const Text(
        'GKGS',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      actions: [
        /*
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF45464D),
          ),
          onPressed: () {},
        ),
        */
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFE5EEFF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.check_circle, color: Colors.black, size: 56),
      ),
    );
  }

  Widget _buildHeadlines() {
    return const Column(
      children: [
        Text(
          'Absensi Berhasil!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Terima kasih telah hadir. Selamat beribadah!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF45464D),
          ),
        ),
      ],
    );
  }

  


  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(label: 'Nama', value: userName),
          const Divider(color: Color(0xFFE0E3E5), height: 24),

          _buildDetailRow(label: 'Judul', value: widget.judulAcara),
          const Divider(color: Color(0xFFE0E3E5), height: 24),

          // 2. TAMPILKAN TANGGAL DARI WIDGET
          _buildDetailRow(
            label: 'Tanggal',
            value: _formatDate(widget.tanggalAcara),
          ),
          const Divider(color: Color(0xFFE0E3E5), height: 24),

          // 3. UBAH LABEL JADI "Keterangan" DAN VALUE DARI WIDGET
          _buildDetailRow(label: 'Keterangan', value: widget.keterangan),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF45464D),
          ),
        ),

        // Membungkus value dengan Expanded agar teks tidak error jika kepanjangan
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryAction(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.go('/dashboard');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 20),
          SizedBox(width: 8),
          Text(
            'Kembali ke Beranda',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

extension BlurExtension on Widget {
  Widget applyBlur({double sigma = 10.0}) {
    return ImageFilterWidget(sigma: sigma, child: this);
  }
}

class ImageFilterWidget extends StatelessWidget {
  final double sigma;
  final Widget child;
  const ImageFilterWidget({
    super.key,
    required this.sigma,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: child,
      ),
    );
  }
}
