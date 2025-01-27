import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:call_app/components/log_sink.dart';
import 'package:call_app/config/agora.config.dart';
import 'package:call_app/pages/waveform.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

class JoinChannelAudio extends StatefulWidget {
	final String channelID;
  const JoinChannelAudio({Key? key, required this.channelID}) : super(key: key);

  @override
  _JoinChannelAudioState createState() => _JoinChannelAudioState();
}

class _JoinChannelAudioState extends State<JoinChannelAudio> {
  late final RtcEngine _engine;
  late String channelID; // Replace with your actual channel ID
  bool isJoined = false;
  late RtcEngineEventHandler _rtcEngineEventHandler;
  late double volume; 
  List<AudioVolumeInfo> volumeInfo = [];
  bool shouldUpdate = true;

  @override
  void initState() {
	  volume = 0.0;
	  channelID = widget.channelID;
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
      
onAudioVolumeIndication: (RtcConnection connection, List<AudioVolumeInfo> volumeInfos, int speakerId, int elapsed) {
  for (var volumeInfo in volumeInfos) {
    volume += volumeInfo.volume!; // Sum the volumes of all speakers
  }

    _updateWaveform(volume / 10); // Update the waveform based on volume
},
      
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);
    await _engine.enableAudioVolumeIndication(interval: 200, smooth: 3, reportVad: true);

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
	await _joinChannel();
  }

double _maxVolumeSeen = 1.0;
 void _updateWaveform(double newVolume) {
	 if (newVolume > _maxVolumeSeen) {
      _maxVolumeSeen = newVolume;
    }
	    if (shouldUpdate) {
		    shouldUpdate = !shouldUpdate;

    setState(() {
	    if (_maxVolumeSeen == 0) volume = 0; // avoid divide by zero
    volume = (newVolume / _maxVolumeSeen).clamp(0.0, 1.0);
    });
	    }
  }

  Future<void> _joinChannel() async {
    // Check if the platform is Android
	await Permission.microphone.request();

    await _engine.joinChannel(
      token: token,  // Replace with your actual token
      channelId: channelId,
      uid: uid,  // Replace with your actual user ID
      options: ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
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
	  shouldUpdate = true;
	  return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              // Replace with your waveform widget
	  Container(
        // Make it a circle, so width == height
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          // Drop shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(2, 4), // Position of the shadow
            ),
          ],
        ),
        // Use a CustomPaint child to draw your waveform
        child: CustomPaint(
          // painter will fill the *available* space, which is our 200×200 circle
          painter: WaveformWidget(volume),
        ),
      ),	
      ],
    );
  }
}

