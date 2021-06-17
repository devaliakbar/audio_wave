import 'package:audio_wave/audio_wave/audio_wave_controller.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatelessWidget {
  AudioWave({
    @required this.audioWaveController,
    this.height,
    this.inActiveColor = const Color(0xFF6E6E7A),
    this.activeColor = const Color(0xFF81B3C1),
  });

  final AudioWaveController audioWaveController;

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
      child: Stack(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: audioWaveController.bars.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext _, int index) {
              final double bar = audioWaveController.bars[index];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: _spacing),
                    height: bar * _containerHeight / 100,
                    width: _barWidth,
                    decoration: BoxDecoration(
                      color: inActiveColor,
                      borderRadius: BorderRadius.circular(_barWidth),
                    ),
                  )
                ],
              );
            },
          ),
          _AnimatedBar(
              audioWaveController: audioWaveController,
              spacing: _spacing,
              containerHeight: _containerHeight,
              barWidth: _barWidth,
              activeColor: activeColor)
        ],
      ),
    );
  }
}

class _AnimatedBar extends StatefulWidget {
  final AudioWaveController audioWaveController;
  final double spacing;
  final double containerHeight;
  final double barWidth;
  final Color activeColor;

  _AnimatedBar(
      {@required this.audioWaveController,
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

    widget.audioWaveController.addCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioWaveController.animatedBars == null
        ? Container()
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: widget.audioWaveController.animatedBars.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext _, int index) {
              final double bar = widget.audioWaveController.animatedBars[index];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: widget.spacing),
                    height: bar * widget.containerHeight / 100,
                    width: widget.barWidth,
                    decoration: BoxDecoration(
                      color: widget.activeColor,
                      borderRadius: BorderRadius.circular(widget.barWidth),
                    ),
                  )
                ],
              );
            },
          );
  }
}
