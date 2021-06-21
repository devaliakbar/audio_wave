import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:flutter/material.dart';

class ExampleAudioItem extends StatelessWidget {
  final AudioWaveModel audioWaveModel;

  ExampleAudioItem({@required this.audioWaveModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_arrow,
                size: 25,
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(audioWaveModel.duration.toString())
        ],
      ),
    );
  }
}
