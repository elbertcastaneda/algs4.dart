import 'dart:math' as math;

class MyMath {
  static double sqrt(double value) {
    if (value < 0) {
      return double.nan;
    }

    const eps = 1e-15;
    var result = value;

    while ((result - value / result).abs() > eps * result) {
      result = (value / result + result) / 2.0;
    }

    return result;
  }

  static double dartSqrt(double value) {
    return math.sqrt(value);
  }
}
