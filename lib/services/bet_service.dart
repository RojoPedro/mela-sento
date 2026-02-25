import 'package:supabase_flutter/supabase_flutter.dart';

class BetService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Challenges
  Stream<List<Map<String, dynamic>>> getChallengesStream() {
    return _supabase
        .from('challenges')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Stream<Map<String, dynamic>> getChallengeStream(String id) {
    return _supabase
        .from('challenges')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((list) => list.first);
  }

  Future<void> createChallenge({
    required String title,
    required double entryFee,
    String? description,
    DateTime? startsAt,
    DateTime? endsAt,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Must be logged in');

    await _supabase.from('challenges').insert({
      'creator_id': user.id,
      'title': title,
      'description': description,
      'entry_fee': entryFee,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
    });
  }

  // Participants
  Future<void> joinChallenge({
    required String challengeId,
    required String choice, // 'YES' or 'NO'
    required double amount,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Must be logged in');

    await _supabase.from('challenge_participants').insert({
      'challenge_id': challengeId,
      'user_id': user.id,
      'choice': choice,
      'amount': amount,
    });
  }

  Stream<List<Map<String, dynamic>>> getParticipantsStream(String challengeId) {
    return _supabase
        .from('challenge_participants')
        .stream(primaryKey: ['id'])
        .eq('challenge_id', challengeId);
  }
}
