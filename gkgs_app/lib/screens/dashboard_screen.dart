import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'Memuat...';
  String wartaTitle = 'Warta Jemaat Minggu Ini';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadWartaJemaat();
  }

  Future<void> _loadWartaJemaat() async {
    try {
      final apiService = ApiService();
      final warta = await apiService.getLatestWarta();
      if (warta != null) {
        final String? dateString = warta['tanggal'] ?? warta['created_at'];
        if (dateString != null) {
          final DateTime date = DateTime.parse(dateString);
          if (mounted) {
            setState(() {
              wartaTitle = 'Warta Jemaat - ${date.day}/${date.month}/${date.year}';
            });
          }
        }
      }
    } catch (e) {
      print("Gagal fetch warta jemaat: $e");
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedName = prefs.getString('user_name');
    if (cachedName != null && mounted) {
      setState(() {
        userName = cachedName;
      });
    }

    final apiService = ApiService();
    final profile = await apiService.getUserProfile();
    if (profile != null && profile['name'] != null) {
      await prefs.setString('user_name', profile['name']);
      if (mounted) {
        setState(() {
          userName = profile['name'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(),
          const SizedBox(height: 40),
          _buildFeaturedBanner(context),
          const SizedBox(height: 40),
          _buildGridMenu(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, $userName',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),
        SizedBox(height: 4),
        const Text(
          'Selamat datang kembali di aplikasi GKGS.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF45464D),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/warta_jemaat'),
      child: Container(
        height: 192,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFDCE9FF),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1438032005730-c779502df39b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF775A19),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'TERBARU',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    wartaTitle,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jadwal ibadah dan pengumuman terbaru.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildMenuCard(
          context: context,
          icon: Icons.qr_code,
          title: 'Smart QR',
          routeName: '/smart_qr',
          isPrimary:
              true,
        ),
        _buildMenuCard(
          context: context,
          icon: Icons.calendar_month,
          title: 'News & Event',
          routeName: '/news_event',
          cardBgColor: const Color(0xFFFFF8E7),
          iconBgColor: const Color(0xFFFED488),
          iconColor: const Color(0xFF785A1A),
        ),
        _buildMenuCard(
          context: context,
          icon: Icons.favorite,
          title: 'Family Altar',
          routeName: '/family_altar',
          cardBgColor: const Color(0xFFF2F3F7),
          iconBgColor: const Color(0xFF565E74),
          iconColor: Colors.white,
        ),
        _buildMenuCard(
          context: context,
          icon: Icons.forum,
          title: 'Papan Interaksi',
          routeName: '/interaction_board',
          cardBgColor: const Color(0xFFF7F8F9),
          iconBgColor: const Color(0xFFC4C7C9),
          iconColor: const Color(0xFF444749),
        ),
        _buildMenuCard(
          context: context,
          icon: Icons.menu_book,
          title: 'Alkitab Online',
          routeName: '/bible',
          cardBgColor: const Color(0xFFEEF5FF),
          iconBgColor: const Color(0xFFD3E4FE),
          iconColor: const Color(0xFF45464D),
        ),
        _buildMenuCard(
          context: context,
          icon: Icons.volunteer_activism,
          title: 'Persembahan',
          routeName: '/offering',
          cardBgColor: const Color(0xFFFFF0F3),
          iconBgColor: const Color(0xFFFFD6E0),
          iconColor: const Color(0xFFD90429),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
    Color? iconBgColor,
    Color? iconColor,
    Color? cardBgColor,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (['/dashboard', '/bible', '/offering'].contains(routeName)) {
            context.go(routeName);
          } else {
            context.push(routeName);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.black : (cardBgColor ?? Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: isPrimary
                ? null
                : Border.all(color: const Color(0xFFC6C6CD).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (isPrimary)
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      icon,
                      size: 80,
                      color: Colors.white.withOpacity(
                        0.08,
                      ),
                    ),
                  ),
                ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isPrimary
                            ? Colors.white.withOpacity(0.2)
                            : iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isPrimary ? Colors.white : iconColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isPrimary
                            ? Colors.white
                            : const Color(0xFF0B1C30),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
