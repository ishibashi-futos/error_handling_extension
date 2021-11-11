abstract class Option<V> {
  late final V? _value;

  // True if empty.
  bool get isEmpty => this is None;
  // True is not empty.
  bool get isDefined => this is Some<V>;

  // get value or else.
  V getOrElse(V orElse) => isEmpty ? orElse : _value!;

  // get value or null.
  V? orNull() => isEmpty ? null : _value;

  // transform value.
  Option<T> map<T>(T Function(V) f) => isEmpty ? None() : Some(f(_value!));

  // transform value async.
  Future<Option<T>> mapAsync<T>(Future<T> Function(V) f) async =>
      isEmpty ? Future.value(None()) : Future.value(Some<T>(await f(_value!)));

  // pattern match.
  match<T>(Function(V) some, Function() none) =>
      isEmpty ? none() : some(_value!);

  // pattern match async.
  Future<void> matchAsync<T>(
          Future<void> Function(V) some, Future<void> Function() none) async =>
      isEmpty ? await none() : await some(_value!);

  bool exists(bool Function(V) some) => isEmpty ? false : some(_value!);
}

class Some<V> extends Option<V> {
  Some(V value) {
    _value = value;
  }
}

class None<V> extends Option<V> {
  None();
}
