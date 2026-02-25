import 'package:flutter/material.dart';
import '../widgets/balance_header.dart';
import '../widgets/bet_card.dart';
import '../widgets/status_badge.dart';
import '../services/bet_service.dart';
import '../services/profile_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final betService = BetService();
    final profileService = ProfileService();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<Map<String, dynamic>>(
                stream: profileService.getProfileStream(),
                builder: (context, snapshot) {
                  final profile = snapshot.data;
                  final balance = (profile?['balance'] as num?)?.toDouble() ?? 0.0;
                  return BalanceHeader(
                    balance: balance,
                    frozenCredits: 0.00,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: betService.getChallengesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final challenges = snapshot.data ?? [];

                    return Column(
                      children: [
                        ...challenges.map((challenge) {
                          final statusStr = challenge['status'] as String?;
                          BetStatus status = BetStatus.none;
                          if (statusStr == 'table') status = BetStatus.table;
                          if (statusStr == 'live') status = BetStatus.live;
                          if (statusStr == 'ended') status = BetStatus.ended;

                          return BetCard(
                            groupName: challenge['title'],
                            status: status,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: challenge['id'],
                            ),
                          );
                        }),
                        if (challenges.length < 5)
                          BetCard(
                            isEmpty: true,
                            onTap: () => Navigator.pushNamed(context, '/create'),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
