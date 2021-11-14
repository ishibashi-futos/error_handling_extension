import 'dart:ffi';

import 'package:test/test.dart';
import 'package:functional_error_handling_dart/functional_error_handling_dart.dart';
import 'package:functional_error_handling_dart/extensions.dart';

Future<void> main() async {
  group('Map', () {
    const map = <String, int>{'key1': 1, 'key2': 2, 'key3': 3};
    test('has item', () {
      final maybe = map.maybe('key1');
      expect(maybe is Option<int>, isTrue);
      expect(maybe.orNull()!, 1);
      maybe.match((p0) => expect(p0, 1), () => fail('failure'));
    });

    test('not contain', () {
      final maybe = map.maybe('key4');
      expect(maybe is Option<int>, isTrue);
      expect(maybe.isEmpty, isTrue);
      expect(maybe.getOrElse(4), 4);
      maybe.match((p0) => fail('failure'), () => {});
    });
  });
}
