import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:call_app/components/log_sink.dart';
import 'package:call_app/config/agora.config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

class JoinChannelAudio extends StatefulWidget {
  const JoinChannelAudio({Key? key}) : super(key: key);

  @override
  _JoinChannelAudioState createState() => _JoinChannelAudioState();
}

class _JoinChannelAudioState extends State<JoinChannelAudio> {
  late final RtcEngine _engine;
  String channelID= channelId;  // Replace with your actual channel ID
  bool isJoined = false;
  late RtcEngineEventHandler _rtcEngineEventHandler;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId)); // Replace with your actual appId
        _rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
	      print(err);
	      print(msg);
        logSink.log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
	      print("Joined channel");
        logSink.log(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      onRemoteAudioStateChanged: (RtcConnection connection, int remoteUid,
          RemoteAudioState state, RemoteAudioStateReason reason, int elapsed) {
        logSink.log(
            '[onRemoteAudioStateChanged] connection: ${connection.toJson()} remoteUid: $remoteUid state: $state reason: $reason elapsed: $elapsed');
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logSink.log(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        setState(() {
          isJoined = false;
        });
      },
      onAudioRoutingChanged: (routing) {
        logSink.log('[onAudioRoutingChanged] routing: $routing');
      },
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
  }

  Future<void> _joinChannel() async {
    // Check if the platform is Android
	await Permission.microphone.request();

    await _engine.joinChannel(
      token: token,  // Replace with your actual token
      channelId: channelId,
      uid: uid,  // Replace with your actual user ID
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    if (mounted) {
      setState(() {
        isJoined = true;
      });
    }
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    if (mounted) {
      setState(() {
        isJoined = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isJoined ? _leaveChannel : _joinChannel,
      child: Text(isJoined ? 'Leave Channel' : 'Join Channel'),
    );
  }
}

