import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularAudioWaveform extends StatefulWidget {
  @override
  _CircularAudioWaveformState createState() => _CircularAudioWaveformState();
}

class _CircularAudioWaveformState extends State<CircularAudioWaveform>
    with SingleTickerProviderStateMixin {
  double _amplitude = 0.0; // Simulated amplitude value
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Simulate audio amplitude changes
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
	      _amplitude = 0.9 * _amplitude + 0.1 * math.Random().nextDouble();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CustomPaint(
          size: Size(200, 200),
          painter: CircularWaveformPainter(_amplitude),
        ),
      ),
    );
  }
}

class CircularWaveformPainter extends CustomPainter {
  final double amplitude; // Current amplitude value (0.0 to 1.0)

  CircularWaveformPainter(this.amplitude);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = 60.0;
    final maxVariation = 20.0;
    final segments = 100; // Number of segments for the circle

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    for (int i = 0; i <= segments; i++) {
      final angle = (2 * math.pi / segments) * i;
      final variation = amplitude * maxVariation;
      final currentRadius = baseRadius + variation;

      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CircularWaveformPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}

void main() {
  runApp(MaterialApp(
    home: CircularAudioWaveform(),
  ));
}

