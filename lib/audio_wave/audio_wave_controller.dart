import 'dart:async';

import 'package:audio_visualizer/audio_visualizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

enum AudioWaveStatus { initializing, initialized, play, pause }

class AudioWaveController {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PUBLIC***************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<double> audioWaves;

  Duration audioDuration;

  AudioWaveStatus audioWaveStatus = AudioWaveStatus.initializing;

  AudioWaveController({@required String audioPath}) {
    _init(audioPath);
  }

  //SETTING INTERFACE FOR LISTENING CONTROLLER CHANGES
  void addListener(Function audioWaveStatusChangedCallBack) {
    _listeners.add(audioWaveStatusChangedCallBack);
  }

  //PLAY AUDIO
  void play() {
    if (audioWaveStatus == AudioWaveStatus.initialized ||
        audioWaveStatus == AudioWaveStatus.pause) {
      audioWaveStatus = AudioWaveStatus.play;
      _audioPlayer.play();
      _notifyChanges();
    }
  }

  //PAUSE AUDIO
  void pause() async {
    if (audioWaveStatus == AudioWaveStatus.play) {
      audioWaveStatus = AudioWaveStatus.pause;
      _notifyChanges();
      await _audioPlayer.pause();
    }
  }

  //ON STOP AUDIO
  void onStopAudio() {
    audioWaveStatus = AudioWaveStatus.initialized;
    _audioPlayer.stop();
    _notifyChanges();
  }

  void dispose() {
    _audioPlayer.dispose();
    audioWaves = null;
    audioDuration = null;
    audioWaveStatus = AudioWaveStatus.initializing;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PRIVATE**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<Function> _listeners = [];

  final AudioPlayer _audioPlayer = AudioPlayer();

  //INITIALIZING
  Future<void> _init(String audioPath) async {
    List<int> _audioByte =
        (await rootBundle.load(audioPath)).buffer.asUint8List().toList();

    audioDuration = await _audioPlayer.setAsset(audioPath);

    audioWaves = await compute(_createWaveBar, _audioByte);

    audioWaveStatus = AudioWaveStatus.initialized;
    _notifyChanges();
  }

  //NOTIFYING LISTENERS
  void _notifyChanges() {
    for (Function listener in _listeners) listener();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************STATIC**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
}
