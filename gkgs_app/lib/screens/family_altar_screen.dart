import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/family_altar.dart';

class FamilyAltarScreen extends StatefulWidget {
  const FamilyAltarScreen({super.key});

  @override
  State<FamilyAltarScreen> createState() => _FamilyAltarScreenState();
}

class _FamilyAltarScreenState extends State<FamilyAltarScreen> {
  late Future<List<FamilyAltar>> futureAltars;

  @override
  void initState() {
    super.initState();
    futureAltars = ApiService().getFamilyAltars(); // Ambil data saat aplikasi dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Altar')),
      body: FutureBuilder<List<FamilyAltar>>(
        future: futureAltars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada renungan tersedia.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final altar = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(altar.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(altar.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Nanti kita buat halaman detail renungannya di sini
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}