import 'dart:io';

final SdtOutput stdOut = SdtOutput._private();

class SdtOutput {
  SdtOutput._private();

  void println(Object x) {
    stdout.writeln(x);
  }
}