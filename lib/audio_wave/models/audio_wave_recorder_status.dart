import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

enum AudioWaveRecorderStatus {
  Unset,

  Initialized,

  Recording,

  Paused,

  Stopped,
}

AudioWaveRecorderStatus mapToStatus(RecordingStatus? status) {
  switch (status) {
    case RecordingStatus.Initialized:
      return AudioWaveRecorderStatus.Initialized;
    case RecordingStatus.Recording:
      return AudioWaveRecorderStatus.Recording;
    case RecordingStatus.Paused:
      return AudioWaveRecorderStatus.Paused;
    case RecordingStatus.Stopped:
      return AudioWaveRecorderStatus.Stopped;
    default:
      return AudioWaveRecorderStatus.Unset;
  }
}
