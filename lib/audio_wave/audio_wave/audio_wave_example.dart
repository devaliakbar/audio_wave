import 'package:audio_wave/audio_wave/audio_wave/audio_wave.dart';
import 'package:audio_wave/audio_wave/audio_wave/audio_wave_controller.dart';
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

    audioWaveController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    audioWaveController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = audioWaveController.audioWaveStatus == AudioWaveStatus.play
        ? "Pause"
        : audioWaveController.audioWaveStatus == AudioWaveStatus.initialized ||
                audioWaveController.audioWaveStatus == AudioWaveStatus.pause
            ? "Play"
            : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Wave"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text(title ?? ""),
            onPressed: title == null
                ? null
                : () {
                    if (audioWaveController.audioWaveStatus ==
                            AudioWaveStatus.initialized ||
                        audioWaveController.audioWaveStatus ==
                            AudioWaveStatus.pause) {
                      audioWaveController.play();
                    } else if (audioWaveController.audioWaveStatus ==
                        AudioWaveStatus.play) {
                      audioWaveController.pause();
                    }
                  },
          ),
          AudioWave(
            audioWaveController: audioWaveController,
          ),
        ],
      )),
    );
  }
}
