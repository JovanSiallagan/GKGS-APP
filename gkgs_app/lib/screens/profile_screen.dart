import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isSaving = false;

  String _displayName = 'Memuat...'; // Variabel khusus untuk nama di atas
  String _selectedGender = 'L';
  DateTime? _dob;

  // Controller untuk menangkap dan menampilkan data di kolom
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Logika GET dijalankan otomatis saat halaman dibuka
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- LOGIKA GET DATA DARI BACKEND ---
  Future<void> _loadProfileData() async {
    ApiService api = ApiService();
    final user = await api.getUserProfile();

    if (user != null && mounted) {
      setState(() {
        // Memasukkan data dari database ke kolom-kolom
        _nameController.text = user['name'] ?? '';
        _displayName = user['name'] ?? 'Jemaat'; // Mengubah teks paling atas
        _emailController.text = user['email'] ?? '';
        _addressController.text = user['address'] ?? '';
        _phoneController.text = user['phone'] ?? '';

        if (user['gender'] != null &&
            (user['gender'] == 'L' || user['gender'] == 'P')) {
          _selectedGender = user['gender'];
        }

        if (user['dob'] != null) {
          _dob = DateTime.tryParse(user['dob'].toString());
        }
        _isLoading = false; // Matikan loading
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _displayName = 'Sesi Habis (Harap Login Ulang)';
        });
      }
    }
  }

  // --- LOGIKA MENYIMPAN (PATCH) DATA ---
  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    ApiService api = ApiService();
    Map<String, dynamic> updateData = {
      "name": _nameController.text,
      "gender": _selectedGender,
      "address": _addressController.text,
      "phone": _phoneController.text,
    };

    if (_dob != null) {
      updateData["dob"] = _dob!.toIso8601String();
    }

    bool isSuccess = await api.updateUserProfile(updateData);

    setState(() {
      _isSaving = false;
    });

    if (isSuccess && mounted) {
      setState(() {
        _displayName =
            _nameController.text; // Update teks di atas setelah disave
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui profil.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          _buildEditForm(),
          const SizedBox(height: 24),
          _buildLogoutButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // FOTO PROFIL DIHAPUS

        // Nama Asli Akun (Ditarik dari Backend)
        Text(
          _displayName,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26, // Ukuran dibesarkan sedikit karena tidak ada foto
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),
        const SizedBox(height: 8),

        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDCE9FF),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Jemaat Aktif',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF45464D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Nama Lengkap',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              _buildDatePickerField(label: 'Tanggal Lahir'),
              const SizedBox(height: 16),
              _buildDropdownField(label: 'Jenis Kelamin'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Alamat',
                controller: _addressController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nomor Telepon',
                controller: _phoneController,
                hintText: '08xx...',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: _isSaving ? null : _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: _isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
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
            color: Color(0xFF45464D),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: readOnly ? const Color(0xFF76777D) : const Color(0xFF0B1C30),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: readOnly ? const Color(0xFFEFF4FF) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC6C6CD), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC6C6CD), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF45464D),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _dob ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != _dob) {
              setState(() {
                _dob = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC6C6CD), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dob == null
                      ? 'DD/MM/YYYY'
                      : '${_dob!.day.toString().padLeft(2, '0')}/${_dob!.month.toString().padLeft(2, '0')}/${_dob!.year}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: _dob == null
                        ? Colors.black54
                        : const Color(0xFF0B1C30),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF45464D),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF45464D),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF45464D)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC6C6CD), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC6C6CD), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'L',
              child: Text('Laki-laki', style: TextStyle(fontFamily: 'Inter')),
            ),
            DropdownMenuItem(
              value: 'P',
              child: Text('Perempuan', style: TextStyle(fontFamily: 'Inter')),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Keluar Akun',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: const Text(
                'Apakah Anda yakin ingin keluar dari akun ini?',
                style: TextStyle(fontFamily: 'Inter', color: Color(0xFF45464D)),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    dialogContext.pop();
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF45464D),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    dialogContext.pop();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('jwt_token');
                    await prefs.remove('user_name');
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1A1A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFBA1A1A).withOpacity(0.1),
        side: const BorderSide(color: Color(0xFFFFDAD6)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, color: Color(0xFFBA1A1A), size: 20),
          SizedBox(width: 8),
          Text(
            'Keluar Akun',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFBA1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
