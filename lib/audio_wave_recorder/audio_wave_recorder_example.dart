import 'package:audio_wave/audio_wave_recorder/audio_wave_record_controller.dart';
import 'package:audio_wave/audio_wave_recorder/audio_wave_recorder.dart';
import 'package:flutter/material.dart';

class AudioWaveRecorderExample extends StatelessWidget {
  final AudioWaveRecordController _audioWaveRecordController =
      AudioWaveRecordController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio  Wave Recorder"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    _audioWaveRecordController.startRecord();
                  },
                  child: Text("Reccord"),
                ),
                RaisedButton(
                  onPressed: () {
                    _audioWaveRecordController.stopRecord();
                  },
                  child: Text("Stop"),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: AudioWaveRecorder(
                  audioWaveRecordController: _audioWaveRecordController),
            )
          ],
        ),
      ),
    );
  }
}
