import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/glass_card.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService();
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => authService.signOut(),
            icon: const Icon(Icons.logout_rounded, color: Colors.white54),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: StreamBuilder<Map<String, dynamic>>(
            stream: profileService.getProfileStream(),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final fullName = profile?['full_name'] ?? 'Loading...';
              final username = profile?['username'] ?? 'User';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       const CircleAvatar(
                         radius: 40,
                         backgroundColor: AppColors.electricCyan,
                         child: Icon(Icons.person, size: 40, color: Colors.black),
                       ),
                       const SizedBox(width: 20),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(fullName, style: Theme.of(context).textTheme.headlineMedium),
                           Text('@$username', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.electricCyan.withOpacity(0.7))),
                         ],
                       ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text('BALANCE PERFORMANCE', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: CustomPaint(
                      painter: LineChartPainter(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text('BADGE COLLECTION', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 2)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                       return GlassCard(
                         padding: const EdgeInsets.all(12),
                         borderRadius: BorderRadius.circular(20),
                         child: Icon(
                           [Icons.bolt, Icons.emoji_events, Icons.military_tech, Icons.verified, Icons.stars, Icons.local_fire_department][index],
                           color: [AppColors.neonGreen, AppColors.electricCyan, AppColors.accentOrange, AppColors.accentYellow, Colors.purpleAccent, Colors.pinkAccent][index],
                           size: 32,
                         ),
                       );
                    },
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.7, size.width * 0.4, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.1, size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.2);

    final shadowPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.neonGreen.withOpacity(0.2), Colors.transparent],
    );
    
    canvas.drawPath(shadowPath, Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
