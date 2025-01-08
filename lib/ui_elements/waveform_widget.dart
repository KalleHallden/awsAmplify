import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioAmplitude extends StatefulWidget {
  final RTCPeerConnection peerConnection; // Pass the RTCPeerConnection instance

  const AudioAmplitude({Key? key, required this.peerConnection}) : super(key: key);

  @override
  _AudioAmplitudeState createState() => _AudioAmplitudeState();
}

class _AudioAmplitudeState extends State<AudioAmplitude> {
  double _amplitude = 0.0; // Smoothed audio level
  late Timer _timer;
  double previousSize = 0.0;

  @override
  void initState() {
    super.initState();
    _startAudioLevelMonitoring();
  }

  Future<void> _startAudioLevelMonitoring() async {
    _timer = Timer.periodic(Duration(milliseconds: 100), (_) async {
      double audioLevel = await _getAudioLevelFromWebRTC();
      setState(() {
        // Smooth the audio level for a better animation effect
       // _amplitude = 0.9 * _amplitude + 0.1 * audioLevel;
	      _amplitude = audioLevel;
      });
    });
  }

  Future<double> _getAudioLevelFromWebRTC() async {
    try {
      // Get all RTCRtpSenders from the peer connection
      List<RTCRtpSender> senders = await widget.peerConnection.getSenders();

      for (var sender in senders) {
        if (sender.track?.kind == 'audio') {
          // Get WebRTC stats for the audio track
          List<StatsReport> stats = await sender.getStats();

          for (var report in stats) {
            if (report.type == 'media-source' || report.values.containsKey('audioLevel')) {
              // Extract the audioLevel value (0.0 to 1.0)
              return report.values['audioLevel'] as double? ?? 0.0;
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching audio level: $e");
    }
    print("no audio level");
    return 0.0; // Return 0 if no audio level is found
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
	  final double maxSize = 200.0;
	final double size = _amplitude * maxSize;
	double smoothingFactor = 0.95;
	final double smoothedSize = smoothingFactor * previousSize + (1-smoothingFactor) * size;
	previousSize = smoothedSize;
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
        alignment: Alignment.center,
        children: [
          // Glowing shadow effect
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: Colors.purple.withOpacity(0.3), // Shadow color
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Main circle with border
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent, // Circle color
              border: Border.all(
                color: Colors.purple, // Border color
                width: 1, // Border width
              ),
            ),
          ),
        ], 
	)]),
        );
  }
}

