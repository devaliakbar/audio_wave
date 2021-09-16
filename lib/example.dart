import 'dart:async';
import 'dart:io';

import 'package:audio_wave/audio_wave/audio_wave_recorder/audio_wave_record_controller.dart';
import 'package:audio_wave/audio_wave/audio_wave_recorder/audio_wave_record_widget.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_recorder_status.dart';
import 'package:audio_wave/example_audio_item.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  AudioWaveRecordController? _audioWaveRecordController;

  final List<AudioWaveModel> audios = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _audioWaveRecordController = AudioWaveRecordController(
        onRecordComplete: (File audioFile, List<double> waves) {
      audios.add(AudioWaveModel(audio: SAMPLE_AUDIO, waves: SAMPLE_WAVES));
    });

    _audioWaveRecordController!.addCallback(() {
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
                    child: _audioWaveRecordController!.currentStatus ==
                            AudioWaveRecorderStatus.Recording
                        ? AudioWaveRecordWidget(
                            audioWaveRecordController:
                                _audioWaveRecordController,
                          )
                        : Container(),
                  ),
                  GestureDetector(
                    onLongPress: _audioWaveRecordController!.currentStatus ==
                            AudioWaveRecorderStatus.Initialized
                        ? () {
                            _audioWaveRecordController!.startRecord();
                          }
                        : null,
                    onLongPressEnd: (LongPressEndDetails details) {
                      if (_audioWaveRecordController!.currentStatus !=
                          AudioWaveRecorderStatus.Recording) {
                        while (_audioWaveRecordController!.currentStatus !=
                            AudioWaveRecorderStatus.Recording) {}
                      }

                      _audioWaveRecordController!.stopRecord();
                    },
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: _audioWaveRecordController!.currentStatus ==
                                AudioWaveRecorderStatus.Recording
                            ? Colors.red
                            : _audioWaveRecordController!.currentStatus ==
                                    AudioWaveRecorderStatus.Initialized
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

const String SAMPLE_AUDIO =
    "https://development-kyubook-assets.s3.amazonaws.com/d/CREATIVE/ModuleItemId//data/user/0/com-1263.mp3";

const List<double> SAMPLE_WAVES = [
  0.5402920208715042,
  0.9706980585800253,
  0.8683058451769397,
  0.6311804427751794,
  0.20660947912793598,
  0.1,
  0.2,
  0.3,
  0.4,
  0.6,
  0.7,
  0.5,
  0.4,
  0.9074062290631162,
  1.0,
  1.0,
  0.6809406061775511,
  0.9959362271177604,
  0.9619952159967673,
  1.0,
  1.0,
  1.0,
  0.2556983062624768,
  0.23303018469226558,
  1.0,
  1.0,
  1.0,
  0.4546130510832763,
  0.6105982105461738,
  0.36941748791214,
  0.22328043447437923,
  0.5402920208715042,
  0.9706980585800253,
  0.8683058451769397,
  0.6311804427751794,
  0.20660947912793598,
  0.1,
  0.2,
  0.3,
  0.4,
  0.6,
  0.7,
  0.5,
  0.4,
  0.9726311507704365,
  1.0,
  0.9361918133903623,
  0.891712670119881,
  0.1,
  1.0,
  0.27902611567221686,
  0.15475663527611275,
  1.0,
  0.5729005933362881,
  0.1,
  0.9073141056169753,
  0.951286771612863,
  0.989630416950538,
  0.7141122823292578,
  0.7141122823292578,
  0.18076569391397562,
  0.1,
  0.5402920208715042,
  0.9706980585800253,
  0.8683058451769397,
  0.6311804427751794,
  0.20660947912793598,
  0.5402920208715042,
  0.9706980585800253,
  0.8683058451769397,
  0.6311804427751794,
  0.20660947912793598,
  0.1,
  0.2,
  0.3,
  0.4,
  0.6,
  0.7,
  0.5,
  0.4,
  0.7412664845915073,
  1.0,
  1.0,
  1.0,
  0.5358755373238964,
  0.4014128464984016,
  0.1,
  0.6863776481975792,
  1.0,
  0.733309319883845,
  0.6575150697563455,
  0.5402920208715042,
  0.9706980585800253,
  0.8683058451769397,
  0.6311804427751794,
  0.20660947912793598,
  0.1,
  0.2,
  0.3,
  0.4,
  0.6,
  0.7,
  0.5,
  0.4
];
