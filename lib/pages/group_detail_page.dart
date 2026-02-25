import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_badge.dart';
import '../core/theme.dart';
import '../services/bet_service.dart';

class GroupDetailPage extends StatefulWidget {
  const GroupDetailPage({super.key});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final BetService _betService = BetService();
  bool _isJoining = false;

  void _showGroupInfo(String challengeId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StreamBuilder<List<Map<String, dynamic>>>(
        stream: _betService.getParticipantsStream(challengeId),
        builder: (context, snapshot) {
          final participants = snapshot.data ?? [];
          return GlassCard(
            height: MediaQuery.of(context).size.height * 0.7,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.group_rounded, color: AppColors.electricCyan),
                    const SizedBox(width: 12),
                    Text('Participants', style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    Text('${participants.length} Total', style: const TextStyle(color: Colors.white54)),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final p = participants[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: Icon(Icons.person, size: 16, color: p['choice'] == 'YES' ? AppColors.neonGreen : Colors.redAccent),
                        ),
                        title: Text('User ${p['user_id'].toString().substring(0, 5)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Choice: ${p['choice']} • Amount: ${p['amount']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        trailing: const Icon(Icons.check_circle_outline, color: AppColors.neonGreen, size: 16),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final challengeId = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<Map<String, dynamic>>(
      stream: _betService.getChallengeStream(challengeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final challenge = snapshot.data!;
        final statusStr = challenge['status'] as String;
        BetStatus status = BetStatus.none;
        if (statusStr == 'table') status = BetStatus.table;
        if (statusStr == 'live') status = BetStatus.live;
        if (statusStr == 'ended') status = BetStatus.ended;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => _showGroupInfo(challengeId),
                icon: const Icon(Icons.info_outline_rounded, color: AppColors.electricCyan),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Hero(
                      tag: 'bet_card_${challenge['title']}',
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildHeaderState(status, challenge),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text('Challenge Activity', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)),
                ),
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _betService.getParticipantsStream(challengeId),
                builder: (context, partSnapshot) {
                  final participants = partSnapshot.data ?? [];
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildActivityItem(participants[index]),
                      childCount: participants.length,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildHeaderState(BetStatus status, Map<String, dynamic> challenge) {
    switch (status) {
      case BetStatus.table:
        return GlassCard(
          key: const ValueKey('table'),
          padding: const EdgeInsets.all(24),
          color: AppColors.accentYellow.withOpacity(0.1),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const StatusBadge(status: BetStatus.table),
               const SizedBox(height: 16),
               Text(challenge['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
               const SizedBox(height: 16),
               Text('Entry Fee: ${challenge['entry_fee']} Credits', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
               const SizedBox(height: 24),
               ElevatedButton(
                 onPressed: _isJoining ? null : () async {
                   setState(() => _isJoining = true);
                   try {
                     await _betService.joinChallenge(
                       challengeId: challenge['id'],
                       choice: 'YES', // Placeholder choice
                       amount: (challenge['entry_fee'] as num).toDouble(),
                     );
                   } catch (e) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                   } finally {
                     setState(() => _isJoining = false);
                   }
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.neonGreen,
                   foregroundColor: Colors.black,
                   minimumSize: const Size(double.infinity, 60),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                   elevation: 8,
                 ),
                 child: Text(_isJoining ? 'JOINING...' : 'JOIN BET', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
               ),
             ],
          ),
        );
      case BetStatus.live:
        return GlassCard(
          key: const ValueKey('live'),
          padding: const EdgeInsets.all(24),
          color: AppColors.accentBlue.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const StatusBadge(status: BetStatus.live),
              const SizedBox(height: 20),
              const Icon(Icons.lock_rounded, size: 40, color: Colors.white24),
              const SizedBox(height: 16),
              const Text('LIVE POOL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 20)),
              const SizedBox(height: 8),
              Text(challenge['title'], style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            ],
          ),
        );
      case BetStatus.ended:
        return GlassCard(
          key: const ValueKey('ended'),
          padding: const EdgeInsets.all(24),
          color: AppColors.accentOrange.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const StatusBadge(status: BetStatus.ended),
               const SizedBox(height: 20),
               const Text('WAITING FOR RESULT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
               const SizedBox(height: 16),
               Text(challenge['title'], style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
             ],
          ),
        );
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildActivityItem(Map<String, dynamic> participant) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (participant['choice'] == 'YES' ? AppColors.neonGreen : Colors.redAccent).withOpacity(0.1),
            child: Icon(
              participant['choice'] == 'YES' ? Icons.arrow_upward : Icons.arrow_downward,
              color: participant['choice'] == 'YES' ? AppColors.neonGreen : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ${participant['user_id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Placed ${participant['choice']} for ${participant['amount']} credits', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Text('JOINED', style: TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
