import 'package:flutter/material.dart';
import 'persembahan_screen.dart'; 
import 'family_altar_screen.dart';
import 'community_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GKGS App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
        // Tambahkan null untuk fitur yang belum ada halamannya
          _buildMenu(context, Icons.qr_code_scanner, 'Smart QR', Colors.orange, null),
          _buildMenu(context, Icons.event, 'News & Event', Colors.green, null),
          _buildMenu(context, Icons.book, 'Family Altar', Colors.purple, const FamilyAltarScreen()),
        // Ubah null jadi const CommunityPostScreen()
          _buildMenu(context, Icons.forum, 'Papan Interaksi', Colors.red, const CommunityPostScreen()),          _buildMenu(context, Icons.menu_book, 'Alkitab Online', Colors.teal, null),
          _buildMenu(context, Icons.volunteer_activism, 'Persembahan', Colors.pink, const PersembahanScreen()),
        ],
      ),
    );
  }

  // Sekarang fungsi ini menerima 5 argumen (termasuk Widget? destination)
  Widget _buildMenu(BuildContext context, IconData icon, String title, Color color, Widget? destination) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (destination != null) {
            // Pindah ke halaman tujuan jika ada
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => destination)
            );
          } else {
            // Tampilkan pesan jika fitur belum siap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fitur $title segera hadir!'))
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}