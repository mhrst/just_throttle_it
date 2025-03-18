library just_throttle_it;

import 'dart:async';
export 'streams/throttle_stream_transformer.dart';

/// Map of functions currently being throttled.
Map<Function, _ThrottleTarget> _throttled = <Function, _ThrottleTarget>{};

/// A collection of static functions to throttle calls to a target function.
class Throttle {
  static bool clear(Function target) {
    if (_throttled.containsKey(target)) {
      _throttled.remove(target);
      return true;
    }

    return false;
  }

  /// Calls [duration] with a timeout specified in milliseconds.
  static bool milliseconds(
    int timeoutMs,
    Function target, {
    List<dynamic> positionalArguments = const [],
    Map<Symbol, dynamic> namedArguments = const {},
    bool leading = true,
    bool trailing = false,
  }) =>
      duration(Duration(milliseconds: timeoutMs), target,
          positionalArguments: positionalArguments,
          namedArguments: namedArguments,
          leading: leading,
          trailing: trailing);

  /// Calls [duration] with a timeout specified in seconds.
  static bool seconds(
    int timeoutSeconds,
    Function target, {
    List<dynamic> positionalArguments = const [],
    Map<Symbol, dynamic> namedArguments = const {},
    bool leading = true,
    bool trailing = false,
  }) =>
      duration(Duration(seconds: timeoutSeconds), target,
          positionalArguments: positionalArguments,
          namedArguments: namedArguments,
          leading: leading,
          trailing: trailing);

  /// Calls [target] based on leading/trailing configuration and prevents subsequent calls until [timeout] duration.
  static bool duration(
    Duration timeout,
    Function target, {
    List<dynamic> positionalArguments = const [],
    Map<Symbol, dynamic> namedArguments = const {},
    bool leading = true,
    bool trailing = false,
  }) {
    if (_throttled.containsKey(target)) {
      if (trailing) {
        // Update the trailing call parameters
        _throttled[target]!
            .updateTrailingCall(positionalArguments, namedArguments);
      }
      return false;
    }

    if (leading) {
      Function.apply(target, positionalArguments, namedArguments);
    }

    final _ThrottleTarget throttleTarget =
        _ThrottleTarget(target, positionalArguments, namedArguments, trailing);
    _throttled[target] = throttleTarget;

    Timer(timeout, () {
      if (trailing) {
        // Execute trailing call with latest arguments
        final target = _throttled[throttleTarget.target]!;
        Function.apply(target.target, target.latestPositionalArguments,
            target.latestNamedArguments);
      }
      _throttled.remove(throttleTarget.target);
    });

    return leading;
  }

  // ... existing code ...
}

class _ThrottleTarget {
  final Function target;
  List<dynamic> positionalArguments;
  Map<Symbol, dynamic> namedArguments;
  final bool hasTrailing;
  List<dynamic> latestPositionalArguments;
  Map<Symbol, dynamic> latestNamedArguments;

  _ThrottleTarget(this.target, this.positionalArguments, this.namedArguments,
      this.hasTrailing)
      : latestPositionalArguments = positionalArguments,
        latestNamedArguments = namedArguments;

  void updateTrailingCall(
      List<dynamic> newPositionalArgs, Map<Symbol, dynamic> newNamedArgs) {
    if (hasTrailing) {
      latestPositionalArguments = newPositionalArgs;
      latestNamedArguments = newNamedArgs;
    }
  }
}
