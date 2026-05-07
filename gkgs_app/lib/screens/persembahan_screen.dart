import 'package:flutter/material.dart';

class PersembahanScreen extends StatelessWidget {
  const PersembahanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Persembahan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Salurkan persembahan Anda melalui QRIS atau Transfer Bank di bawah ini:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            // Jika belum ada gambar asli, kita pakai placeholder dulu
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[300],
              child: const Icon(Icons.qr_code_2, size: 200, color: Colors.black54),
              // Nanti kalau sudah ada gambarnya, ganti jadi:
              // child: Image.asset('assets/qris.png'),
            ),
            const SizedBox(height: 32),
            const Card(
              child: ListTile(
                leading: Icon(Icons.account_balance, color: Colors.blue),
                title: Text('Bank BCA'),
                subtitle: Text('123456789 a/n Gereja GKGS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}