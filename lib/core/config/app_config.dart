/// App configuration per environment.
///
/// Do NOT hardcode URLs anywhere else — always read them from here.
enum Environment { local, dev, staging, production }

class AppConfig {
  static Environment _environment = Environment.dev;
  static Env? _currentEnv;

  static Env? get currentEnv => _currentEnv;

  static void setEnvironment(Environment env) {
    _environment = env;
    _currentEnv = _getEnvConfig(env);
  }

  static Env _getEnvConfig(Environment env) {
    switch (env) {
      case Environment.local:
        return EnvValue.local;
      case Environment.dev:
        return EnvValue.development;
      case Environment.staging:
        return EnvValue.staging;
      case Environment.production:
        return EnvValue.production;
    }
  }

  // ── Environment ─────────────────────────────────────────────────────────

  static Environment get environment => _environment;
  static bool get isLocal => _environment == Environment.local;
  static bool get isDev => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;

  // ── Values ──────────────────────────────────────────────────────────────

  static String get baseUrl =>
      _currentEnv?.baseUrl ?? EnvValue.development.baseUrl;

  static String get appName => _currentEnv?.appName ?? 'ShopNepal';

  static String get appVersion => _currentEnv?.appVersion ?? '1.0.0';

  // ── Timeouts ────────────────────────────────────────────────────────────

  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);

  /// Uploading a supplier photo over a slow mobile connection, then waiting on
  /// the extraction model, takes far longer than an ordinary request.
  static Duration get sendTimeout => const Duration(seconds: 90);

  // ── Logging ─────────────────────────────────────────────────────────────

  static bool get enableLogging => !isProduction;

  static bool get enableDetailedLogging => !isProduction;
}

class Env {
  final String baseUrl;
  final String appName;
  final String appVersion;

  const Env({
    required this.baseUrl,
    this.appName = 'ShopNepal',
    this.appVersion = '1.0.0',
  });
}

class EnvValue {
  /// Local backend. `10.0.2.2` is how the Android emulator reaches the host
  /// machine's localhost; on a physical device use the machine's LAN IP.
  static const Env local = Env(
    baseUrl: 'http://10.0.2.2:8000',
    appName: 'ShopNepal Local',
    appVersion: '0.1.0-local',
  );

  static const Env development = Env(
    baseUrl: 'http://192.168.2.123:8000',
    appName: 'ShopNepal Dev',
    appVersion: '0.1.0-dev',
  );

  static const Env staging = Env(
    baseUrl: '',
    appName: 'ShopNepal Staging',
    appVersion: '0.1.0-staging',
  );

  static const Env production = Env(
    baseUrl: '',
    appName: 'ShopNepal',
    appVersion: '0.1.0',
  );
}
