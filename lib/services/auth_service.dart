import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<bool> signInWithGoogle() async {
    // Note: For actual production, you need to configure Native Google Sign-In
    // with your platform specific settings (Google Cloud Console, iOS Info.plist, Android google-services.json)
    
    // This is the implementation for Web/Native using the Supabase flow
    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.pedrito.melasento://login-callback/',
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
