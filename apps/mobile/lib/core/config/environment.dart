// ─── Yugrow Environment Configuration ──────────────────────────────
// Single source of truth for all environment-specific settings.
// Override at build time with --dart-define.
//
// Usage:
//   flutter run --dart-define=API_BASE_URL=http://192.168.1.100:4000
//   flutter build apk --dart-define=API_BASE_URL=https://api.yugrow.com
//
// Default: localhost:4000 (local development)

class Environment {
  Environment._();

  static String get apiBaseUrl {
    const defaultValue = 'http://localhost:4000';
    // Allow override via --dart-define
    const override = String.fromEnvironment('API_BASE_URL');
    return override.isNotEmpty ? override : defaultValue;
  }

  static bool get isProduction {
    return apiBaseUrl.startsWith('https://');
  }

  static bool get isLocalDevelopment {
    return apiBaseUrl.contains('localhost');
  }

  static String get environmentName {
    if (isProduction) return 'production';
    if (apiBaseUrl.contains('staging')) return 'staging';
    return 'development';
  }
}
