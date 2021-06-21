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
  void play() async {
    if (audioWaveStatus == AudioWaveStatus.initialized) {
      audioWaveStatus = AudioWaveStatus.play;
      await _audioPlayer.play(audioFile.path, isLocal: true);
      _setUpBarAnimation();
      _notifyChanges();
    } else if (audioWaveStatus == AudioWaveStatus.pause) {
      audioWaveStatus = AudioWaveStatus.play;
      await _audioPlayer.resume();
      _setUpBarAnimation();
      _notifyChanges();
    }
  }

  //PAUSE AUDIO
  void pause() async {
    if (audioWaveStatus == AudioWaveStatus.play) {
      audioWaveStatus = AudioWaveStatus.pause;
      await _audioPlayer.pause();
      _notifyChanges();
    }
  }

  void dispose() async {
    _audioPlayer.dispose();
    audioWaves = null;
    audioDuration = null;

    _indexForBarAnimation = 0;
    audioWaveStatus = AudioWaveStatus.initializing;
    await barAnimationStream?.close();
    barAnimationStream = null;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PRIVATE**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<Function> _listeners = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _indexForBarAnimation = 0;

  //INITIALIZING
  Future<void> _init() async {
    barAnimationStream = StreamController<int>();

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

  //SETUP BAR ANIMATION
  void _setUpBarAnimation() {
    int durationInMiliiSecond = audioDuration.inMilliseconds;
    int durationForMultiply = durationInMiliiSecond ~/ audioWaves.length;

    Timer.periodic(Duration(milliseconds: durationForMultiply), (Timer t) {
      if (audioWaveStatus == AudioWaveStatus.play) {
        barAnimationStream.add(++_indexForBarAnimation);
      } else {
        t.cancel();
      }
    });
  }
}
