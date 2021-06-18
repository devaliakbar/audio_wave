import 'dart:async';

import 'package:audio_visualizer/audio_visualizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioWaveController {
  List<double> audioWaves;
  Function _audioWaveStatusChangedCallBack;

  final String _audioPath;

  List<int> _audioByte;

  Duration _audioDuration;

  final AudioPlayer _audioPlayer = AudioPlayer();

  int currentPlayedBarIndex;

  AudioWaveController({@required String audioPath})
      : this._audioPath = audioPath {
    _init();
  }

  //SETTING INTERFACE FOR LISTENING CONTROLLER CHANGES
  void addCallback(Function audioWaveStatusChangedCallBack) {
    _audioWaveStatusChangedCallBack = audioWaveStatusChangedCallBack;
  }

  //INITIALIZING
  Future<void> _init() async {
    _audioByte =
        (await rootBundle.load(_audioPath)).buffer.asUint8List().toList();

    _audioDuration = await _audioPlayer.setAsset(_audioPath);

    audioWaves = await compute(_createWaveBar, _audioByte);

    if (_audioWaveStatusChangedCallBack != null) {
      _audioWaveStatusChangedCallBack();
    }
  }

  //CREATE WAVEBAR FROM AUDIO
  static List<double> _createWaveBar(List<int> _audioByte) {
    final int _bufferSize = _audioByte.length ~/ 100;

    final AudioVisualizer visualizer = AudioVisualizer(
      windowSize: _bufferSize,
      bandType: BandType.FourBandVisual,
      zeroHzScale: 0.05,
      fallSpeed: 0.08,
      sensibility: 8.0,
    );

    int offset = 0;
    bool isEnd = false;

    final List<double> waveStream = [];

    while (!isEnd) {
      var end = offset + _bufferSize;
      if (end >= _audioByte.length) {
        isEnd = true;
        end = _audioByte.length;
      }
      final block = _audioByte.sublist(offset, end);

      final List<double> transformValue = visualizer.transform(block);
      double averageOfTransformValue =
          transformValue.reduce((value, element) => value + element) /
              transformValue.length;

      waveStream.add(averageOfTransformValue);

      offset += _bufferSize;
    }

    return waveStream;
  }

  //PLAY AUDIO
  void play() {
    _audioPlayer.play();
    currentPlayedBarIndex = 0;

    int millisecondsOfBeat = _audioDuration.inMilliseconds ~/ audioWaves.length;

    Timer.periodic(Duration(milliseconds: millisecondsOfBeat), (timer) {
      currentPlayedBarIndex++;

      if (_audioWaveStatusChangedCallBack != null) {
        _audioWaveStatusChangedCallBack();
      }

      if (currentPlayedBarIndex == audioWaves.length) {
        timer.cancel();
      }
    });
  }

  //PAUSE AUDIO
  Future<void> pause() async {}
}
