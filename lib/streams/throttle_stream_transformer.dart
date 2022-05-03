import 'dart:async';

import 'package:just_throttle_it/just_throttle_it.dart';

/// A stream transformer that throttles stream values
class ThrottleStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;

  /// Transforms a stream by throttling stream values by [duration]
  ThrottleStreamTransformer(this.duration);

  /// Transforms a stream by throttling stream values by [milliseconds]
  factory ThrottleStreamTransformer.milliseconds(int milliseconds) =>
      ThrottleStreamTransformer(Duration(milliseconds: milliseconds));

  /// Transforms a stream by throttling stream values by [seconds]
  factory ThrottleStreamTransformer.seconds(int seconds) =>
      ThrottleStreamTransformer(Duration(seconds: seconds));

  /// Stream values are throttled by checking the response from
  /// [Throttle.duration], using [_noop] as the target method. If
  /// [Throttle.duration] returns true, emit the stream value.
  @override
  Stream<T> bind(Stream<T> stream) async* {
    await for (final value in stream) {
      final _yield = Throttle.duration(duration, _noop);
      if (_yield) yield value;
    }
  }

  /// An empty method to use as a target for [Throttle.duration]
  void _noop() {}
}
