import 'package:flutter_fft/flutter_fft.dart';

class AudioWaveRecordController {
  List<double> animatedBars;

  Function _animatedBarsCallback;

  final FlutterFft _flutterFft = new FlutterFft();

  void startRecord() async {
    await _flutterFft.startRecorder();

    _flutterFft.onRecorderStateChanged.listen(
      (data) {
        if (data == null) {
          return;
        }

        animatedBars = animatedBars ?? [];

        animatedBars.add(_scaleDown(data[1]));

        if (_animatedBarsCallback != null) {
          _animatedBarsCallback();
        }

        _flutterFft.setNote = data[2];
        _flutterFft.setFrequency = data[1];
      },
    );
  }

  void stopRecord() async {
    await _flutterFft.stopRecorder();
  }

  void addCallback(Function animatedBarsCallback) {
    _animatedBarsCallback = animatedBarsCallback;
  }

  double _scaleDown(double x,
      {double inMin = 10,
      double inMax = 300,
      double outMin = 10,
      double outMax = 100}) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }
}
