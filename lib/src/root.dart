// common definitions

// Delay evaluation generator function.
typedef Lazy<T> = T Function();

abstract class FunctionalErrorHandling<T, V> {
  T getOrElse(T orElse);
  void match(Function(T) t, Function(V) v);
  Future<void> matchAsync(
      Future<void> Function(T) t, Future<void> Function(V) v);

  bool exists(bool Function(T) fs);
}
