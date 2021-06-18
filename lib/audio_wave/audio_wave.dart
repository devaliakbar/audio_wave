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
    _containerHeight = 300;

    final double _blockSizeHorizontal = MediaQuery.of(context).size.width / 100;

    final double _barWidth = 0.3 * _blockSizeHorizontal;

    final double _spacing = 0.3 * _blockSizeHorizontal;

    return Container(
      height: _containerHeight,
      width: 54 * _blockSizeHorizontal,
      child: _AnimatedBar(
        audioWaveController: audioWaveController,
        spacing: _spacing,
        containerHeight: _containerHeight,
        barWidth: _barWidth,
        activeColor: activeColor,
        inActiveColor: inActiveColor,
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
  final Color inActiveColor;

  _AnimatedBar(
      {@required this.audioWaveController,
      @required this.spacing,
      @required this.containerHeight,
      @required this.barWidth,
      @required this.activeColor,
      @required this.inActiveColor});

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
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: widget.audioWaveController.bars.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext _, int index) {
        final double bar = widget.audioWaveController.bars[index];
        int currentActiveBarsCount = 0;
        if (widget.audioWaveController.animatedBars != null) {
          currentActiveBarsCount =
              widget.audioWaveController.animatedBars.length;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: widget.spacing),
              height: bar * widget.containerHeight / 100,
              width: widget.barWidth,
              decoration: BoxDecoration(
                color: index < currentActiveBarsCount
                    ? widget.activeColor
                    : widget.inActiveColor,
                borderRadius: BorderRadius.circular(widget.barWidth),
              ),
            )
          ],
        );
      },
    );
  }
}
