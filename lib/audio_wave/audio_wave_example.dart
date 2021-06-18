import 'package:audio_wave/audio_wave/audio_wave.dart';
import 'package:audio_wave/audio_wave/audio_wave_controller.dart';
import 'package:flutter/material.dart';

class AudioWaveExample extends StatefulWidget {
  @override
  _MainAudioWaveState createState() => _MainAudioWaveState();
}

class _MainAudioWaveState extends State<AudioWaveExample> {
  AudioWaveController audioWaveController;

  @override
  void initState() {
    super.initState();

    audioWaveController = AudioWaveController(audioPath: 'assets/preview.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Wave"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
              child: Text("Pause"),
              onPressed: () {
                audioWaveController.pause();
              }),
          RaisedButton(
              child: Text("Play"),
              onPressed: () {
                audioWaveController.play();
              }),
          AudioWave(
            audioWaveController: audioWaveController,
          ),
        ],
      )),
    );
  }
}
