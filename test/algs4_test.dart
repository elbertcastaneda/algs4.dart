import 'package:algs4/algs4.dart';
import 'package:algs4/me/MyMath.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(['']), 42);
  });

  test('MyMath.sqrt', () {
    expect(MyMath.sqrt(0), 0);
    expect(MyMath.sqrt(1), 1.0);
    expect(MyMath.sqrt(2), 1.414213562373095);
    expect(MyMath.sqrt(3), 1.7320508075688772);
  });

  test('MyMath.dartSqrt', () {
    expect(MyMath.dartSqrt(0), 0);
    expect(MyMath.dartSqrt(1), 1.0);
    expect(MyMath.dartSqrt(2), 1.4142135623730951);
    expect(MyMath.dartSqrt(3), 1.7320508075688772);
  });
}
