import 'package:audio_wave/packages/audio_wave_widget/audio_wave_widget.dart';
import 'package:flutter/material.dart';

class MainAudioWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Wave"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AudioWave(
            bars: [
              100,
              30,
              70,
              40,
              20,
              10,
              30,
              50,
              40,
              60,
              90,
              15,
              100,
              30,
              70,
              40,
              20,
              10,
              30,
              50,
              40,
              60,
              90,
              15,
              10,
              25,
              30,
              40,
              100,
              30,
              70,
              40,
              20,
              10,
              30,
              50,
              40,
              60,
              90,
              15,
              10,
              25,
              30,
              40,
              100,
              30,
              70,
              40,
              20,
              10,
              30,
              50,
              40,
              60,
              90,
              15,
              10,
              25,
              30,
              40,
              15,
              10,
              25,
              30,
              40,
              15,
              10,
              25,
              30,
              40,
            ],
          ),
        ],
      )),
    );
  }
}
