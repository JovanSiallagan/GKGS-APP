import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../models/community_post.dart';

class InteractionBoardScreen extends StatefulWidget {
  const InteractionBoardScreen({super.key});

  @override
  State<InteractionBoardScreen> createState() => _InteractionBoardScreenState();
}

class _InteractionBoardScreenState extends State<InteractionBoardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Papan Interaksi',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30),
                  ),
                ),
                const SizedBox(height: 24),
                _buildCustomTabBar(context),
                const SizedBox(height: 24),

                _buildPostFeed(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/create_post');
          setState(() {});
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      actions: [],
    );
  }

  Widget _buildCustomTabBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tabWidth = (screenWidth - 48) / 3;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _selectedTabIndex * tabWidth,
            top: 0,
            bottom: 0,
            width: tabWidth - 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black : const Color(0xFF45464D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostFeed() {
    return FutureBuilder<List<CommunityPost>>(
      future: ApiService().getCommunityPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        } else if (snapshot.hasError) {
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

        final posts = snapshot.data!;

        return Column(
          children: posts.map((post) {
            if (_selectedTabIndex == 1 && post.type != 'PRAYER')
              return const SizedBox.shrink();
            if (_selectedTabIndex == 2 && post.type != 'TESTIMONY')
              return const SizedBox.shrink();

            String typeStr = post.type == 'PRAYER' ? 'Doa' : 'Kesaksian';
            IconData iconData = post.type == 'PRAYER'
                ? Icons.pan_tool_alt_outlined
                : Icons.celebration_outlined;
            Color accentColor = post.type == 'PRAYER'
                ? const Color(0xFFBEC6E0)
                : const Color(0xFFFED488).withOpacity(0.5);

            String timeStr =
                "${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}";

            String initial = post.userName.isNotEmpty
                ? post.userName[0].toUpperCase()
                : '?';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 4,
              child: Container(color: accentColor),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD3E4FE),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5EEFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              iconData,
                              size: 16,
                              color: const Color(0xFF45464D),
                            ),
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

                  Text(
                    content,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF0B1C30),
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
