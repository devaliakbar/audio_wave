import 'dart:async';

import 'package:audio_wave/audio_wave/audio_wave_recorder/audio_wave_generator.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_generate_model.dart';
import 'package:audio_wave/audio_wave/models/audio_wave_recorder_status.dart';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

typedef OnRecordComplete(io.File audioFile, List<double> waves);

class AudioWaveRecordController {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PUBLIC***************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  final OnRecordComplete onRecordComplete;
  AudioWaveRecorderStatus currentStatus = mapToStatus(RecordingStatus.Unset);

  String? errorMsg;

  StreamController<AudioWaveGenerateModel>? recordStream;

  AudioWaveRecordController({required this.onRecordComplete}) {
    _init();
  }

  void startRecord() async {
    if (currentStatus != mapToStatus(RecordingStatus.Initialized)) {
      return;
    }

    recordStream = StreamController<AudioWaveGenerateModel>();
    _audioWaveGenerator =
        AudioWaveGenerator(onGenerateWave: (List<double> waves) {
      recordStream!.add(
          AudioWaveGenerateModel(waves: waves, duration: _current!.duration));
    });

    await _recorder.start();

    _current = await _recorder.current();
    currentStatus = mapToStatus(_current!.status);

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (currentStatus != mapToStatus(RecordingStatus.Recording)) {
        t.cancel();
      } else {
        _current = await _recorder.current();
        currentStatus = mapToStatus(_current!.status);
        _addToWaves(_current!.metering!.averagePower);
      }
    });

    _notifyChange();
  }

  void stopRecord() async {
    if (currentStatus != mapToStatus(RecordingStatus.Recording)) {
      return;
    }

    _current = await _recorder.stop();
    currentStatus = mapToStatus(_current!.status);

    await recordStream?.close();
    recordStream = null;

    final List<double>? waves = _audioWaveGenerator!.getFinalWave();
    _audioWaveGenerator = null;

    if (waves == null) {
      try {
        await _localFileSystem.file(_current!.path).delete();
      } catch (_) {}

      _init();
      return;
    }

    io.File file = _localFileSystem.file(_current!.path);

    onRecordComplete(file, waves);

    _init();
  }

  void addCallback(Function callBack) {
    _statusChangeCallBack.add(callBack);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PRIVATE**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  late FlutterAudioRecorder _recorder;

  Recording? _current;

  AudioWaveGenerator? _audioWaveGenerator;

  final LocalFileSystem _localFileSystem = LocalFileSystem();

  final List<Function> _statusChangeCallBack = [];

  void _init() async {
    errorMsg = null;

    bool? hasPermission = await FlutterAudioRecorder.hasPermissions;

    if (hasPermission == true) {
      String customPath = '/temp_voices';
      io.Directory? appDocDirectory;
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }

      customPath = appDocDirectory!.path +
          customPath +
          DateTime.now().millisecondsSinceEpoch.toString();

      _recorder =
          FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

      await _recorder.initialized;
      Recording? current = await _recorder.current();

      _current = current;
      currentStatus = mapToStatus(current!.status);
    } else {
      errorMsg = "You must accept permissions";
    }

    _notifyChange();
  }

  void _addToWaves(double? wave) {
    if (_audioWaveGenerator != null) {
      if (recordStream != null) {
        if (!recordStream!.isClosed) {
          _audioWaveGenerator!.addToStream(wave!);
        }
      }
    }
  }

  void _notifyChange() {
    for (Function callBack in _statusChangeCallBack) {
      callBack();
    }
  }
}
