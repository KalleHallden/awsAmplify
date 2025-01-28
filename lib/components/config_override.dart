/// Key of APP ID
const keyAppId = '1bb00109d8954dabb1210ccd4562bb5f';

/// Key of Channel ID
const keyChannelId = 'test';

/// Key of token
const keyToken = '007eJxTYAhstF0crsmQee7O+7JO93SHjzrnLp9JXaN0tXVD/mVFwdsKDIZJSQYGhgaWKRaWpiYpiUlJhkaGBsnJKSamZkZJSaZpu6r60xsCGRmuOjcyMEIhiM/CUJJaXMLAAAB6OCB7';

ExampleConfigOverride? _gConfigOverride;

/// This class allow override the config(appId/channelId/token) in the example.
class ExampleConfigOverride {
  ExampleConfigOverride._();

  factory ExampleConfigOverride() {
    _gConfigOverride = _gConfigOverride ?? ExampleConfigOverride._();
    return _gConfigOverride!;
  }
  final Map<String, String> _overridedConfig = {};

  /// Get the expected APP ID
  String getAppId() {
    return _overridedConfig[keyAppId] ??
        // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
        const String.fromEnvironment(keyAppId, defaultValue: '1bb00109d8954dabb1210ccd4562bb5f');
  }

  /// Get the expected Channel ID
  String getChannelId() {
    return _overridedConfig[keyChannelId] ??
        // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
        const String.fromEnvironment(keyChannelId,
            defaultValue: 'test');
  }

  /// Get the expected Token
  String getToken() {
    return _overridedConfig[keyToken] ??
        // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
        const String.fromEnvironment(keyToken, defaultValue: '007eJxTYOi99GdrqV7vdD2F4iUSCyPLtbw11us2+jFHfr99vDepYKoCg2FSkoGBoYFlioWlqUlKYlKSoZGhQXJyiompmVFSkmla1skZ6Q2BjAzaB7OZGRkgEMRnYShJLS5hYAAAHXwfAw==');
  }

  /// Override the config(appId/channelId/token)
  void set(String name, String value) {
    _overridedConfig[name] = value;
  }

  /// Internal testing flag
  bool get isInternalTesting =>
      const bool.fromEnvironment('INTERNAL_TESTING', defaultValue: false);
}
