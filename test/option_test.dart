import 'dart:math';

import 'package:test/test.dart';
import 'package:error_handling_extension/error_handling_extension.dart';

Future<void> main() async {
  test('is Some', () {
    final maybe = Some<int>(100);
    expect(maybe.isDefined, isTrue);
    expect(maybe.isEmpty, isFalse);
    expect(maybe is Some<int>, isTrue);
    expect(maybe is None<int>, isFalse);
    expect(maybe is Option<int>, isTrue);
    expect(maybe.getOrElse(1000), 100);
  });

  test('is None', () {
    final maybe = None<int>();
    expect(maybe.isEmpty, isTrue);
    expect(maybe.isDefined, isFalse);
    expect(maybe is Some<int>, isFalse);
    expect(maybe is None<int>, isTrue);
    expect(maybe is Option<int>, isTrue);
    expect(maybe.getOrElse(1000), 1000);
  });

  test('None orNull', () {
    final maybe = None<int>();
    expect(maybe.orNull(), null);
  });
  test('Some orNull', () {
    final maybe = Some<int>(10);
    expect(maybe.orNull(), 10);
  });

  test('map right', () {
    final maybe = Some<int>(1);
    final mapped = maybe.map((value) => value + 1);
    expect(mapped.getOrElse(100), 2);
    expect(mapped is Some<int>, isTrue);
    expect(mapped is None, isFalse);
  });

  test('map left', () {
    final maybe = None<int>();
    final mapped = maybe.map((value) => value + 1);
    expect(mapped is Some<int>, isFalse);
    expect(mapped is None, isTrue);
    expect(mapped.getOrElse(100), 100);
  });

  test('is right matching', () {
    final maybe = Some<int>(100);
    maybe.match((p0) {
      expect(p0, 100);
    }, () {
      fail('should not be None');
    });
  });

  test('is left matching', () {
    final maybe = None<int>();
    maybe.match((p0) {
      fail('should not be Some');
    }, () {
      // pass
      expect(true, true);
    });
  });
}
