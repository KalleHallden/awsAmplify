import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:math';


class WaveFormWidget extends StatefulWidget {
  @override
  _WaveFormWidgetState createState() => _WaveFormWidgetState();
}

class _WaveFormWidgetState extends State<WaveFormWidget> {
  FlutterSoundRecorder? _recorder; // Declare as nullable
  bool _isRecording = false;
  List<double> _lineHeights = List.generate(10, (index) => 0.0); // Initial line heights
  StreamSubscription? _volumeSubscription; // Declare as nullable

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  @override
  void dispose() {
    _volumeSubscription?.cancel();
    super.dispose();
  }
Future<void> _initRecorder() async {
  _recorder = FlutterSoundRecorder(); // Initialize the recorder
  await _recorder?.startRecorder(toFile: 'audio.mp4');
  setState(() {
    _isRecording = true;
  });

  // Start listening to the volume levels using onProgress
  _volumeSubscription = _recorder?.onProgress?.listen((event) {
    if (event != null && event.decibels != null) {
      setState(() {
        // Update the line heights based on the decibel level
        _updateWaveform(event.decibels!);
      });
    }
  });
}
  


  // Update waveform based on volume level
  void _updateWaveform(double decibels) {
    // Decibel to volume height transformation logic
    double maxHeight = 100.0; // Maximum line height
    List<double> newLineHeights = List.generate(10, (index) {
      double height = (decibels + index) * maxHeight / 100.0;
      return height.clamp(0.0, maxHeight); // Ensure height is within bounds
    });
    setState(() {
      _lineHeights = newLineHeights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200), // Define the size of the widget
      painter: WaveformPainter(_lineHeights),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> lineHeights;

  WaveformPainter(this.lineHeights);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Draw circle
    canvas.drawCircle(Offset(centerX, centerY), size.width / 2, paint);

    // Draw the lines
    double angleStep = 360 / lineHeights.length;
    for (int i = 0; i < lineHeights.length; i++) {
      double angle = angleStep * i;
      double lineLength = lineHeights[i];
      double x1 = centerX + (lineLength * cos(angle * 3.1415927 / 180));
      double y1 = centerY + (lineLength * sin(angle * 3.1415927 / 180));
      canvas.drawLine(Offset(centerX, centerY), Offset(x1, y1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

