import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/family_altar.dart';
import '../models/community_post.dart';

class ApiService {
  // Gunakan IP ini untuk Chrome. Jika di HP/Emulator, gunakan IP Laptopmu.
  static const String baseUrl = 'http://localhost:9425';

  Future<List<FamilyAltar>> getFamilyAltars() async {
    final response = await http.get(Uri.parse('$baseUrl/family-altar'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => FamilyAltar.fromJson(item)).toList();
    } else {
      throw "Gagal mengambil data renungan";
    }
  }

  // Fungsi untuk Papan Interaksi (Ambil Data)
  Future<List<CommunityPost>> getCommunityPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/community-post'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => CommunityPost.fromJson(item)).toList();
    } else {
      throw "Gagal memuat papan interaksi";
    }
  }

  // Fungsi untuk Papan Interaksi (Kirim Data)
  Future<bool> createPost(String userId, String content, String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/community-post'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "content": content,
        "type": type,
      }),
    );
    return response.statusCode == 201;
  }

}