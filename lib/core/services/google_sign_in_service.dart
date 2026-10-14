// app/lib/core/services/google_sign_in_service.dart
// Handles Google Sign-In for Android (native token flow).
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../network/app_failure.dart';

// Google OAuth Web Client ID — passed via --dart-define=GOOGLE_CLIENT_ID=...
// Falls back to the development client ID if not provided.
const _webClientId = String.fromEnvironment(
  'GOOGLE_CLIENT_ID',
  defaultValue: '28214564202-3kl2pndsjss9ihti1lkmsi1mtdcs05gl.apps.googleusercontent.com',
);

class GoogleSignInService {
  static final _googleSignIn = GoogleSignIn(
    serverClientId: _webClientId,
    scopes: ['email', 'profile'],
  );

  static Future<(bool, AppFailure?)> signIn() async {
    try {
      // Trigger the Google sign-in flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled
        return (false, null);
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return (false, const ServerFailure('Google sign-in failed: no ID token.'));
      }

      // Sign in to Supabase with Google credentials
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return (true, null);
    } on AuthException catch (e) {
      return (false, ServerFailure(e.message));
    } catch (e) {
      return (false, ServerFailure('Google sign-in failed: $e'));
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
