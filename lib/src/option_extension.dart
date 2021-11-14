import './option.dart';

extension OptionalMap<K, V> on Map<K, V> {
  Option<V> maybe(K key) => !containsKey(key) ? None() : Some(this[key]!);
}
