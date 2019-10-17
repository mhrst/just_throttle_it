# just_throttle_it

A simple throttle library for Dart.

```dart
import 'package:just_throttle_it/just_throttle_it.dart';

Throttle.milliseconds(1000, print, ["Throttle World!"]);
```

## Static methods

There are three methods available for throttling. A value of `true` will be returned if the function call is successful, and `false` if the function has been blocked. All methods differ only by the first parameter used to specify timeout values in different formats:

```dart
Throttle.seconds(int timeoutSeconds, 
    Function target,
    [List<dynamic> positionalArguments, 
    Map<Symbol, dynamic> namedArguments])
```
```dart
Throttle.milliseconds(int timeoutMs, 
    Function target,
    [List<dynamic> positionalArguments, 
    Map<Symbol, dynamic> namedArguments])
```
```dart
Throttle.duration(Duration timeout, 
    Function target,
    [List<dynamic> positionalArguments, 
    Map<Symbol, dynamic> namedArguments])
```

To clear a throttled `target`, allowing the next throttled call to be immediately executed:
```dart
Throttle.clear(Function target)
```

## Example

A quick demonstration can be found in the `example` directory. To run the example:

`pub run example/main.dart`
