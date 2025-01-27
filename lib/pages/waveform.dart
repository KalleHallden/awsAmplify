import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveformWidget extends CustomPainter {
  final double amplitude;

  WaveformWidget(this.amplitude);

@override
void paint(Canvas canvas, Size size) {
  const double maxBarHeight = 100.0;
  final double halfBarHeight = maxBarHeight / 2;

  final Paint paint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final double centerY = size.height / 2;

  // The wave uses 13 lines
  const int numberOfPoints = 13;

  // 80% of the total width
  final double waveWidth = size.width * 0.5;
  // Horizontal offset to center the wave
  final double offsetX = (size.width - waveWidth) / 2;

  final Path path = Path();
  for (int i = 0; i < numberOfPoints; i++) {
    // x runs from offsetX .. offsetX + waveWidth
    final double x = offsetX + waveWidth * (i / (numberOfPoints - 1));

    final double fluctuation = math.sin(i + amplitude * math.pi * 2)
                               * amplitude
                               * halfBarHeight;

    path.moveTo(x, centerY - fluctuation);
    path.lineTo(x, centerY + fluctuation);
  }

  canvas.drawPath(path, paint);
}

  @override
  bool shouldRepaint(covariant WaveformWidget oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}

