// app/lib/core/services/google_sign_in_service.dart
// Handles Android native and Windows browser Google sign-in flows.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../platform/platform_info.dart';
import '../network/app_failure.dart';

// Google OAuth Web Client ID — passed via --dart-define=GOOGLE_CLIENT_ID=...
// Falls back to the development client ID if not provided.
const _webClientId = String.fromEnvironment(
  'GOOGLE_CLIENT_ID',
  defaultValue:
      '28214564202-ipt1b5hk29s9nv8aeq54r4vri2bogvo0.apps.googleusercontent.com',
);

class GoogleSignInService {
  static final _googleSignIn = GoogleSignIn(
    serverClientId: _webClientId,
    scopes: ['email', 'profile'],
  );

  static Future<(bool, AppFailure?)> signIn({
    required String browserCompleteMessage,
    required String browserFailureMessage,
  }) {
    if (PlatformInfo.isWindows) {
      return _signInWithWindowsBrowser(
        browserCompleteMessage: browserCompleteMessage,
        browserFailureMessage: browserFailureMessage,
      );
    }
    return _signInWithNativeGoogle();
  }

  static Future<(bool, AppFailure?)> _signInWithNativeGoogle() async {
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
        return (
          false,
          const AuthFailure(AuthFailureReason.googleSignInFailed),
        );
      }

      // Sign in to Supabase with Google credentials
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return (true, null);
    } on AuthException {
      return (
        false,
        const AuthFailure(AuthFailureReason.googleSignInFailed),
      );
    } catch (_) {
      return (
        false,
        const AuthFailure(AuthFailureReason.googleSignInFailed),
      );
    }
  }

  static Future<(bool, AppFailure?)> _signInWithWindowsBrowser({
    required String browserCompleteMessage,
    required String browserFailureMessage,
  }) async {
    HttpServer? callbackServer;
    try {
      callbackServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final redirectUri = Uri(
        scheme: 'http',
        host: '127.0.0.1',
        port: callbackServer.port,
        path: '/auth/callback',
      );
      final oauth = await Supabase.instance.client.auth.getOAuthSignInUrl(
        provider: OAuthProvider.google,
        redirectTo: redirectUri.toString(),
      );
      final launched = await launchUrl(
        Uri.parse(oauth.url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        return (
          false,
          const AuthFailure(AuthFailureReason.googleSignInFailed),
        );
      }

      final request = await callbackServer.first.timeout(
        const Duration(minutes: 5),
      );
      if (request.method != 'GET' || request.uri.path != '/auth/callback') {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return (
          false,
          const AuthFailure(AuthFailureReason.googleSignInFailed),
        );
      }

      try {
        await Supabase.instance.client.auth.getSessionFromUrl(request.uri);
      } catch (_) {
        await _writeCallbackPage(
          request,
          browserFailureMessage,
          HttpStatus.badRequest,
        );
        return (
          false,
          const AuthFailure(AuthFailureReason.googleSignInFailed),
        );
      }

      await _writeCallbackPage(request, browserCompleteMessage, HttpStatus.ok);
      return (true, null);
    } on TimeoutException {
      return (
        false,
        const AuthFailure(AuthFailureReason.googleSignInFailed),
      );
    } on AuthException {
      return (
        false,
        const AuthFailure(AuthFailureReason.googleSignInFailed),
      );
    } catch (_) {
      return (
        false,
        const AuthFailure(AuthFailureReason.googleSignInFailed),
      );
    } finally {
      await callbackServer?.close(force: true);
    }
  }

  static Future<void> _writeCallbackPage(
    HttpRequest request,
    String message,
    int statusCode,
  ) async {
    final safeMessage = const HtmlEscape().convert(message);
    request.response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.html
      ..write(
        '<!doctype html><html><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width, initial-scale=1">'
        '</head><body><p>$safeMessage</p></body></html>',
      );
    await request.response.close();
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}
