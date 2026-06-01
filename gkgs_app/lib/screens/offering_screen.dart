import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur copy to clipboard
import 'dart:typed_data'; // Untuk memproses data gambar
import 'package:gal/gal.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class OfferingScreen extends StatefulWidget {
  const OfferingScreen({super.key});

  @override
  State<OfferingScreen> createState() => _OfferingScreenState();
}

class _OfferingScreenState extends State<OfferingScreen> {
  // Fungsi untuk menyalin nomor rekening ke clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nomor rekening disalin',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 32),
          _buildQrisSection(),
          const SizedBox(height: 24),
          _buildBankTransferSection(),
          const SizedBox(height: 32), // Padding aman bawah
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildHeaderSection() {
    return Column(
      children: [
        const Text(
          'Persembahan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26, // headline-lg-mobile
            fontWeight: FontWeight.bold,
            color: Colors.black, // primary
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF), // surface-container-low
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFC6C6CD).withOpacity(0.3),
            ), // outline-variant/30
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // ambient-shadow
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            children: [
              Text(
                '"Hendaklah masing-masing memberikan menurut kerelaan hatinya, jangan dengan sedih hati atau karena paksaan, sebab Allah mengasihi orang yang memberi dengan sukacita."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF45464D), // on-surface-variant
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '— 2 Korintus 9:7',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF45464D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQrisSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, // surface-container-lowest
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
          const Text(
            'Scan QRIS',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20, // headline-sm
              fontWeight: FontWeight.bold,
              color: Colors.black, // primary
            ),
          ),
          const SizedBox(height: 24),
          // Gambar QRIS Placeholder
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFC6C6CD).withOpacity(0.3),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/qris_gkgs.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Tombol Simpan QR
          OutlinedButton(
            onPressed: () {
              _saveQrCode();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFE5EEFF), // surface-container
              side: BorderSide(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_rounded, color: Colors.black, size: 20),
                SizedBox(width: 8),
                Text(
                  'Simpan Kode QR',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankTransferSection() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transfer Bank',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE0E3E5), thickness: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              // Icon Bank
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5EEFF), // surface-container
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.account_balance, color: Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              // Detail Rekening
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank BCA',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF45464D), // on-surface-variant
                      ),
                    ),
                    Text(
                      '401-301-1501',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'a/n Gereja Kristus Gading Serpong',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Color(0xFF45464D),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol Copy
              IconButton(
                icon: const Icon(Icons.content_copy, color: Colors.black),
                onPressed: () => _copyToClipboard('4013011501'),
                tooltip: 'Salin Nomor Rekening',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE0E3E5), thickness: 1),
        ],
      ),
    );
  }

  // Fungsi untuk menyimpan QRIS ke Galeri HP
  Future<void> _saveQrCode() async {
    // --- PENCEGAT KHUSUS WEB (CHROME) ---
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fitur simpan ke Galeri hanya bisa diuji di HP Android/iOS atau Emulator Asli.',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return; // Berhenti di sini, jangan jalankan kode Android/iOS di bawah!
    }
    // ------------------------------------

    try {
      // 1. Minta Izin ke HP Pengguna (Ketuk Pintu)

      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
      }

      final hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Izin ditolak. Anda harus mengizinkan akses galeri untuk menyimpan QRIS.',
                style: TextStyle(fontFamily: 'Inter'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // 2. Jika diizinkan, Ambil dan Simpan Gambarnya
      final ByteData bytes = await rootBundle.load(
        'assets/images/qris_gkgs.jpg',
      );
      final Uint8List buffer = bytes.buffer.asUint8List();

      await Gal.putImageBytes(
        buffer,
        name: "QRIS_GKGS_${DateTime.now().millisecondsSinceEpoch}",
      );

      // 3. Tampilkan pesan sukses
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Berhasil! QRIS tersimpan di Galeri HP.',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Terjadi kesalahan saat memproses gambar.',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
