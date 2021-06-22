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

    _audioWaveController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioWaveController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    (_audioWaveController.audioWaveStatus ==
                                AudioWaveStatus.initialized ||
                            _audioWaveController.audioWaveStatus ==
                                AudioWaveStatus.pause)
                        ? Icons.play_arrow
                        : Icons.pause,
                    size: 25,
                  ),
                  onPressed: () {
                    if (_audioWaveController.audioWaveStatus ==
                            AudioWaveStatus.initialized ||
                        _audioWaveController.audioWaveStatus ==
                            AudioWaveStatus.pause) {
                      _audioWaveController.play();
                    } else {
                      _audioWaveController.pause();
                    }
                  }),
              Expanded(
                child: AudioWave(audioWaveController: _audioWaveController),
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
