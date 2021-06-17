import 'package:audio_wave/audio_wave_recorder/audio_wave_record_controller.dart';
import 'package:flutter/material.dart';

class AudioWaveRecorder extends StatelessWidget {
  AudioWaveRecorder({
    @required this.audioWaveRecordController,
    this.height,
    this.inActiveColor = const Color(0xFF6E6E7A),
    this.activeColor = const Color(0xFF81B3C1),
  });

  final AudioWaveRecordController audioWaveRecordController;

  ///[height] is the height of the container
  final double height;

  /// [inActiveColor] is the color of the inActive bar
  final Color inActiveColor;

  /// [activeColor] is the color of the active bar
  final Color activeColor;

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

    return Container(
      height: _containerHeight,
      width: 54 * _blockSizeHorizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Align(
          alignment: Alignment.centerLeft,
          child: _AnimatedBar(
              audioWaveRecordController: audioWaveRecordController,
              spacing: _spacing,
              containerHeight: _containerHeight,
              barWidth: _barWidth,
              activeColor: activeColor),
        ),
      ),
    );
  }
}

class _AnimatedBar extends StatefulWidget {
  final AudioWaveRecordController audioWaveRecordController;
  final double spacing;
  final double containerHeight;
  final double barWidth;
  final Color activeColor;

  _AnimatedBar(
      {@required this.audioWaveRecordController,
      @required this.spacing,
      @required this.containerHeight,
      @required this.barWidth,
      @required this.activeColor});

  @override
  _AnimatedBarState createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar> {
  @override
  void initState() {
    super.initState();

    widget.audioWaveRecordController.addCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioWaveRecordController.animatedBars == null
        ? Container()
        : Row(
            children: [
              for (final bar in widget.audioWaveRecordController.animatedBars)
                Container(
                  margin: EdgeInsets.only(right: widget.spacing),
                  height: bar * widget.containerHeight / 100,
                  width: widget.barWidth,
                  decoration: BoxDecoration(
                    color: widget.activeColor,
                    borderRadius: BorderRadius.circular(widget.barWidth),
                  ),
                ),
            ],
          );
  }
}
