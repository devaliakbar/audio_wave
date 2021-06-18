import 'package:audio_wave/pausable_timer/pausable_timer.dart';
import 'package:flutter/material.dart';

class AudioWaveController {
  final List<double> bars;

  List<double> animatedBars;

  Function _animatedBarsCallback;

  int _countBeat = 0;

  PausableTimer _pausableTimer;

  AudioWaveController(
      {@required this.bars,
      Duration animationDuration = const Duration(seconds: 1)}) {
    int _beatRateInMillisecond =
        animationDuration.inMilliseconds ~/ bars.length;

    _pausableTimer =
        PausableTimer(Duration(milliseconds: _beatRateInMillisecond), () {
      int mo = _countBeat % bars.length;

      animatedBars = List.from(bars.getRange(0, mo + 1));

      if (_animatedBarsCallback != null) {
        _animatedBarsCallback();
      }

      _countBeat++;
      if (_countBeat != bars.length) {
        _pausableTimer.reset();
        _pausableTimer.start();
      } else {
        _countBeat = 0;
      }
    });
  }

  void play() {
    if (_pausableTimer.isExpired) {
      animatedBars = [];
      _pausableTimer.reset();
    }

    _pausableTimer.start();
  }

  void pause() {
    _pausableTimer.pause();
  }

  void addCallback(Function animatedBarsCallback) {
    _animatedBarsCallback = animatedBarsCallback;
  }
}
