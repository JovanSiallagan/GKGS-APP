import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Import halaman Home

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Fungsi untuk simulasi login
  Future<void> _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Menyimpan ID Budi Jemaat secara permanen di aplikasi
    await prefs.setString('userId', '409c591b-78ca-49ed-9b33-8a0782608c76');

    // Pastikan context masih valid sebelum pindah halaman
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil! ID tersimpan.')),
      );
      
      // Pindah ke halaman Home dan hapus halaman Login dari riwayat back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.church, size: 100, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'GKGS App',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Aplikasi Komunitas Gereja'),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Login sebagai Budi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}