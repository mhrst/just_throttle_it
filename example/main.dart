import 'dart:async';

import 'package:just_throttle_it/just_throttle_it.dart';

void main() async {
  void printSeconds() => print("Hello World (Throttle.seconds)");
  Throttle.seconds(1, printSeconds); // Will print immediately
  Throttle.seconds(1, printSeconds); // Will not print

  void printMs() => print("Hello World (Throttle.milliseconds)");
  Throttle.milliseconds(500, printMs); // Will print immediately
  Throttle.clear(printMs);
  Throttle.milliseconds(500, printMs); // Will print immediately

  final duration = const Duration(milliseconds: 2000);
  Throttle.duration(duration, print, ["Hello World 1 (Throttle.duration)"]); // Will print immediately
  Throttle.duration(duration, print, ["Hello World 2 (Throttle.duration)"]); // Will not print
  Throttle.duration(duration, print, ["Hello World 3 (Throttle.duration)"]); // Will not print
  Throttle.duration(duration, print, ["Hello World 4 (Throttle.duration)"]); // Will not print
  Throttle.duration(duration, print, ["Hello World 5 (Throttle.duration)"]); // Will not print

  await Future.delayed(duration);
  
  Throttle.duration(duration, print, ["Hello World 6 (Throttle.duration)"]); // Will print immediately
}