import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';

class WaveformWidget extends StatefulWidget {
  @override
  _WaveformWidgetState createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget> {
  Stream<List<int>>? _micStream;
  List<double> _amplitudeData = [];
  final int _maxSamples = 100;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startListening() async {
    // Request microphone data as a stream of bytes
    _micStream = await MicStream.microphone(
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );

    // Listen to microphone data
    _micStream?.listen((data) {
      // Convert byte data to amplitudes
      List<int> amplitudes = Uint8List.fromList(data).buffer.asInt16List();
      double avgAmplitude = amplitudes.map((e) => e.abs().toDouble()).reduce((a, b) => a + b) / amplitudes.length;

      setState(() {
        if (_amplitudeData.length > _maxSamples) {
          _amplitudeData.removeAt(0);
        }
        _amplitudeData.add(avgAmplitude / 32768); // Normalize amplitude
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(_amplitudeData),
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.black,
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;

  WaveformPainter(this.amplitudes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double step = size.width / (amplitudes.length > 1 ? amplitudes.length - 1 : 1);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * step;
      final y = size.height / 2 - (amplitudes[i] * size.height / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

