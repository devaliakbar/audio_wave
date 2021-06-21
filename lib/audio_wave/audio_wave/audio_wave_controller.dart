import 'dart:async';
import 'dart:io';

import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AudioWaveStatus { initializing, initialized, play, pause }

class AudioWaveController {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PUBLIC***************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<double> audioWaves;

  Duration audioDuration;

  AudioWaveStatus audioWaveStatus = AudioWaveStatus.initializing;
  File audioFile;

  StreamController<int> barAnimationStream;

  AudioWaveController({@required AudioWaveModel audioWaveModel}) {
    audioWaves = audioWaveModel.waves;
    audioDuration = audioWaveModel.duration;
    audioFile = audioWaveModel.audio;
    _init();
  }

  //SETTING INTERFACE FOR LISTENING CONTROLLER CHANGES
  void addListener(Function audioWaveStatusChangedCallBack) {
    _listeners.add(audioWaveStatusChangedCallBack);
  }

  //PLAY AUDIO
  void play() {
    if (audioWaveStatus == AudioWaveStatus.initialized) {
      audioWaveStatus = AudioWaveStatus.play;
      _audioPlayer.play(audioFile.path, isLocal: true);
      _notifyChanges();
    } else if (audioWaveStatus == AudioWaveStatus.pause) {
      audioWaveStatus = AudioWaveStatus.play;
      _audioPlayer.resume();
      _notifyChanges();
    }
  }

  //PAUSE AUDIO
  void pause() async {
    if (audioWaveStatus == AudioWaveStatus.play) {
      audioWaveStatus = AudioWaveStatus.pause;
      _audioPlayer.pause();
      _notifyChanges();
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    audioWaves = null;
    audioDuration = null;
    _indexForBarAnimation = 0;
    _triggerDurationForBarAnimation = [];
    audioWaveStatus = AudioWaveStatus.initializing;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PRIVATE**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<Function> _listeners = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _indexForBarAnimation = 0;
  List<int> _triggerDurationForBarAnimation = [];
  //INITIALIZING
  Future<void> _init() async {
    int durationInMiliiSecond = audioDuration.inMilliseconds;
    int durationForMultiply = durationInMiliiSecond ~/ audioWaves.length;

    barAnimationStream = StreamController<int>();

    for (int i = 1; i < audioWaves.length; i++) {
      _triggerDurationForBarAnimation.add(durationForMultiply * i);
    }

    _triggerDurationForBarAnimation.add(audioDuration.inMilliseconds);

    _audioPlayer.onDurationChanged.listen((Duration d) {
      int changedDurationInMilliSecond = d.inMilliseconds;
      if (changedDurationInMilliSecond >=
          _triggerDurationForBarAnimation[_indexForBarAnimation]) {
        barAnimationStream.add(++_indexForBarAnimation);
      }
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      _onStopAudio();
    });

    audioWaveStatus = AudioWaveStatus.initialized;

    _notifyChanges();
  }

  //ON STOP AUDIO
  void _onStopAudio() {
    audioWaveStatus = AudioWaveStatus.initialized;
    _indexForBarAnimation = 0;
    _notifyChanges();
  }

  //NOTIFYING LISTENERS
  void _notifyChanges() {
    for (Function listener in _listeners) listener();
  }
}
