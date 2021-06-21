import 'package:flutter/material.dart';

typedef OnGenerateWave(List<double> waves);

class AudioWaveGenerator {
  static const int _BAR_LENGTH = 100;

  final OnGenerateWave onGenerateWave;
  AudioWaveGenerator({@required this.onGenerateWave});

  List<double> currentBuffer = [];
  List<double> visualBuffer = [];

  void addToStream(double data) {
    visualBuffer.add(_reMapWave(data));
    onGenerateWave(visualBuffer);

    if (visualBuffer.length > 120) {
      visualBuffer.removeAt(0);
    }

    currentBuffer.add(_reMapWave(data));

    if (currentBuffer.length == _BAR_LENGTH) {
      addToMainStream(0, currentBuffer);
      currentBuffer = [];
    }
  }

  List<double> getFinalWave() {
    if (wavesInDimension.length > 0) {
      return wavesInDimension[wavesInDimension.length - 1];
    }
    if (currentBuffer.length > 0) {
      return currentBuffer;
    }
    return null;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////DARK MATTER/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  List<int> dimensionIndexes = [];
  List<List<double>> wavesInDimension = [];

  void addToMainStream(int index, List<double> data) {
    //CHECKING INDEX NOT EXIST
    if (index >= (dimensionIndexes.length - 1)) {
      wavesInDimension.add(data);
      dimensionIndexes.add(1);
      return;
    }

    int divideValue = dimensionIndexes[index] + 1;

    if (divideValue > _BAR_LENGTH) {
      addToMainStream(index + 1, wavesInDimension[index]);
      dimensionIndexes[index] = 1;
      wavesInDimension[index] = data;
      return;
    }

    int arraySizeForNewData = _BAR_LENGTH ~/ divideValue;

    List<double> newDataAfterReduced =
        reduceArraySize(arraySizeForNewData, data);

    List<double> previousDataAfterReduced = reduceArraySize(
        _BAR_LENGTH - arraySizeForNewData, wavesInDimension[index]);

    previousDataAfterReduced.addAll(newDataAfterReduced);

    wavesInDimension[index] = previousDataAfterReduced;
    dimensionIndexes[index] = divideValue;
  }

  List<double> reduceArraySize(int reduceSize, List<double> data) {
    List<double> reducedArray = [];

    final int divideSize = data.length ~/ reduceSize;

    int index = 0;
    while (index < _BAR_LENGTH) {
      if (reducedArray.length == reduceSize) {
        break;
      }

      int meanUtilIndex = divideSize;
      if (index > 0) {
        meanUtilIndex = index * divideSize;
      }

      double total = 0;
      int indexForMean = meanUtilIndex - divideSize;
      int countForMean = 0;
      while (indexForMean < meanUtilIndex) {
        if (indexForMean >= (data.length - 1)) {
          break;
        }

        total += data[indexForMean];
        indexForMean++;
        countForMean++;
      }
      reducedArray.add(total / countForMean);

      index = index + divideSize;
    }

    if (reducedArray.length != reduceSize) {
      int indexForMean = data.length - divideSize;
      double total = 0;
      int countForMean = 0;
      while (indexForMean < data.length) {
        if (indexForMean >= (data.length - 1)) {
          break;
        }

        total += data[indexForMean];
        indexForMean++;
        countForMean++;
      }
      reducedArray.add(total / countForMean);
    }

    return reducedArray;
  }

  double _reMapWave(double x) {
    double inMin = 0;
    double inMax = 15;
    double outMin = 0.1;
    double outMax = 1.0;

    x = x > -10 ? -10 : x;
    x = x < -25 ? -25 : x;

    x += 25;

    return (((outMax - outMin) * (x - inMin)) / (inMax - inMin)) + outMin;
  }
}
