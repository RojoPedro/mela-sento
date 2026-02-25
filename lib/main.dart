import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/supabase_config.dart';
import 'core/theme.dart';
import 'pages/main_screen.dart';
import 'pages/group_detail_page.dart';
import 'pages/create_bet_page.dart';

import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const MelaSentoApp());
}

class MelaSentoApp extends StatelessWidget {
  const MelaSentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MelaSento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session == null) {
            return const LoginPage();
          }
          return const MainScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainScreen(),
        '/detail': (context) => const GroupDetailPage(),
        '/create': (context) => const CreateBetPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const GroupDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return null;
      },
    );
  }
}
