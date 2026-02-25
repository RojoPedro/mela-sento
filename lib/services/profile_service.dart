import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<Map<String, dynamic>> getProfileStream() {
    final user = _supabase.auth.currentUser;
    if (user == null) return const Stream.empty();
    
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .map((list) => list.first);
  }
}
