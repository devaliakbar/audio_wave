import 'package:audio_wave/audio_wave/audio_wave_player/audio_wave_player_controller.dart';
import 'package:flutter/material.dart';

class AudioWavePlayerWidget extends StatelessWidget {
  AudioWavePlayerWidget({
    required this.audioWavePlayerController,
    this.height,
    this.activeBarColor = const Color(0xFF81B3C1),
    this.inActiveBarColor = const Color(0xFF6E6E7A),
  });

  final AudioWavePlayerController? audioWavePlayerController;

  ///[height] is the height of the container
  final double? height;

  /// [activeBarColor] is the color of the bar
  final Color activeBarColor;

  /// [inActiveBarColor] is the color of the bar
  final Color inActiveBarColor;

  @override
  Widget build(BuildContext context) {
    double? _containerHeight = height;
    if (_containerHeight == null) {
      final double _blockSizeVertical =
          MediaQuery.of(context).size.height / 100;
      _containerHeight = 3 * _blockSizeVertical;
    }

    final double _blockSizeHorizontal = MediaQuery.of(context).size.width / 100;

    final double _barWidth = 0.3 * _blockSizeHorizontal;

    final double _spacing = 0.3 * _blockSizeHorizontal;

    return StreamBuilder(
      stream: audioWavePlayerController!.barAnimationStream?.stream ?? null,
      builder: (context, snapshot) {
        return Container(
          height: _containerHeight,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            itemCount: audioWavePlayerController!.audioWaves!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext _, int index) {
              bool isPlayed = false;
              if (snapshot.data != null &&
                  (audioWavePlayerController!.audioWaveStatus ==
                          AudioWaveStatus.play ||
                      audioWavePlayerController!.audioWaveStatus ==
                          AudioWaveStatus.pause)) {
                final int indexUntilPlayed = snapshot.data as int;
                if (index <= indexUntilPlayed) {
                  isPlayed = true;
                }
              }

              double bar = audioWavePlayerController!.audioWaves![index] * 100;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: _spacing),
                    height: bar * _containerHeight! / 100,
                    width: _barWidth,
                    decoration: BoxDecoration(
                      color: isPlayed ? activeBarColor : inActiveBarColor,
                      borderRadius: BorderRadius.circular(_barWidth),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
