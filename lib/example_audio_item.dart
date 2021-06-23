import 'package:audio_wave/audio_wave/audio_wave_player/audio_wave_player_controller.dart';
import 'package:audio_wave/audio_wave/audio_wave_player/audio_wave_player_widget.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:flutter/material.dart';

class ExampleAudioItem extends StatefulWidget {
  final AudioWaveModel audioWaveModel;

  ExampleAudioItem({required this.audioWaveModel});

  @override
  _ExampleAudioItemState createState() => _ExampleAudioItemState();
}

class _ExampleAudioItemState extends State<ExampleAudioItem> {
  late final AudioWavePlayerController _audioWavePlayerController;

  @override
  void initState() {
    super.initState();

    _audioWavePlayerController =
        AudioWavePlayerController(audioWaveModel: widget.audioWaveModel);

    _audioWavePlayerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioWavePlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _audioWavePlayerController.audioWaveStatus ==
                      AudioWaveStatus.initializing
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : IconButton(
                      icon: Icon(
                        (_audioWavePlayerController.audioWaveStatus ==
                                    AudioWaveStatus.initialized ||
                                _audioWavePlayerController.audioWaveStatus ==
                                    AudioWaveStatus.pause)
                            ? Icons.play_arrow
                            : Icons.pause,
                        size: 25,
                      ),
                      onPressed: () {
                        if (_audioWavePlayerController.audioWaveStatus ==
                                AudioWaveStatus.initialized ||
                            _audioWavePlayerController.audioWaveStatus ==
                                AudioWaveStatus.pause) {
                          _audioWavePlayerController.play();
                        } else {
                          _audioWavePlayerController.pause();
                        }
                      }),
              Expanded(
                child: AudioWavePlayerWidget(
                    audioWavePlayerController: _audioWavePlayerController),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _audioWavePlayerController.audioWaveStatus !=
                  AudioWaveStatus.initializing
              ? Text(_audioWavePlayerController.audioDuration.toString())
              : Container()
        ],
      ),
    );
  }
}
