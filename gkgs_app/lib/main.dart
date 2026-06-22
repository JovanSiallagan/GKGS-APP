import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/family_altar_screen.dart';
import 'screens/news_event_screen.dart';
import 'screens/smart_qr_screen.dart';
import 'screens/check_in_success_screen.dart';
import 'screens/interaction_board_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/offering_screen.dart';
import 'screens/bible_reader_screen.dart';
import 'screens/warta_jemaat_screen.dart';

import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  final String initialRoute = (token != null && token.isNotEmpty)
      ? '/dashboard'
      : '/login';

  runApp(GKGSApp(initialRoute: initialRoute));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class GKGSApp extends StatelessWidget {
  final String initialRoute;

  const GKGSApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: initialRoute,
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/smart_qr',
          builder: (context, state) => const SmartQrScreen(),
        ),
        GoRoute(
          path: '/check_in_success',
          builder: (context, state) {
            final Map<String, dynamic> data =
                state.extra as Map<String, dynamic>? ?? {};

            return CheckInSuccessScreen(
              judulAcara: data['title'] ?? 'Ibadah',
              keterangan: data['description'] ?? 'Ibadah Minggu',
              tanggalAcara: data['date'] ?? DateTime.now().toString(),
            );
          },
        ),
        GoRoute(
          path: '/interaction_board',
          builder: (context, state) => const InteractionBoardScreen(),
        ),
        GoRoute(
          path: '/create_post',
          builder: (context, state) => const CreatePostScreen(),
        ),
        GoRoute(
          path: '/news_event',
          builder: (context, state) => const NewsEventScreen(),
        ),
        GoRoute(
          path: '/warta_jemaat',
          builder: (context, state) => const WartaJemaatScreen(),
        ),
        GoRoute(
          path: '/family_altar',
          builder: (context, state) => const FamilyAltarScreen(),
        ),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const DashboardScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/bible',
                  builder: (context, state) => const BibleReaderScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/offering',
                  builder: (context, state) => const OfferingScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'GKGS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          surface: const Color(0xFFF8F9FF),
        ),
        fontFamily: 'Inter',
      ),
      routerConfig: router,
    );
  }
}
