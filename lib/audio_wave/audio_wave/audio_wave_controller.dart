import 'dart:async';

import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum AudioWaveStatus { initializing, initialized, play, pause }

class AudioWaveController {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PUBLIC***************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<double> audioWaves;

  Duration audioDuration;

  AudioWaveStatus audioWaveStatus = AudioWaveStatus.initializing;

  AudioWaveController({@required AudioWaveModel audioWaveModel}) {
    audioWaves = audioWaveModel.waves;
    audioDuration = audioWaveModel.duration;
    _init(audioWaveModel.audio.path);
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
    //   await _audioPlayer.setFilePath(audioPath);
    audioWaveStatus = AudioWaveStatus.initialized;
    _notifyChanges();
  }

  //NOTIFYING LISTENERS
  void _notifyChanges() {
    for (Function listener in _listeners) listener();
  }
}
