/// Environment configuration for sensitive keys.
///
/// ⚠️ Copy this file to `env.dart` and fill in your actual values.
/// NEVER commit `env.dart` to version control.
abstract class Env {
  /// Google OAuth Web Client ID from Google Cloud Console.
  /// Get this from: https://console.cloud.google.com/apis/credentials
  static const String googleServerClientId = 'YOUR_GOOGLE_SERVER_CLIENT_ID';
}
