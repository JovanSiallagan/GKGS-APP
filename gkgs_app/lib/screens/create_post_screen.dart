import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // State untuk melacak kategori yang dipilih ('doa' atau 'kesaksian')
  String _selectedCategory = 'doa';
  
  // State untuk efek loading saat memanggil API
  bool _isLoading = false;

  // Controller untuk menangkap teks input dari pengguna
  final TextEditingController _contentController = TextEditingController();

  // Jangan lupa membersihkan controller saat layar ditutup untuk mencegah memory leak
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // background
      appBar: _buildAppBar(context),
      // Mencegah error layout saat keyboard muncul
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Kategori',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF45464D), // on-surface-variant
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pilihan Kategori (Radio Button Style Cards)
                  Row(
                    children: [
                      _buildCategoryOption(
                        id: 'doa',
                        label: 'Doa',
                        icon: Icons.volunteer_activism_outlined, // Mewakili folded_hands
                      ),
                      const SizedBox(width: 16),
                      _buildCategoryOption(
                        id: 'kesaksian',
                        label: 'Kesaksian',
                        icon: Icons.record_voice_over_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Area Teks Postingan
                  const Text(
                    'Isi Postingan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF45464D),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 240, // min-h-[240px]
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF), // surface-container-low
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: _contentController, // <-- Controller dipasang di sini
                      maxLines: null, // Allow multiline
                      expands: true, // Penuhi container
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFF0B1C30),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tuliskan doa atau kesaksian Anda di sini...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF45464D).withOpacity(0.6), // on-surface-variant/60
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Area (Tombol Kirim)
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FF).withOpacity(0.95),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFC6C6CD).withOpacity(0.2), // outline-variant/20
                ),
              ),
            ),
            child: ElevatedButton(
              // Jika sedang loading, tombol tidak bisa diklik (null)
              onPressed: _isLoading ? null : () async {
                // 1. Validasi: Jangan izinkan kirim jika teksnya kosong
                if (_contentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Isi postingan tidak boleh kosong!')),
                  );
                  return;
                }

                // 2. Aktifkan efek loading
                setState(() {
                  _isLoading = true;
                });

                // 3. Konversi pilihan kategori agar sesuai format ENUM Prisma di Backend
                String type = _selectedCategory == 'doa' ? 'PRAYER' : 'TESTIMONY';

                // 4. Panggil fungsi createPost di ApiService
                ApiService api = ApiService();
                bool isSuccess = await api.createPost(_contentController.text, type);

                // 5. Matikan efek loading
                setState(() {
                  _isLoading = false;
                });

                // 6. Tampilkan pesan berhasil/gagal dan kembali ke layar sebelumnya
                if (isSuccess && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil mengirim postingan!'), 
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop(); // Tutup layar "Kirim Postingan" dan kembali ke Papan Interaksi
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal mengirim postingan. Pastikan Anda sudah login.'), 
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // primary
                foregroundColor: Colors.white, // on-primary
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // rounded-xl
                ),
                elevation: 2,
              ),
              // Ubah tampilan child berdasarkan state _isLoading
              child: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kirim Postingan',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.send, size: 20),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      // Menggunakan icon close (silang) untuk task-focused header
      leading: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFF45464D)),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Kirim Postingan',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 20, // headline-sm
          color: Colors.black, // primary
        ),
      ),
    );
  }

  // Widget pembantu untuk Card Pilihan Kategori (Doa / Kesaksian)
  Widget _buildCategoryOption({
    required String id,
    required String label,
    required IconData icon,
  }) {
    bool isSelected = _selectedCategory == id;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = id;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEFF4FF)
                : Colors.white, // surface-container-low vs lowest
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Colors.black
                  : const Color(0xFFC6C6CD).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.black : const Color(0xFF45464D),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : const Color(0xFF45464D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}