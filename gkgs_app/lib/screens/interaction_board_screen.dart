import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';      // <-- Import ApiService
import '../models/community_post.dart';     // <-- Import Model CommunityPost

class InteractionBoardScreen extends StatefulWidget {
  const InteractionBoardScreen({super.key});

  @override
  State<InteractionBoardScreen> createState() => _InteractionBoardScreenState();
}

class _InteractionBoardScreenState extends State<InteractionBoardScreen> {
  // State untuk melacak tab yang aktif (0: Semua, 1: Doa, 2: Kesaksian)
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // background / surface
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Papan Interaksi',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 32, // headline-lg
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30), // on-surface
                  ),
                ),
                const SizedBox(height: 24),
                _buildCustomTabBar(context),
                const SizedBox(height: 24),
                
                // Memanggil Widget Feed yang sudah menggunakan Data API
                _buildPostFeed(),
                
                const SizedBox(height: 80), // Padding ekstra di bawah untuk FAB
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Tunggu sampai user selesai dari halaman Create Post
          await context.push('/create_post');
          // Setelah kembali, refresh tampilan agar postingan baru muncul
          setState(() {}); 
        },
        backgroundColor: Colors.black, // primary
        foregroundColor: Colors.white, // on-primary
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.edit_square, size: 20),
        label: const Text(
          'Kirim Postingan',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FF).withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF45464D)),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'GKGS',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      actions: [
        /*
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Color(0xFF45464D)),
          onPressed: () {},
        ),
        */
      ],
    );
  }

  // Custom Segmented Control / Tab Bar
  Widget _buildCustomTabBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Lebar kontainer dikurangi padding kiri-kanan (24 * 2) = 48
    final double tabWidth = (screenWidth - 48) / 3;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF), // surface-container-low
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Animated Indicator (Background putih yang bergerak)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _selectedTabIndex * tabWidth,
            top: 0,
            bottom: 0,
            width: tabWidth - 8, // dikurangi kompensasi padding internal
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // surface-container-lowest
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          // Tab Buttons
          Row(
            children: [
              _buildTabButton(title: 'Semua', index: 0),
              _buildTabButton(title: 'Doa', index: 1),
              _buildTabButton(title: 'Kesaksian', index: 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    final bool isActive = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500, // label-md
              color: isActive ? Colors.black : const Color(0xFF45464D), // primary vs on-surface-variant
            ),
          ),
        ),
      ),
    );
  }

  // MENGGUNAKAN FUTUREBUILDER UNTUK MENGAMBIL DATA DARI API
  Widget _buildPostFeed() {
    return FutureBuilder<List<CommunityPost>>(
      future: ApiService().getCommunityPosts(),
      builder: (context, snapshot) {
        // 1. Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }
        // 2. Error State
        else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Text(
                "Gagal memuat data:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
              ),
            ),
          );
        }
        // 3. Empty State (Belum ada postingan di database)
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: Text(
                "Belum ada postingan doa atau kesaksian.",
                style: TextStyle(fontFamily: 'Inter', color: Color(0xFF45464D)),
              ),
            ),
          );
        }

        // 4. Data siap ditampilkan
        final posts = snapshot.data!;

        return Column(
          children: posts.map((post) {
            // Filter logika tab
            if (_selectedTabIndex == 1 && post.type != 'PRAYER') return const SizedBox.shrink();
            if (_selectedTabIndex == 2 && post.type != 'TESTIMONY') return const SizedBox.shrink();

            // Mapping tipe enum ke UI
            String typeStr = post.type == 'PRAYER' ? 'Doa' : 'Kesaksian';
            IconData iconData = post.type == 'PRAYER' ? Icons.pan_tool_alt_outlined : Icons.celebration_outlined;
            Color accentColor = post.type == 'PRAYER' ? const Color(0xFFBEC6E0) : const Color(0xFFFED488).withOpacity(0.5);

            // Format tanggal (contoh output: 30/5/2026)
            String timeStr = "${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}";
            
            // Inisial untuk avatar
            String initial = post.userName.isNotEmpty ? post.userName[0].toUpperCase() : '?';

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildPostCard(
                type: typeStr,
                initial: initial,
                name: post.userName,
                time: timeStr,
                content: post.content,
                accentColor: accentColor,
                iconData: iconData,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPostCard({
    required String type,
    required String initial,
    required String name,
    required String time,
    required String content,
    required Color accentColor,
    required IconData iconData,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // surface-container-lowest
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // ambient-shadow
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Top Accent Border
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 4,
              child: Container(color: accentColor),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD3E4FE), // surface-variant
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name & Time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Color(0xFF45464D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Tag Badge (Doa / Kesaksian)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5EEFF), // surface-container
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(iconData, size: 16, color: const Color(0xFF45464D)),
                            const SizedBox(width: 4),
                            Text(
                              type,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color(0xFF45464D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Content Text
                  Text(
                    content,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF0B1C30), // on-surface
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}