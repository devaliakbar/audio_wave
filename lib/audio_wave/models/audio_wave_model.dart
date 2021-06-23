import 'dart:io';

class AudioWaveModel {
  final File audio;
  final List<double> waves;

  AudioWaveModel({required this.audio, required this.waves});
}
