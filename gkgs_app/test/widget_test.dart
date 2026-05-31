// Tes dasar untuk memastikan aplikasi GKGS bisa berjalan.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gkgs_app/main.dart'; // Sesuaikan jika nama package Anda berbeda

void main() {
  testWidgets('Aplikasi GKGS berhasil dimuat', (WidgetTester tester) async {
    // Kita tambahkan parameter initialRoute agar GKGSApp tidak error
    await tester.pumpWidget(const GKGSApp(initialRoute: '/login'));

    // Karena aplikasi Anda bukan aplikasi penghitung angka lagi,
    // kita cukup mengecek apakah fondasi aplikasinya (MaterialApp) berhasil dimuat.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
