import 'package:audio_wave/audio_wave/audio_wave_controller.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatelessWidget {
  AudioWave({
    @required this.audioWaveController,
    this.height,
    this.activeBarColor = const Color(0xFF81B3C1),
    this.inActiveBarColor = Colors.black54,
  });

  final AudioWaveController audioWaveController;

  ///[height] is the height of the container
  final double height;

  /// [activeBarColor] is the color of the bar
  final Color activeBarColor;

  /// [inActiveBarColor] is the color of the bar
  final Color inActiveBarColor;

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
      child: _AnimatedBar(
          audioWaveController: audioWaveController,
          activeBarColor: activeBarColor,
          inActiveBarColor: inActiveBarColor,
          containerHeight: _containerHeight,
          barWidth: _barWidth,
          spacing: _spacing),
    );
  }
}

class _AnimatedBar extends StatefulWidget {
  final AudioWaveController audioWaveController;
  final Color activeBarColor;
  final Color inActiveBarColor;

  final double containerHeight, barWidth, spacing;

  _AnimatedBar(
      {@required this.audioWaveController,
      @required this.activeBarColor,
      @required this.inActiveBarColor,
      @required this.containerHeight,
      @required this.barWidth,
      @required this.spacing});

  @override
  _AnimatedBarState createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<int> _barAnimation;

  int currentSelectedBarIndex = 0;

  @override
  void initState() {
    super.initState();

    _setUpBarAnimation();
  }

  void _setUpBarAnimation() {
    widget.audioWaveController.addListener(() {
      AudioWaveStatus audioWaveStatus =
          widget.audioWaveController.audioWaveStatus;

      if (audioWaveStatus == AudioWaveStatus.initialized) {
        _initializeAnimationController();
        setState(() {});
      } else if (audioWaveStatus == AudioWaveStatus.play) {
        _animationController.forward();
      } else if (audioWaveStatus == AudioWaveStatus.pause) {
        _animationController.stop();
        _animationController.reset();
        _initializeAnimationController();
      }
    });
  }

  void _initializeAnimationController() {
    if (_animationController == null) {
      _animationController = AnimationController(
        duration: widget.audioWaveController.audioDuration,
        vsync: this,
      );

      _animationController.addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          currentSelectedBarIndex = 0;
          _initializeAnimationController();
          widget.audioWaveController.onStopAudio();
        }
      });
    }

    _barAnimation = IntTween(
            begin: currentSelectedBarIndex,
            end: widget.audioWaveController.audioWaves.length)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.audioWaveController.audioWaves == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        currentSelectedBarIndex = _barAnimation.value;

        return ListView.builder(
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
                  margin: EdgeInsets.only(right: widget.spacing),
                  height: bar * widget.containerHeight / 100,
                  width: widget.barWidth,
                  decoration: BoxDecoration(
                    color: index <= _barAnimation.value
                        ? widget.activeBarColor
                        : widget.inActiveBarColor,
                    borderRadius: BorderRadius.circular(widget.barWidth),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
