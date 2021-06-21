import 'dart:io';

import 'package:flutter/material.dart';

class AudioWaveModel {
  final File audio;
  final Duration duration;
  final List<double> waves;

  AudioWaveModel(
      {@required this.audio, @required this.duration, @required this.waves});
}
