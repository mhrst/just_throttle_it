# Changelog

## 3.0.0
  * **BREAKING CHANGES**: Parameters passed into throttle function are passed by name now. (Previously these parameters were passed by position.)
  * Adding `leading` and `trailing` flags to throttle functions. 
    * The `leading` option defaults to `true` for the default behavior. Toggling it to `false` will skip the first function output.
    * The `trailing` option defaults to `false`. Toggling it to `true` will enforce that the last call to the function is always executed.

## 2.1.0
  * Add support for throttling streams with ThrottleStreamTransformer

## 2.0.0
  * Migrate to null-safety

## 1.0.0

  * Initial version of a throttle library.