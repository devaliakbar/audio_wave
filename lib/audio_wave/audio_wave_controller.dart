import 'dart:async';

import 'package:audio_visualizer/audio_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioWaveController {
  StreamController<List<double>> audioWaves;
  Function _audioWaveStatusChangedCallBack;

  int _bufferSize = 4096;
  static const int _sampleRate = 44100;

  final String _audioPath;

  List<int> _audioByte;

  Duration _audioDuration;

  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioWaveController({@required String audioPath})
      : this._audioPath = audioPath {
    _init();
  }

  void addCallback(Function audioWaveStatusChangedCallBack) {
    _audioWaveStatusChangedCallBack = audioWaveStatusChangedCallBack;
  }

  Future<void> _init() async {
    _audioByte =
        (await rootBundle.load(_audioPath)).buffer.asUint8List().toList();

    _bufferSize = _audioByte.length ~/ 70;

    _audioDuration = await _audioPlayer.setAsset(_audioPath);
  }

  void play() async {
    int milliSecondForEachBeat = 70;

    _audioPlayer.play();

    final AudioVisualizer visualizer = AudioVisualizer(
      windowSize: _bufferSize,
      bandType: BandType.FourBandVisual,
      sampleRate: _sampleRate,
      zeroHzScale: 0.05,
      fallSpeed: 0.08,
      sensibility: 8.0,
    );

    audioWaves = StreamController<List<double>>();

    if (_audioWaveStatusChangedCallBack != null) {
      _audioWaveStatusChangedCallBack();
    }

    int offset = 0;
    bool isEnd = false;

    final List<double> waveStream = [];
    while (!isEnd) {
      print(isEnd);
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
      audioWaves.add(waveStream);

      await Future.delayed(Duration(milliseconds: milliSecondForEachBeat));

      offset += _bufferSize;
      if (isEnd) {
        await _stop();
        break;
      }
    }
  }

  Future<void> pause() async {}

  Future<void> _stop() async {
    await audioWaves?.close();
    audioWaves = null;
    //   await _player.stop();
  }
}
