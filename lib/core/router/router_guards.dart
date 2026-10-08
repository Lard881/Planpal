import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth guard that redirects to login if user is not authenticated.
/// Used for protected routes that require authentication.
String? authGuard(BuildContext context, GoRouterState state) {
  final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
  
  if (!isAuthenticated) {
    // User not signed in, redirect to login
    return '/login';
  }
  
  // User is authenticated, allow access
  return null;
}

/// Login guard that redirects to home if user is already authenticated.
/// Prevents authenticated users from accessing login/signup screens.
String? loginGuard(BuildContext context, GoRouterState state) {
  final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
  
  if (isAuthenticated) {
    // User already signed in, redirect to home
    return '/home';
  }
  
  // User not authenticated, allow access to login
  return null;
}
