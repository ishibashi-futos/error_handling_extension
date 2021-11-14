import 'package:functional_error_handling_dart/functional_error_handling_dart.dart';

Future<void> main() async {
  var names = {'John': 'Doe', 'Hoge': 'Fuga'};

  Option<String> getName(String name) =>
      names.containsKey(name) ? Some(names[name]!) : None();

  // Some
  final doe = getName('John');
  print(doe.isDefined); //true
  print(doe.getOrElse('No Name')); // 'Doe'

  // Some
  final smith = getName('Jane');
  print(smith.isDefined); // false
  print(smith.isEmpty); // true
  print(smith.getOrElse('Smith')); // 'Smith

  final extend1 = names.getValue('John');
  print(extend1 is Option<String>); // true
  print(extend1 is Some<String>); // true

  final extend2 = names.getValue('Jane');
  print(extend2 is Option<String>); // true
  print(extend2 is None<String>); // true
}

extension OptionMap<K, V> on Map<K, V> {
  Option<V> getValue(K key) => !containsKey(key) ? None() : Some<V>(this[key]!);
}
