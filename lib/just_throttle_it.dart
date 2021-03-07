library just_throttle_it;

import 'dart:async';

/// Map of functions currently being throttled.
Map<Function, _ThrottleTarget> _throttled = <Function, _ThrottleTarget>{};

/// A collection of of static functions to throttle calls to a target function.
class Throttle {
  /// Calls [duration] with a timeout specified in milliseconds.
  static bool milliseconds(int timeoutMs, Function target,
          [List<dynamic> positionalArguments = const [],
          Map<Symbol, dynamic> namedArguments = const {}]) =>
      duration(Duration(milliseconds: timeoutMs), target, positionalArguments,
          namedArguments);

  /// Calls [duration] with a timeout specified in seconds.
  static bool seconds(int timeoutSeconds, Function target,
          [List<dynamic> positionalArguments = const [],
          Map<Symbol, dynamic> namedArguments = const {}]) =>
      duration(Duration(seconds: timeoutSeconds), target, positionalArguments,
          namedArguments);

  /// Calls [target] immediately and prevents subsequent calls until [timeout] duration.
  ///
  /// Repeated calls to [duration] (or any throttle operation in this library)
  /// with the same [Function target] will be supressed until the original call
  /// reaches its timeout limit.
  ///
  /// Returns [true] if the function was called, [false] if it was blocked.
  static bool duration(Duration timeout, Function target,
      [List<dynamic> positionalArguments = const [],
      Map<Symbol, dynamic> namedArguments = const {}]) {
    if (_throttled.containsKey(target)) {
      return false;
    }

    Function.apply(target, positionalArguments, namedArguments);
    final _ThrottleTarget throttleTarget =
        _ThrottleTarget(target, positionalArguments, namedArguments);
    _throttled[target] = throttleTarget;
    Timer(timeout, () {
      _throttled.remove(target);
    });

    return true;
  }

  static bool clear(Function target) {
    if (_throttled.containsKey(target)) {
      _throttled.remove(target);
      return true;
    }

    return false;
  }
}

// _ThrottleTimer allows us to keep track of the target function
// along with it's timer.
class _ThrottleTarget {
  final Function target;
  final List<dynamic> positionalArguments;
  final Map<Symbol, dynamic> namedArguments;

  _ThrottleTarget(this.target, this.positionalArguments, this.namedArguments);
}
