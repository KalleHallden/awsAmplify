import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

class LiveWaveformExample extends StatefulWidget {
  @override
  _LiveWaveformExampleState createState() => _LiveWaveformExampleState();
}

class _LiveWaveformExampleState extends State<LiveWaveformExample> {
  final RecorderController _recorderController = RecorderController();

  @override
  void initState() {
    super.initState();
    _recorderController.start();
  }

  @override
  void dispose() {
    _recorderController.stop();
    _recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Waveform Example')),
      body: Center(
        child: AudioWaveforms(
          size: Size(MediaQuery.of(context).size.width, 100),
          recorderController: _recorderController,
          waveStyle: const WaveStyle(
            waveColor: Colors.blue,
            extendWaveform: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_recorderController.isRecording) {
            _recorderController.pause();
          } else {
            _recorderController.record();
          }
          setState(() {});
        },
        child: Icon(
          _recorderController.isRecording ? Icons.stop : Icons.mic,
        ),
      ),
    );
  }
}

