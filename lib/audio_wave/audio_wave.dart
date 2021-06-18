import 'package:audio_wave/audio_wave/audio_wave_controller.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  AudioWave({
    @required this.audioWaveController,
    this.height,
    this.barColor = const Color(0xFF81B3C1),
  });

  final AudioWaveController audioWaveController;

  ///[height] is the height of the container
  final double height;

  /// [barColor] is the color of the bar
  final Color barColor;

  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  @override
  void initState() {
    super.initState();

    widget.audioWaveController.addCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioWaveController.audioWaves == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    double _containerHeight = widget.height;
    if (_containerHeight == null) {
      final double _blockSizeVertical =
          MediaQuery.of(context).size.height / 100;
      _containerHeight = 3 * _blockSizeVertical;
    }

    final double _blockSizeHorizontal = MediaQuery.of(context).size.width / 100;

    final double _barWidth = 0.3 * _blockSizeHorizontal;

    final double _spacing = 0.3 * _blockSizeHorizontal;

    final int _currentPlayedBarIndex =
        widget.audioWaveController.currentPlayedBarIndex ?? 0;

    return Container(
      height: _containerHeight,
      width: 54 * _blockSizeHorizontal,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemCount: widget.audioWaveController.audioWaves.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext _, int index) {
          double bar = widget.audioWaveController.audioWaves[index];
          bar = bar * 100;
          bar = bar < 10 ? 10 : bar;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: _spacing),
                height: bar * _containerHeight / 100,
                width: _barWidth,
                decoration: BoxDecoration(
                  color: index <= _currentPlayedBarIndex
                      ? widget.barColor
                      : Colors.black,
                  borderRadius: BorderRadius.circular(_barWidth),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
