import 'package:audio_wave/audio_wave/audio_wave_example.dart';
import 'package:audio_wave/audio_wave_recorder/audio_wave_recorder_example.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Wave"),
      ),
      body: SafeArea(
          child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AudioWaveRecorderExample()),
                );
              },
              child: Text("Record"),
            ),
            SizedBox(
              width: 30,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AudioWaveExample()),
                );
              },
              child: Text("Play"),
            ),
          ],
        ),
      )),
    );
  }
}
