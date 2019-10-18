library just_throttle_it_test;

import 'dart:async';
import 'package:test/test.dart';
import 'package:just_throttle_it/just_throttle_it.dart';

void main() {
  final throttleIterations = 1000;
  final throttleSeconds = 1;
  final throttleMilliseconds = 1000;
  final throttleDuration = Duration(seconds: throttleSeconds);

  int _counter;
  setUp(() => _counter = 0);
  int _targetNoArgs() => _counter = _counter + 1;
  int _target(int incrementBy, {int multiplier}) =>
      _counter = (_counter + incrementBy) * (multiplier ?? 1);
  int _targetNamedOnly({int multiplier}) =>
      _counter = (_counter + 1) * (multiplier ?? 1);
  tearDown(() {
    Throttle.clear(_target);
    Throttle.clear(_targetNoArgs);
    Throttle.clear(_targetNamedOnly);
  });

  void throttleIt(Function throttleFn) {
    // Call debounceFn multiple times
    for (var i = 0; i < throttleIterations; i++) {
      throttleFn();
    }
  }

  group('Throttle.duration', () {
    group('without arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.duration(throttleDuration, _targetNoArgs));
        expect(_counter, equals(1));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(throttleDuration, _targetNoArgs));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(throttleDuration, _targetNoArgs));
        expect(_counter, greaterThan(1));
      });
    });
    group('with positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.duration(throttleDuration, _target, [2]));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(throttleDuration, _target, [2]));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(throttleDuration, _target, [2]));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.duration(
            throttleDuration, _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        expect(_counter, equals(2));
      });
      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(
            throttleDuration, _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(
            throttleDuration, _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named and positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.duration(
            throttleDuration, _target, [2], {Symbol("multiplier"): 2}));
        expect(_counter, equals(4));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(
            throttleDuration, _target, [2], {Symbol("multiplier"): 2}));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(
            throttleDuration, _target, [2], {Symbol("multiplier"): 2}));
        expect(_counter, greaterThan(4));
      });
    });
  });

  group('Throttle.milliseconds', () {
    group('without arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(
            () => Throttle.milliseconds(throttleMilliseconds, _targetNoArgs));
        expect(_counter, equals(1));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(
            () => Throttle.milliseconds(throttleMilliseconds, _targetNoArgs));
        await Future.delayed(throttleDuration);
        throttleIt(
            () => Throttle.milliseconds(throttleMilliseconds, _targetNoArgs));
        expect(_counter, greaterThan(1));
      });
    });
    group('with positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(
            () => Throttle.milliseconds(throttleMilliseconds, _target, [2]));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(
            () => Throttle.milliseconds(throttleMilliseconds, _target, [2]));
        await Future.delayed(throttleDuration);
        throttleIt(
            () => Throttle.milliseconds(throttleMilliseconds, _target, [2]));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.milliseconds(throttleMilliseconds,
            _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.milliseconds(throttleMilliseconds,
            _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.milliseconds(throttleMilliseconds,
            _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named and positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.milliseconds(
            throttleMilliseconds, _target, [2], {Symbol("multiplier"): 2}));
        expect(_counter, equals(4));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.milliseconds(
            throttleMilliseconds, _target, [2], {Symbol("multiplier"): 2}));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.milliseconds(
            throttleMilliseconds, _target, [2], {Symbol("multiplier"): 2}));
        expect(_counter, greaterThan(4));
      });
    });
  });

  group('Throttle.seconds', () {
    group('without arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.seconds(throttleSeconds, _targetNoArgs));
        expect(_counter, equals(1));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(throttleSeconds, _targetNoArgs));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(throttleSeconds, _targetNoArgs));
        expect(_counter, greaterThan(1));
      });
    });
    group('with positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.seconds(throttleSeconds, _target, [2]));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(throttleSeconds, _target, [2]));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(throttleSeconds, _target, [2]));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.seconds(
            throttleSeconds, _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(
            throttleSeconds, _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(
            throttleSeconds, _targetNamedOnly, [], {Symbol("multiplier"): 2}));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named and positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.seconds(
            throttleSeconds, _target, [2], {Symbol("multiplier"): 2}));
        expect(_counter, equals(4));
      });

      test(
          'Should increment counter when target us called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(
            throttleSeconds, _target, [2], {Symbol("multiplier"): 2}));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(
            throttleSeconds, _target, [2], {Symbol("multiplier"): 2}));
        expect(_counter, greaterThan(4));
      });
    });
  });

  group('Throttle.clear', () {
    test('Should cancel throttled target', () async {
      throttleIt(() => Throttle.duration(throttleDuration, _targetNoArgs));
      Throttle.clear(_targetNoArgs);
      throttleIt(() => Throttle.duration(throttleDuration, _targetNoArgs));
      expect(_counter, greaterThan(1));
    });
  });
}
