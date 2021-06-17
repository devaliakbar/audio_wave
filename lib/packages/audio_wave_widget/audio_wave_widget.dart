import 'dart:async';

import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  AudioWave(
      {@required this.bars,
      this.height,
      this.inActiveColor = const Color(0xFF6E6E7A),
      this.activeColor = const Color(0xFF81B3C1),
      this.animationDuration = const Duration(seconds: 1)});

  ///The [bars] value should be between 10 to 100
  final List<double> bars;

  ///[height] is the height of the container
  final double height;

  /// [inActiveColor] is the color of the inActive bar
  final Color inActiveColor;

  /// [activeColor] is the color of the active bar
  final Color activeColor;

  /// [animationDuration] total duration of animation.
  final Duration animationDuration;
  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  int countBeat = 0;

  List<double> animatedBars;
  @override
  void initState() {
    super.initState();

    animatedBars = [];
    WidgetsBinding.instance.addPostFrameCallback((x) {
      int beatRate = widget.animationDuration.inMilliseconds;
      beatRate = beatRate ~/ widget.bars.length;

      Timer.periodic(Duration(milliseconds: beatRate), (timer) {
        int mo = countBeat % widget.bars.length;

        animatedBars = List.from(widget.bars.getRange(0, mo + 1));
        if (mounted) setState(() {});
        countBeat++;

        if (countBeat == widget.bars.length) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _containerHeight = widget.height;
    if (_containerHeight == null) {
      final double _blockSizeVertical =
          MediaQuery.of(context).size.height / 100;
      _containerHeight = 3 * _blockSizeVertical;
    }

    final double _blockSizeHorizontal = MediaQuery.of(context).size.width / 100;

    final double _barWidth = 0.3 * _blockSizeHorizontal;

    final double _spacing = 0.3 * _blockSizeHorizontal;

    return Container(
      height: _containerHeight,
      child: Stack(
        children: [
          Row(
            children: [
              for (final bar in widget.bars)
                Container(
                  margin: EdgeInsets.only(right: _spacing),
                  height: bar * _containerHeight / 100,
                  width: _barWidth,
                  decoration: BoxDecoration(
                    color: widget.inActiveColor,
                    borderRadius: BorderRadius.circular(_barWidth),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              for (final bar in animatedBars)
                Container(
                  margin: EdgeInsets.only(right: _spacing),
                  height: bar * _containerHeight / 100,
                  width: _barWidth,
                  decoration: BoxDecoration(
                    color: widget.activeColor,
                    borderRadius: BorderRadius.circular(_barWidth),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
