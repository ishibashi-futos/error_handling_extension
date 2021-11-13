import 'package:test/test.dart';
import 'package:functional_error_handling_dart/functional_error_handling_dart.dart'
    show Some, None, Option;

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

  test('map some', () {
    final maybe = Some<int>(1);
    final mapped = maybe.map((value) => value + 1);
    expect(mapped.getOrElse(100), 2);
    expect(mapped is Some<int>, isTrue);
    expect(mapped is None, isFalse);
  });

  test('map none', () {
    final maybe = None<int>();
    final mapped = maybe.map((value) => value + 1);
    expect(mapped is Some<int>, isFalse);
    expect(mapped is None, isTrue);
    expect(mapped.getOrElse(100), 100);
  });

  test('map some async', () async {
    final maybe = Some<int>(1);
    final mapped = await maybe.mapAsync<String>((p0) async => '${p0}000');
    expect(mapped.getOrElse('2000'), '1000');
    expect(mapped is Some<String>, isTrue);
    expect(mapped is Option<String>, isTrue);
    expect(mapped is Some<int>, isFalse);
    expect(mapped is None<int>, isFalse);
  });

  test('map none async', () async {
    final maybe = None<int>();
    final mapped = await maybe.mapAsync<String>((p0) async => '1000');
    expect(mapped.getOrElse('2000'), '2000');
    expect(mapped is Some<String>, isFalse);
    expect(mapped is Option<String>, isTrue);
    expect(mapped is Some<int>, isFalse);
    expect(mapped is None<String>, isTrue);
  });

  test('is some matching', () {
    final maybe = Some<int>(100);
    maybe.match((p0) {
      expect(p0, 100);
    }, () {
      fail('should not be None');
    });
  });

  test('is none matching', () {
    final maybe = None<int>();
    maybe.match((p0) {
      fail('should not be Some');
    }, () {
      // pass
      expect(true, true);
    });
  });

  test('is some matching async', () async {
    final maybe = Some<int>(100);
    await maybe.matchAsync((p0) async {
      expect(p0, 100);
    }, () async {
      fail('should not be None');
    });
  });

  test('is none matching async', () async {
    final maybe = None<int>();
    var passed = false;
    await maybe.match((p0) {
      fail('should not be Some');
    }, () {
      // pass
      passed = true;
    });
    expect(passed, isTrue);
  });

  test('If the result is true when it exists', () {
    final maybe = Some<double>(3.14);
    expect(maybe.exists((p0) => p0 == 3.14), isTrue);
  });

  test('If false when the result does not exist', () {
    final maybe = Some<double>(3.14);
    expect(maybe.exists((p0) => p0 == 3.13), isFalse);
  });

  test('If Left, it will be false in any case.', () {
    final maybe = None<double>();
    expect(maybe.exists((p0) {
      fail("If called, an error will occur.");
    }), isFalse);
  });
}
