class AudioWave {
  static const int BAR_LENGTH = 100;

  List<int> dimensionIndexes = [];
  List<List<double>> wavesInDimension = [];

  void addStream(int index, List<double> data) {
    //CHECKING INDEX NOT EXIST
    if (index >= (dimensionIndexes.length - 1)) {
      wavesInDimension.add(data);
      dimensionIndexes.add(1);
      return;
    }

    int divideValue = dimensionIndexes[index] + 1;

    if (divideValue > BAR_LENGTH) {
      addStream(index + 1, wavesInDimension[index]);
      dimensionIndexes[index] = 1;
      wavesInDimension[index] = data;
      return;
    }

    int arraySizeForNewData = BAR_LENGTH ~/ divideValue;

    List<double> newDataAfterReduced =
        reduceArraySize(arraySizeForNewData, data);

    List<double> previousDataAfterReduced = reduceArraySize(
        BAR_LENGTH - arraySizeForNewData, wavesInDimension[index]);

    previousDataAfterReduced.addAll(newDataAfterReduced);

    wavesInDimension[index] = previousDataAfterReduced;
    dimensionIndexes[index] = divideValue;
  }

  List<double> reduceArraySize(int reduceSize, List<double> data) {
    List<double> reducedArray = [];

    int index = 0;
    while (index < BAR_LENGTH) {
      if (reducedArray.length == reduceSize) {
        break;
      }

      int meanUtilIndex = reduceSize;
      if (index > 0) {
        meanUtilIndex = index * reduceSize;
      }

      double total = 0;
      int indexForMean = meanUtilIndex - reduceSize;
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

      index = index + reduceSize;
    }

    if (reducedArray.length != reduceSize) {
      int indexForMean = data.length - reduceSize;
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
}
