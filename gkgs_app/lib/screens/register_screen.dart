import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart'; // <-- Import ApiService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // <-- Tambahan efek loading

  // <-- Tambahkan Controller untuk menangkap teks input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // background
      body: Stack(
        children: [
          // Ambient Background Accent (Gradient at the top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 256, // h-64
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFDCE9FF).withOpacity(0.4), // surface-container-high/40
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildRegistrationForm(),
                    const SizedBox(height: 24),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Brand Icon
        ClipOval(
          child: Image.asset(
            'assets/images/logo_gkgs.jpg',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        
        // Brand Name
        const Text(
          'GKGS',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26, // headline-lg-mobile
            fontWeight: FontWeight.bold,
            color: Colors.black, // primary
          ),
        ),
        const SizedBox(height: 8),
        
        // Subtitle
        const Text(
          'Daftar Akun Baru',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF45464D), // on-surface-variant
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF), // surface
        borderRadius: BorderRadius.circular(24), // rounded-2xl
        border: Border.all(
          color: const Color(0xFFC6C6CD).withOpacity(0.3), // outline-variant/30
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // shadow-[0_4px_15px_rgba...]
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _nameController, // <-- Pasang controller
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap Anda',
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 24),
          
          _buildTextField(
            controller: _emailController, // <-- Pasang controller
            label: 'Email',
            hint: 'contoh@email.com',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          
          _buildPasswordField(
            controller: _passwordController, // <-- Pasang controller
            label: 'Kata Sandi',
            hint: 'Minimal 8 karakter',
            icon: Icons.lock_outline,
            isVisible: _isPasswordVisible,
            onToggleVisibility: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 24),
          
          _buildPasswordField(
            controller: _confirmPasswordController, // <-- Pasang controller
            label: 'Konfirmasi Kata Sandi',
            hint: 'Ulangi kata sandi',
            icon: Icons.lock_reset_outlined,
            isVisible: _isConfirmPasswordVisible,
            onToggleVisibility: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 32),

          // Primary Action Button
          ElevatedButton(
            onPressed: _isLoading ? null : () async {
              // 1. Validasi Input Dasar
              if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
                _showError("Semua kolom harus diisi!");
                return;
              }

              // 2. Validasi Kata Sandi
              if (_passwordController.text.length < 8) {
                _showError("Kata sandi minimal 8 karakter!");
                return;
              }
              if (_passwordController.text != _confirmPasswordController.text) {
                _showError("Konfirmasi kata sandi tidak cocok!");
                return;
              }

              // 3. Tembak API Register
              setState(() { _isLoading = true; });
              
              ApiService api = ApiService();
              bool isSuccess = await api.register(
                _nameController.text,
                _emailController.text,
                _passwordController.text,
              );

              setState(() { _isLoading = false; });

              // 4. Cek Hasil
              if (isSuccess && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pendaftaran berhasil! Silakan masuk."),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop(); // Kembali ke halaman Login
              } else if (context.mounted) {
                _showError("Pendaftaran gagal! Email mungkin sudah digunakan.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // primary
              foregroundColor: Colors.white, // on-primary
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // rounded-xl
              ),
              elevation: 2,
            ),
            child: _isLoading 
              ? const SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14, // label-md
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu untuk menampilkan pesan error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Reusable TextField builder untuk Nama Lengkap dan Email
  Widget _buildTextField({
    required TextEditingController controller, // <-- Tambahan
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0B1C30), // on-surface
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // <-- Dipasang
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFC6C6CD), // placeholder:text-outline-variant
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF76777D)), // text-outline
            filled: true,
            fillColor: const Color(0xFFEFF4FF), // surface-container-low
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  // Reusable TextField builder khusus untuk Password
  Widget _buildPasswordField({
    required TextEditingController controller, // <-- Tambahan
    required String label,
    required String hint,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0B1C30),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // <-- Dipasang
          obscureText: !isVisible,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFC6C6CD),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF76777D)),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF76777D),
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: const Color(0xFFEFF4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah punya akun?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF45464D), // on-surface-variant
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            children: [
              Text(
                'Masuk',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.login, size: 16, color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }
}