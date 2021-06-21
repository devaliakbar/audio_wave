import 'dart:io';

import 'package:audio_wave/audio_wave_recorder/audio_wave_record_controller.dart';
import 'package:audio_wave/audio_wave_recorder/audio_wave_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

class AudioWaveRecorderExample extends StatefulWidget {
  @override
  _AudioWaveRecorderExampleState createState() =>
      _AudioWaveRecorderExampleState();
}

class _AudioWaveRecorderExampleState extends State<AudioWaveRecorderExample> {
  AudioWaveRecordController _audioWaveRecordController;

  @override
  void initState() {
    super.initState();

    _audioWaveRecordController = AudioWaveRecordController(onRecordComplete:
        (File audioFile, List<double> waves, Duration duration) {
      print("Complete");
      print(waves);
    });

    _audioWaveRecordController.addCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showRecordButton = _audioWaveRecordController.currentStatus ==
            RecordingStatus.Initialized ||
        _audioWaveRecordController.currentStatus == RecordingStatus.Recording;

    return Scaffold(
      appBar: AppBar(
        title: Text("Audio  Wave Recorder"),
      ),
      body: SafeArea(
        child: showRecordButton
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      if (_audioWaveRecordController.currentStatus ==
                          RecordingStatus.Initialized) {
                        _audioWaveRecordController.startRecord();
                      } else if (_audioWaveRecordController.currentStatus ==
                          RecordingStatus.Recording) {
                        _audioWaveRecordController.stopRecord();
                      }
                    },
                    child: Text(_audioWaveRecordController.currentStatus ==
                            RecordingStatus.Initialized
                        ? "Record"
                        : "Stop"),
                  ),
                  _audioWaveRecordController.currentStatus ==
                          RecordingStatus.Recording
                      ? Padding(
                          padding: EdgeInsets.all(15),
                          child: AudioWaveRecordWidget(
                              audioWaveRecordController:
                                  _audioWaveRecordController),
                        )
                      : Container()
                ],
              )
            : Center(
                child:
                    Text(_audioWaveRecordController.errorMsg ?? "Loading..."),
              ),
      ),
    );
  }
}
