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
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _target,
              positionalArguments: [2],
            ));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _target,
              positionalArguments: [2],
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _target,
              positionalArguments: [2],
            ));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, equals(2));
      });
      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named and positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, equals(4));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.duration(
              throttleDuration,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
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
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _target,
              positionalArguments: [2],
            ));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _target,
              positionalArguments: [2],
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _target,
              positionalArguments: [2],
            ));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named and positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, equals(4));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.milliseconds(
              throttleMilliseconds,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
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
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _target,
              positionalArguments: [2],
            ));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _target,
              positionalArguments: [2],
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _target,
              positionalArguments: [2],
            ));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, equals(2));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _targetNamedOnly,
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, greaterThan(2));
      });
    });
    group('with named and positional arguments', () {
      test('Should increment counter immediately', () {
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
        expect(_counter, equals(4));
      });

      test(
          'Should increment counter when target is called after timeout duration',
          () async {
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
        await Future.delayed(throttleDuration);
        throttleIt(() => Throttle.seconds(
              throttleSeconds,
              _target,
              positionalArguments: [2],
              namedArguments: {#multiplier: 2},
            ));
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

  group('Throttle leading/trailing options', () {
    test(
        'Should execute only on leading edge when leading=true, trailing=false',
        () async {
      throttleIt(() => Throttle.duration(
            throttleDuration,
            _targetNoArgs,
            leading: true,
            trailing: false,
          ));
      await Future.delayed(throttleDuration);
      expect(_counter, equals(1)); // Only first call executed
    });

    test(
        'Should execute only on trailing edge when leading=false, trailing=true',
        () async {
      throttleIt(() => Throttle.duration(
            throttleDuration,
            _targetNoArgs,
            leading: false,
            trailing: true,
          ));
      expect(_counter, equals(0)); // No immediate execution
      await Future.delayed(throttleDuration);
      expect(_counter, equals(1)); // Executed after delay
    });

    test('Should execute on both edges when leading=true, trailing=true',
        () async {
      throttleIt(() => Throttle.duration(
            throttleDuration,
            _targetNoArgs,
            leading: true,
            trailing: true,
          ));
      expect(_counter, equals(1)); // Immediate execution
      await Future.delayed(throttleDuration);
      expect(_counter, equals(2)); // Trailing execution
    });

    test('Should not execute at all when leading=false, trailing=false',
        () async {
      throttleIt(() => Throttle.duration(
            throttleDuration,
            _targetNoArgs,
            leading: false,
            trailing: false,
          ));
      expect(_counter, equals(0)); // No immediate execution
      await Future.delayed(throttleDuration);
      expect(_counter, equals(0)); // Still no execution
    });

    test('Should handle multiple throttle windows correctly', () async {
      // First window
      throttleIt(() => Throttle.duration(
            throttleDuration,
            _targetNoArgs,
            leading: true,
            trailing: true,
          ));
      expect(_counter, equals(1)); // Leading edge of first window
      await Future.delayed(throttleDuration);
      expect(_counter, equals(2)); // Trailing edge of first window

      // Second window
      throttleIt(() => Throttle.duration(
            throttleDuration,
            _targetNoArgs,
            leading: true,
            trailing: true,
          ));
      expect(_counter, equals(3)); // Leading edge of second window
      await Future.delayed(throttleDuration);
      expect(_counter, equals(4)); // Trailing edge of second window
    });
  });
}
