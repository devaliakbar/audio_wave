class AudioWaveRecordController {
  List<double> animatedBars;

  Function _animatedBarsCallback;

  void startRecord() async {}

  void stopRecord() async {}

  void addCallback(Function animatedBarsCallback) {
    _animatedBarsCallback = animatedBarsCallback;
  }
}
