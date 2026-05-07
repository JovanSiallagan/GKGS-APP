import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/community_post.dart';

class CommunityPostScreen extends StatefulWidget {
  const CommunityPostScreen({super.key});

  @override
  State<CommunityPostScreen> createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _contentController = TextEditingController();
  String _selectedType = 'PRAYER';

  // Fungsi untuk memunculkan modal input postingan
  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kirim Postingan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'PRAYER', child: Text('Request Doa')),
                DropdownMenuItem(value: 'TESTIMONY', child: Text('Kesaksian')),
              ],
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'Tuliskan pesan Anda...'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(onPressed: _submitPost, child: const Text('Kirim')),
        ],
      ),
    );
  }

  void _submitPost() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Ambil ID Budi yang kita simpan pas login

    if (userId != null && _contentController.text.isNotEmpty) {
      await _apiService.createPost(userId, _contentController.text, _selectedType);
      _contentController.clear();
      if (mounted) Navigator.pop(context);
      setState(() {}); // Refresh layar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Papan Interaksi')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: const Icon(Icons.add_comment),
      ),
      body: FutureBuilder<List<CommunityPost>>(
        future: _apiService.getCommunityPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Belum ada interaksi.'));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(post.userName[0])),
                  title: Text(post.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(label: Text(post.type), labelStyle: const TextStyle(fontSize: 10)),
                      Text(post.content),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}