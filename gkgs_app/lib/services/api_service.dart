import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/family_altar.dart';
import '../models/community_post.dart';

class ApiService {
  static const String baseUrl = 'https://gkgs-app.vercel.app';

  // --- AUTENTIKASI ---
  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return response.statusCode == 201;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      try {
        final profile = await getUserProfile();
        if (profile != null && profile['name'] != null) {
          await prefs.setString('user_name', profile['name']);
        }
      } catch (e) {
        print("Gagal fetch profile saat login: $e");
      }

      return true;
    }
    return false;
  }

  // --- FAMILY ALTAR ---
  Future<List<FamilyAltar>> getFamilyAltars() async {
    final response = await http.get(Uri.parse('$baseUrl/family-altar'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => FamilyAltar.fromJson(item)).toList();
    } else {
      throw "Gagal mengambil data renungan";
    }
  }

  // --- PAPAN INTERAKSI ---
  Future<List<CommunityPost>> getCommunityPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/community-post'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => CommunityPost.fromJson(item)).toList();
    } else {
      throw "Gagal memuat papan interaksi";
    }
  }

  Future<bool> createPost(String content, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print("Token tidak ditemukan, user belum login!");
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/community-post'),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({"content": content, "type": type}),
    );

    return response.statusCode == 201;
  }

  // --- ABSENSI (SMART QR) ---
  Future<Map<String, dynamic>> checkIn(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw "Token tidak ditemukan, silakan login ulang.";
    }

    final response = await http.post(
      Uri.parse('$baseUrl/attendance/check-in'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"eventId": eventId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? "Gagal melakukan absensi";
    }
  }

  // --- MENGAMBIL PROFIL USER ---
  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/me'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", 
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    return null;
  }

  // --- MENGUBAH PROFIL USER ---
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return false;

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/user/me'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        if (data.containsKey('name')) {
          await prefs.setString('user_name', data['name']);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }

  // --- WARTA JEMAAT ---
  Future<Map<String, dynamic>?> getLatestWarta() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/warta/latest'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching latest warta: $e");
    }
    return null;
  }
}
