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
    _setUpBarAnimation();
  }

  //PAUSE AUDIO
  void pause() async {
    if (audioWaveStatus == AudioWaveStatus.play) {
      audioWaveStatus = AudioWaveStatus.pause;
      _audioPlayer.pause();
      _notifyChanges();
    }
    _timerForBarAnimation.cancel();
  }

  void dispose() async {
    _audioPlayer.dispose();
    audioWaves = null;
    audioDuration = null;
    _timerForBarAnimation?.cancel();
    _timerForBarAnimation = null;
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

  Timer _timerForBarAnimation;

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
    _timerForBarAnimation.cancel();
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

    _timerForBarAnimation = Timer.periodic(
        Duration(milliseconds: durationForMultiply),
        (Timer t) => barAnimationStream.add(++_indexForBarAnimation));
  }
}
