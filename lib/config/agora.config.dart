import 'package:call_app/components/config_override.dart';
import 'dart:math';

/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // You can directly edit this code to return the appId you want.
  return ExampleConfigOverride().getAppId();
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get token {
  // You can directly edit this code to return the token you want.
  return ExampleConfigOverride().getToken();
}

/// Your channel ID
String get channelId {
  // You can directly edit this code to return the channel ID you want.
  return ExampleConfigOverride().getChannelId();
}
Random random = Random();
/// Your int user ID
int uid = random.nextInt(100);

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
String stringUid = uid.toString();

String get musicCenterAppId {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment('MUSIC_CENTER_APPID',
      defaultValue: '<MUSIC_CENTER_APPID>');
}
