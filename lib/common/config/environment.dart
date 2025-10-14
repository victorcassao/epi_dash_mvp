enum Environment { development, staging, production }

class AppConfig {
  final Environment environment;

  AppConfig({required this.environment});

  String get apiBaseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:80/api/v1';
      case Environment.staging:
        return 'https://staging-api.exemplo.com/api/v1';
      case Environment.production:
        return 'https://api.exemplo.com/api/v1';
    }
  }

  String get hlsBaseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:8888';
      case Environment.staging:
        return 'https://staging-stream.exemplo.com';
      case Environment.production:
        return 'https://stream.exemplo.com';
    }
  }

  // Configurações adicionais por ambiente
  Duration get timeout {
    return environment == Environment.development
        ? const Duration(seconds: 60)  // Mais tempo em dev para debug
        : const Duration(seconds: 30);
  }

  bool get enableLogging {
    return environment != Environment.production;
  }

  int get maxRetries {
    return environment == Environment.production ? 3 : 1;
  }
}

