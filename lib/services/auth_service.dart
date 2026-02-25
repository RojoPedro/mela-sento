import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<bool> signInWithGoogle() async {
    // Note: For actual production, you need to configure Native Google Sign-In
    // with your platform specific settings (Google Cloud Console, iOS Info.plist, Android google-services.json)
    
    // Web needs an http/https redirect, while mobile uses deep links.
    final String redirectTo = kIsWeb 
        ? 'http://localhost:8080/auth/v1/callback' // We will force port 8080 for consistency
        : 'com.pedrito.melasento://login-callback/';

    return await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectTo,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
