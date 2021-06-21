import 'dart:async';
import 'dart:io';

import 'package:audio_wave/audio_wave/audio_wave_recorder/audio_wave_record_controller.dart';
import 'package:audio_wave/audio_wave/audio_wave_recorder/audio_wave_record_widget.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:audio_wave/example_audio_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  AudioWaveRecordController _audioWaveRecordController;

  final List<AudioWaveModel> audios = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _audioWaveRecordController = AudioWaveRecordController(onRecordComplete:
        (File audioFile, List<double> waves, Duration duration) {
      audios.add(
          AudioWaveModel(audio: audioFile, duration: duration, waves: waves));
    });

    _audioWaveRecordController.addCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 200), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: audios.length,
                itemBuilder: (BuildContext _, int index) =>
                    ExampleAudioItem(audioWaveModel: audios[index]),
                separatorBuilder: (BuildContext _, int __) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    height: 0.5,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            Container(
              color: Colors.grey.withOpacity(0.1),
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _audioWaveRecordController.currentStatus ==
                            RecordingStatus.Recording
                        ? AudioWaveRecordWidget(
                            audioWaveRecordController:
                                _audioWaveRecordController,
                          )
                        : Container(),
                  ),
                  GestureDetector(
                    onLongPress: _audioWaveRecordController.currentStatus ==
                            RecordingStatus.Initialized
                        ? () {
                            _audioWaveRecordController.startRecord();
                          }
                        : null,
                    onLongPressEnd: (LongPressEndDetails details) {
                      if (_audioWaveRecordController.currentStatus !=
                          RecordingStatus.Recording) {
                        while (_audioWaveRecordController.currentStatus !=
                            RecordingStatus.Recording) {}
                      }

                      _audioWaveRecordController.stopRecord();
                    },
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: _audioWaveRecordController.currentStatus ==
                                RecordingStatus.Recording
                            ? Colors.red
                            : _audioWaveRecordController.currentStatus ==
                                    RecordingStatus.Initialized
                                ? Colors.blue
                                : Colors.yellow,
                        child: Icon(
                          Icons.mic,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
