// ─── Yugrow Environment Configuration ──────────────────────────────
// Single source of truth for all environment-specific settings.
//
// Usage — explicit flavor:
//   flutter run --flavor dev --dart-define=API_BASE_URL=http://localhost:4000
//   flutter run --flavor staging --dart-define=API_BASE_URL=https://api-staging.yugrow.app
//   flutter run --flavor prod --dart-define=API_BASE_URL=https://api.yugrow.app
//
// Usage — override only:
//   flutter run --dart-define=API_BASE_URL=http://192.168.1.100:4000
//
// Default: development, localhost:4000

enum Flavor { development, staging, production }

class Environment {
  Environment._();

  /// The active flavor, set at compile time via --flavor or --dart-define=FLAVOR.
  /// Defaults to development.
  static Flavor get flavor {
    const flavorName = String.fromEnvironment('FLAVOR');
    switch (flavorName) {
      case 'staging':
        return Flavor.staging;
      case 'production':
      case 'prod':
        return Flavor.production;
      default:
        return Flavor.development;
    }
  }

  /// The API base URL. Override via --dart-define=API_BASE_URL.
  /// Defaults based on flavor.
  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;

    return switch (flavor) {
      Flavor.development => 'http://localhost:4000',
      Flavor.staging => 'https://api-staging.yugrow.app',
      Flavor.production => 'https://api.yugrow.app',
    };
  }

  /// The app's public URL. Used for deep links and sharing.
  static String get appUrl {
    return switch (flavor) {
      Flavor.development => 'http://dev.yugrow.app:3000',
      Flavor.staging => 'https://staging.yugrow.app',
      Flavor.production => 'https://yugrow.app',
    };
  }

  /// Human-readable environment name for display and analytics.
  static String get environmentName => flavor.name;

  static bool get isProduction => flavor == Flavor.production;
  static bool get isStaging => flavor == Flavor.staging;
  static bool get isDevelopment => flavor == Flavor.development;
}
