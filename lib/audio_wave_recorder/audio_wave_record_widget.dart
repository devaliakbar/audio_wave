import 'dart:async';

import 'package:audio_wave/audio_wave_recorder/audio_wave_record_controller.dart';
import 'package:audio_wave/models/audio_wave_generate_model.dart';
import 'package:flutter/material.dart';

class AudioWaveRecordWidget extends StatelessWidget {
  final AudioWaveRecordController audioWaveRecordController;

  ///[height] is the height of the container
  final double height;

  /// [activeColor] is the color of the active bar
  final Color activeColor;

  final ScrollController _scrollController = ScrollController();

  AudioWaveRecordWidget({
    @required this.audioWaveRecordController,
    this.height,
    this.activeColor = const Color(0xFF81B3C1),
  });

  @override
  Widget build(BuildContext context) {
    double _containerHeight = height;
    if (_containerHeight == null) {
      final double _blockSizeVertical =
          MediaQuery.of(context).size.height / 100;
      _containerHeight = 3 * _blockSizeVertical;
    }

    final double _blockSizeHorizontal = MediaQuery.of(context).size.width / 100;

    final double _barWidth = 0.3 * _blockSizeHorizontal;

    final double _spacing = 0.3 * _blockSizeHorizontal;

    return StreamBuilder(
      stream: audioWaveRecordController.recordStream?.stream ?? null,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Container();

        AudioWaveGenerateModel audioWaveGenerate = snapshot.data;

        final List<double> buffer = audioWaveGenerate.waves;

        Timer(Duration(milliseconds: 25), () {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 25),
              curve: Curves.linear);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: _containerHeight,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: buffer.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext _, int index) {
                  final double bar = buffer[index] * 100;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: _spacing),
                        height: bar * _containerHeight / 100,
                        width: _barWidth,
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.circular(_barWidth),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Text("${audioWaveGenerate.duration.inSeconds}")
          ],
        );
      },
    );
  }
}
