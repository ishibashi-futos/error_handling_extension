abstract class Option<V> {
  late final V? _value;
  bool get isEmpty => this is None;
  bool get isDefined => this is Some<V>;
  V getOrElse(V orElse) => isEmpty ? orElse : _value!;
  V? orNull() => isEmpty ? null : _value;

  Option<T> map<T>(T Function(V) f) => isEmpty ? None() : Some(f(_value!));

  match<T>(Function(V) some, Function() none) =>
      isEmpty ? none() : some(_value!);
}

class Some<V> extends Option<V> {
  Some(V value) {
    _value = value;
  }
}

class None<V> extends Option<V> {
  None();
}
