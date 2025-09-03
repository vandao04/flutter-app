class AppConfig {
  // Environment Configuration
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev-api.example.com',
  );
  
  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );
  
  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration sendTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 12);
  
  // App Configuration
  static const String appName = "MVP App";
  static const String appVersion = "1.0.0";
  static const String appBuildNumber = "1";
  
  // Feature Flags
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );
  
  static const bool enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: false,
  );
  
  static const bool enablePushNotifications = bool.fromEnvironment(
    'ENABLE_PUSH_NOTIFICATIONS',
    defaultValue: true,
  );
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Cache Configuration
  static const Duration cacheTimeout = Duration(hours: 1);
  static const int maxCacheSize = 100; // MB
  
  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  static const double backoffMultiplier = 2.0;
  
  // Environment Getters
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';
  
  // Debug Configuration
  static bool get isDebug => isDevelopment;
  static bool get showDebugBanner => isDevelopment;
  static bool get enableLogging => bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  
  // API Endpoints
  static String get apiBaseUrl {
    // Check if baseUrl already contains '/api'
    if (baseUrl.endsWith('/api')) {
      return baseUrl;
    }
    
    final version = apiVersion;
    if (version.isEmpty) {
      return baseUrl;
    }
    return '$baseUrl/api';
  }
  static String get authEndpoint => '$apiBaseUrl/auth';
  static String get userEndpoint => '$apiBaseUrl/users';
  static String get uploadEndpoint => '$apiBaseUrl/upload';
  
  // Social Login Configuration
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: 'your_google_client_id',
  );
  
  static const String facebookAppId = String.fromEnvironment(
    'FACEBOOK_APP_ID',
    defaultValue: 'your_facebook_app_id',
  );
  
  // Payment Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'your_stripe_key',
  );
  
  static const String paypalClientId = String.fromEnvironment(
    'PAYPAL_CLIENT_ID',
    defaultValue: 'your_paypal_client_id',
  );
  
  // Analytics Configuration
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'your_firebase_project_id',
  );
  
  static const String mixpanelToken = String.fromEnvironment(
    'MIXPANEL_TOKEN',
    defaultValue: 'your_mixpanel_token',
  );
  
  // Error Reporting
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'your_sentry_dsn',
  );
  
  // App Store Configuration
  static const String appStoreId = String.fromEnvironment(
    'APP_STORE_ID',
    defaultValue: 'your_app_store_id',
  );
  
  static const String playStoreId = String.fromEnvironment(
    'PLAY_STORE_ID',
    defaultValue: 'your_play_store_id',
  );
  
  // Support Configuration
  static const String supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@example.com',
  );
  
  static const String supportPhone = String.fromEnvironment(
    'SUPPORT_PHONE',
    defaultValue: '+84 123 456 789',
  );
  
  static const String supportWebsite = String.fromEnvironment(
    'SUPPORT_WEBSITE',
    defaultValue: 'https://support.example.com',
  );
  
  // Privacy Policy & Terms
  static const String privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://example.com/privacy',
  );
  
  static const String termsOfServiceUrl = String.fromEnvironment(
    'TERMS_OF_SERVICE_URL',
    defaultValue: 'https://example.com/terms',
  );
  
  // Social Media
  static const String facebookUrl = String.fromEnvironment(
    'FACEBOOK_URL',
    defaultValue: 'https://facebook.com/yourapp',
  );
  
  static const String twitterUrl = String.fromEnvironment(
    'TWITTER_URL',
    defaultValue: 'https://twitter.com/yourapp',
  );
  
  static const String instagramUrl = String.fromEnvironment(
    'INSTAGRAM_URL',
    defaultValue: 'https://instagram.com/yourapp',
  );
  
  static const String linkedinUrl = String.fromEnvironment(
    'LINKEDIN_URL',
    defaultValue: 'https://linkedin.com/company/yourapp',
  );
  
  // App Store URLs
  static String get appStoreUrl => 'https://apps.apple.com/app/id$appStoreId';
  static String get playStoreUrl => 'https://play.google.com/store/apps/details?id=$playStoreId';
  
  // Deep Link Configuration
  static const String deepLinkScheme = String.fromEnvironment(
    'DEEP_LINK_SCHEME',
    defaultValue: 'mvpapp',
  );
  
  static const String deepLinkHost = String.fromEnvironment(
    'DEEP_LINK_HOST',
    defaultValue: 'example.com',
  );
  
  // Notification Configuration
  static const String fcmSenderId = String.fromEnvironment(
    'FCM_SENDER_ID',
    defaultValue: 'your_fcm_sender_id',
  );
  
  static const String fcmServerKey = String.fromEnvironment(
    'FCM_SERVER_KEY',
    defaultValue: 'your_fcm_server_key',
  );
  
  // File Upload Configuration
  static const int maxFileSize = int.fromEnvironment(
    'MAX_FILE_SIZE',
    defaultValue: 10 * 1024 * 1024, // 10MB
  );
  
  static const List<String> allowedFileTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'xls', 'xlsx'
  ];
  
  // Security Configuration
  static const bool enableBiometricAuth = bool.fromEnvironment(
    'ENABLE_BIOMETRIC_AUTH',
    defaultValue: false,
  );
  
  static const bool enableEncryption = bool.fromEnvironment(
    'ENABLE_ENCRYPTION',
    defaultValue: true,
  );
  
  // Localization Configuration
  static const String defaultLanguage = String.fromEnvironment(
    'DEFAULT_LANGUAGE',
    defaultValue: 'en',
  );
  
  static const List<String> supportedLanguages = ['en', 'vi', 'zh', 'ja'];
  
  // Theme Configuration
  static const String defaultTheme = String.fromEnvironment(
    'DEFAULT_THEME',
    defaultValue: 'system',
  );
  
  // Performance Configuration
  static const bool enablePerformanceMonitoring = bool.fromEnvironment(
    'ENABLE_PERFORMANCE_MONITORING',
    defaultValue: false,
  );
  
  static const Duration cacheCleanupInterval = Duration(hours: 24);
}