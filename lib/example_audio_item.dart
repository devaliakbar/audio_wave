import 'package:audio_wave/audio_wave/audio_wave/audio_wave.dart';
import 'package:audio_wave/audio_wave/audio_wave/audio_wave_controller.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:flutter/material.dart';

class ExampleAudioItem extends StatefulWidget {
  final AudioWaveModel audioWaveModel;

  ExampleAudioItem({@required this.audioWaveModel});

  @override
  _ExampleAudioItemState createState() => _ExampleAudioItemState();
}

class _ExampleAudioItemState extends State<ExampleAudioItem> {
  AudioWaveController _audioWaveController;

  @override
  void initState() {
    super.initState();

    _audioWaveController =
        AudioWaveController(audioWaveModel: widget.audioWaveModel);

    _audioWaveController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _audioWaveController.audioWaveStatus ==
                          AudioWaveStatus.initialized ||
                      _audioWaveController.audioWaveStatus ==
                          AudioWaveStatus.play
                  ? IconButton(
                      icon: Icon(
                        _audioWaveController.audioWaveStatus ==
                                AudioWaveStatus.initialized
                            ? Icons.play_arrow
                            : Icons.pause,
                        size: 25,
                      ),
                      onPressed: () {
                        if (_audioWaveController.audioWaveStatus ==
                            AudioWaveStatus.initialized) {
                          _audioWaveController.play();
                        }

                        if (_audioWaveController.audioWaveStatus ==
                            AudioWaveStatus.play) {
                          _audioWaveController.pause();
                        }
                      })
                  : Container(),
              Expanded(
                child: _audioWaveController.audioWaveStatus ==
                        AudioWaveStatus.initialized
                    ? AudioWave(audioWaveController: _audioWaveController)
                    : Container(),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(widget.audioWaveModel.duration.toString())
        ],
      ),
    );
  }
}
