import 'dart:async';

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

typedef OnRecordComplete(io.File audioFile);

class AudioWaveRecordController {
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PUBLIC***************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  final OnRecordComplete onRecordComplete;
  String errorMsg;

  StreamController<List<double>> audioFFT;

  AudioWaveRecordController({@required this.onRecordComplete}) {
    _init();
  }

  List<double> waves = [];

  double remap(double x,
      {double inMin = 0,
      double inMax = 15,
      double outMin = 0.1,
      double outMax = 1.0}) {
    x = x > -10 ? -10 : x;
    x = x < -25 ? -25 : x;

    x += 25;

    return (((outMax - outMin) * (x - inMin)) / (inMax - inMin)) + outMin;
  }

  void addToWave(double wave) {
    if (audioFFT != null) {
      if (!audioFFT.isClosed) {
        waves.add(remap(wave));
      }
      audioFFT.add(waves);
    }
  }

  void startRecord() async {
    audioFFT = StreamController<List<double>>();

    await _recorder.start();

    _current = await _recorder.current();

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus != RecordingStatus.Recording) {
        t.cancel();
      }

      _current = await _recorder.current();
      _currentStatus = _current.status;
      addToWave(_current.metering.averagePower);
    });

    _notifyChange();
  }

  void stopRecord() async {
    var result = await _recorder.stop();
    await audioFFT?.close();
    audioFFT = null;
    io.File file = _localFileSystem.file(result.path);
    onRecordComplete(file);

    _current = result;
    _currentStatus = _current.status;
    _init();
  }

  void addCallback(Function callBack) {
    _statusChangeCallBack.add(callBack);
  }

  void _notifyChange() {
    for (Function callBack in _statusChangeCallBack) {
      callBack();
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///************************************************PRIVATE**************************************************************
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  final LocalFileSystem _localFileSystem = LocalFileSystem();

  final List<Function> _statusChangeCallBack = [];

  void _init() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      String customPath = '/temp_voices';
      io.Directory appDocDirectory;
      if (io.Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }

      customPath = appDocDirectory.path +
          customPath +
          DateTime.now().millisecondsSinceEpoch.toString();

      _recorder =
          FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

      await _recorder.initialized;
      Recording current = await _recorder.current();

      _current = current;
      _currentStatus = current.status;
    } else {
      errorMsg = "You must accept permissions";
    }
  }
}
