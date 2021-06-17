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

    audioWaveController = AudioWaveController(abars: [
      30,
      50,
      40,
      60,
      70,
      40,
      20,
      10,
      30,
      50,
      40,
      60,
      90,
      100,
      30,
      50,
      40,
      60,
      70,
      40,
      20,
      10,
      30,
      50,
      40,
      60,
      90,
      100,
      30,
      50,
      40,
      60,
      70,
      40,
      20,
      10,
      30,
      50,
      40,
      60,
      90,
      100,
      30,
      70,
      40,
      20,
      10,
      30,
      50,
      40,
      60,
      90,
      100,
      30,
    ]);
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
