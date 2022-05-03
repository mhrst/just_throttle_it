library just_throttle_it_test;

import 'dart:async';

import 'package:just_throttle_it/just_throttle_it.dart';
import 'package:test/test.dart';

void main() {
  final throttleIterations = 1000;
  final throttleSeconds = 1;
  final throttleMilliseconds = 1000;
  final throttleDuration = Duration(seconds: throttleSeconds);

  int _counter = 0;

  int _targetNoArgs() => _counter = _counter + 1;

  int _target(int incrementBy, {int multiplier = 1}) =>
      _counter = (_counter + incrementBy) * multiplier;

  int _targetNamedOnly({int multiplier = 1}) =>
      _counter = (_counter + 1) * multiplier;

  setUp(() => _counter = 0);

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

  /// Returns the expected number of events using [ThrottleStreamTransformer t]
  int throttleStream(ThrottleStreamTransformer t) {
    int _ms = 0;

    // Stream values every 1/100 of [ThrottleStreamTransformer.duration]
    int _periodMs = t.duration.inMilliseconds ~/ 100;

    final sc = StreamController();
    Timer.periodic(Duration(milliseconds: _periodMs), (timer) {
      _ms += _periodMs;
      sc.add(_ms);

      // Close stream after _periodMs * throttleIterations
      if (_ms == _periodMs * throttleIterations) {
        timer.cancel();
        sc.close();
      }
    });

    // Increment counter when stream emits value
    sc.stream.transform(t)..listen((event) => _counter++);

    return (_periodMs * throttleIterations) ~/ t.duration.inMilliseconds;
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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
          'Should increment counter when target is called after timeout duration',
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

  group('ThrottleStreamTransformer', () {
    test('Should throttle stream by duration', () async {
      final expected = throttleStream(
          ThrottleStreamTransformer(Duration(seconds: throttleSeconds)));
      await Future.delayed(throttleDuration * expected);
      expect(_counter, equals(expected));
    });

    test('Should throttle stream by seconds', () async {
      final expected =
          throttleStream(ThrottleStreamTransformer.seconds(throttleSeconds));
      await Future.delayed(throttleDuration * expected);
      expect(_counter, equals(expected));
    });

    test('Should throttle stream by milliseconds', () async {
      final expected = throttleStream(
          ThrottleStreamTransformer.milliseconds(throttleMilliseconds));
      await Future.delayed(throttleDuration * expected);
      expect(_counter, equals(expected));
    });
  });
}
