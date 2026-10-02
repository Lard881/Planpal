/// Environment configuration
/// Use --dart-define to pass values at build time
class Env {
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://opaxrncjgwsenscltzxw.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYXhybmNqZ3dzZW5zY2x0enh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA2ODEzMDMsImV4cCI6MjEwNjI1NzMwM30.RiOSIouBxI_fXQH_Dk1lcbQcJ8rg_jjvmLrW1h2VIjQ',
  );

  // Backend API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://planpalbackend.onrender.com/api/v1',
  );

  // Google OAuth (will be added in Stage 4)
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  // Build mode checks
  static const bool isProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  static bool get isDevelopment => !isProduction;
}
