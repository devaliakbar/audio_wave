import 'dart:async';

import 'package:audio_wave/audio_wave/models/audio_wave_model.dart';
import 'package:just_audio/just_audio.dart';

enum AudioWaveStatus { initializing, initialized, play, pause }

class AudioWavePlayerController {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PUBLIC***************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  late final List<double>? audioWaves;

  late final Duration audioDuration;

  late final String audioUrl;

  AudioWaveStatus audioWaveStatus = AudioWaveStatus.initializing;

  StreamController<int>? barAnimationStream;

  AudioWavePlayerController({required AudioWaveModel audioWaveModel}) {
    audioWaves = audioWaveModel.waves;
    audioUrl = audioWaveModel.audio;
    _init();
  }

  //SETTING INTERFACE FOR LISTENING CONTROLLER CHANGES
  void addListener(Function audioWaveStatusChangedCallBack) {
    _listeners.add(audioWaveStatusChangedCallBack);
  }

  //PLAY AUDIO
  void play() {
    if (audioWaveStatus == AudioWaveStatus.initialized ||
        audioWaveStatus == AudioWaveStatus.pause) {
      audioWaveStatus = AudioWaveStatus.play;
      _notifyChanges();
      _audioPlayer.play();
    }
  }

  //PAUSE AUDIO
  void pause() async {
    if (audioWaveStatus == AudioWaveStatus.play) {
      audioWaveStatus = AudioWaveStatus.initializing;
      await _audioPlayer.pause();
      audioWaveStatus = AudioWaveStatus.pause;
      _notifyChanges();
    }
  }

  void dispose() async {
    try {
      audioWaveStatus = AudioWaveStatus.initializing;
      barAnimationStream = null;
      barAnimationStream?.close();
      _audioPlayer.dispose();
    } catch (_) {}
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PRIVATE**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<Function> _listeners = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  //INITIALIZING
  Future<void> _init() async {
    Duration? duration = await _audioPlayer.setUrl(audioUrl);

    audioDuration = duration!;

    barAnimationStream = StreamController<int>();

    _audioPlayer.positionStream.listen((event) {
      int currentDurationInMilliSeconds = event.inMilliseconds;

      int percentage =
          ((currentDurationInMilliSeconds / audioDuration.inMilliseconds) *
                  audioWaves!.length)
              .truncate();

      barAnimationStream!.add(percentage);
    });

    _audioPlayer.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        audioWaveStatus = AudioWaveStatus.initializing;

        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.stop();

        audioWaveStatus = AudioWaveStatus.initialized;

        _notifyChanges();
      }
    });

    audioWaveStatus = AudioWaveStatus.initialized;

    _notifyChanges();
  }

  //NOTIFYING LISTENERS
  void _notifyChanges() {
    for (Function listener in _listeners) listener();
  }
}
