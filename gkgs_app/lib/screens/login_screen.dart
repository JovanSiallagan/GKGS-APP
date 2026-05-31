import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // surface
      body: Stack(
        children: [
          // Ambient Background Gradients
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD3E4FE).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFEFF4FF).withOpacity(0.8), // surface-container-low
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildLoginForm(),
                    const SizedBox(height: 40),
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
        const SizedBox(height: 8),
        
        // Brand Name
        const Text(
          'GKGS',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24, // headline-md
            fontWeight: FontWeight.bold,
            color: Colors.black, // primary
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        
        // Welcome Message
        const Text(
          'Selamat Datang',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26, // headline-lg-mobile
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30), // on-surface
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Silakan masuk untuk melanjutkan perjalanan rohani Anda.',
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

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email Input
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Email atau Username',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF45464D), // on-surface-variant
            ),
          ),
        ),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
          decoration: InputDecoration(
            hintText: 'jemaat@gkgs.org',
            hintStyle: TextStyle(
              color: const Color(0xFF76777D).withOpacity(0.6), // outline/60
            ),
            prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF45464D)),
            filled: true,
            fillColor: const Color(0xFFE5EEFF), // surface-container
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), // rounded-xl
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black, width: 1.5), // focus:border-primary
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 24),

        // Password Input
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Kata Sandi',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF45464D),
            ),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(
              color: const Color(0xFF76777D).withOpacity(0.6),
            ),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF45464D)),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF45464D),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: const Color(0xFFE5EEFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),

        // Submit Button
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            setState(() {
              _isLoading = true;
            });

            ApiService api = ApiService();
            // Panggil API login dengan data dari TextField
            bool isSuccess = await api.login(
              _emailController.text, 
              _passwordController.text
            );

            setState(() {
              _isLoading = false;
            });

            if (isSuccess) {
              if (context.mounted) {
                 context.go('/dashboard'); // Pindah ke dashboard jika sukses
              }
            } else {
              if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     content: Text("Login gagal! Periksa kembali email dan kata sandi Anda."),
                     backgroundColor: Colors.red,
                   ),
                 );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // primary
            foregroundColor: Colors.white, // on-primary
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999), // rounded-full
            ),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: _isLoading 
            ? const SizedBox(
                height: 20, width: 20, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Masuk',
                    style: TextStyle(
                      fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
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
          'Belum punya akun?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF45464D), // on-surface-variant
          ),
        ),
        TextButton(
          onPressed: () {
            context.push('/register');
          }, // Aksi navigasi ke halaman pendaftaran
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Daftar di sini',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}