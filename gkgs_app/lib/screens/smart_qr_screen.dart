import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // <-- Import Mobile Scanner
import '../services/api_service.dart'; // <-- Import API Service

class SmartQrScreen extends StatefulWidget {
  const SmartQrScreen({super.key});

  @override
  State<SmartQrScreen> createState() => _SmartQrScreenState();
}

class _SmartQrScreenState extends State<SmartQrScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  // Controller untuk Kamera
  final MobileScannerController _cameraController = MobileScannerController();

  // Flag agar tidak dobel scan saat sedang loading ke backend
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Setup animasi untuk garis scanner (bergerak dari atas ke bawah berulang-ulang)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController.dispose(); // <-- Jangan lupa matikan kamera saat keluar
    super.dispose();
  }

  // --- FUNGSI SAAT QR BERHASIL DIBACA ---
  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return; // Abaikan jika sedang memproses

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? qrData =
          barcodes.first.rawValue; // Ambil teks dari QR (Event ID)

      if (qrData != null && qrData.isNotEmpty) {
        setState(() {
          _isProcessing = true; // Kunci layar dengan efek loading
        });

        try {
          ApiService api = ApiService();

          // 1. TANGKAP RESPONSE SEBAGAI MAP, BUKAN BOOLEAN
          final response = await api.checkIn(qrData);

          if (mounted) {
            _cameraController.stop();

            // 2. LEMPAR DATANYA KE ROUTER!
            context.pushReplacement(
              '/check_in_success',
              extra: {
                // Ambil dari struktur data JSON yang dikirim backend NestJS Anda
                'title': response['data']['title'],
                'description': response['data']['description'],
                'date': response['data']['date'],
              },
            );
          }
        } catch (e) {
          // Jika gagal (ID salah, atau sudah absen)
          if (mounted) {
            // Bersihkan tulisan "Exception: " bawaan Flutter agar pesan error lebih rapi
            String errorMessage = e.toString().replaceAll('Exception: ', '');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMessage,
                  style: const TextStyle(fontFamily: 'Inter'),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Beri jeda 3 detik sebelum kamera bisa dipakai scan lagi
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                setState(() {
                  _isProcessing = false;
                });
              }
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // 1. KAMERA ASLI
          Positioned.fill(
            child: MobileScanner(
              controller: _cameraController,
              onDetect: _onDetect,
            ),
          ),

          // 2. MASKING (Satu Stack dengan Viewfinder)
          Stack(
            children: [
              // Lapisan Gelap
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          backgroundBlendMode: BlendMode.dstOut,
                        ),
                      ),
                      // Lubang di tengah
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Viewfinder & UI (Posisikan di sini agar pas dengan lubang)
              Align(
                alignment: Alignment.center,
                child: _buildScannerViewfinderOnly(),
              ),
            ],
          ),

          // 4. Instruksi dan UI lainnya
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Arahkan kamera ke Kode QR yang tersedia di ruangan ibadah gereja.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 450), // Jarak agar tidak menutupi lubang
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.95), // surface/95
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1C30)),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'GKGS',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black, // primary
        ),
      ),
      actions: [
        // Tombol Flashlight / Senter (Sudah diperbarui untuk versi terbaru)
        ValueListenableBuilder(
          valueListenable:
              _cameraController, // <-- Sekarang listen langsung ke controllernya
          builder: (context, state, child) {
            // state di sini menyimpan seluruh informasi kamera, termasuk senter
            if (state.torchState == TorchState.on) {
              return IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.amber),
                onPressed: () => _cameraController.toggleTorch(),
              );
            }

            return IconButton(
              icon: const Icon(Icons.flash_off, color: Colors.white),
              onPressed: () => _cameraController.toggleTorch(),
            );
          },
        ),
      ],
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // backdrop-blur-md
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildScannerViewfinderOnly() {
    const double scannerSize = 280.0;

    return SizedBox(
      width: scannerSize,
      height: scannerSize,
      child: Stack(
        children: [
          // Siku-siku Scanner (Corners) - Tetap butuh ini sebagai bingkai
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(isTop: false, isLeft: false),
          ),

          // Garis Pemindai (Scan Line) Beranimasi
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Positioned(
                top: _scanAnimation.value * (scannerSize - 4),
                left: 20, // Sedikit margin agar tidak menabrak bingkai
                right: 20,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Komponen pembantu untuk membuat sudut (corner) scanner
  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(16) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
          bottomLeft: !isTop && isLeft
              ? const Radius.circular(16)
              : Radius.zero,
          bottomRight: !isTop && !isLeft
              ? const Radius.circular(16)
              : Radius.zero,
        ),
      ),
    );
  }
}
