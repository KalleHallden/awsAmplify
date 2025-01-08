import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioAmplitude extends StatefulWidget {
  final RTCPeerConnection peerConnection;

  const AudioAmplitude({Key? key, required this.peerConnection}) : super(key: key);

  @override
  _AudioAmplitudeState createState() => _AudioAmplitudeState();
}

class _AudioAmplitudeState extends State<AudioAmplitude> {
  double _amplitude = 0.0; // Smoothed audio level
  late Timer _timer;

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
        _amplitude = 0.5 * _amplitude + 0.5 * audioLevel;
      });
    });
  }

  Future<double> _getAudioLevelFromWebRTC() async {
    try {
      List<RTCRtpSender> senders = await widget.peerConnection.getSenders();

      for (var sender in senders) {
        if (sender.track?.kind == 'audio') {
          List<StatsReport> stats = await sender.getStats();

          for (var report in stats) {
            if (report.type == 'media-source' || report.values.containsKey('audioLevel')) {
              return report.values['audioLevel'] as double? ?? 0.0;
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching audio level: $e");
    }
    return 0.0; // Return 0 if no audio level is found
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(100, 300), // Width and height of the waveform canvas
        painter: WaveformPainter(_amplitude),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double amplitude;

  WaveformPainter(this.amplitude);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final maxAmplitude = size.height / 2;

    // Draw the waveform as a series of lines
    final path = Path();
    final numberOfPoints = 10; // Number of vertical lines in the waveform

    for (int i = 0; i < numberOfPoints; i++) {
      final x = size.width * (i / (numberOfPoints - 1));
      final fluctuation = math.sin(i + amplitude * math.pi * 2) * amplitude * maxAmplitude;

      path.moveTo(x, centerY - fluctuation);
      path.lineTo(x, centerY + fluctuation);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}

