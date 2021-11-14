import 'package:test/test.dart';
import 'package:functional_error_handling_dart/functional_error_handling_dart.dart'
    show Right, Left, Either, Some, None;

Future<void> main() async {
  test('right generic is right', () {
    final maybe = Right<String, int>(1);
    expect(maybe.isRight, isTrue);
    expect(maybe.isLeft, isFalse);
    expect(maybe.getOrElse(100), 1);
    expect(maybe.right, 1);
    expect(maybe is Either<String, int>, isTrue);
  });

  test('left generic is left', () {
    final maybe = Left<String, int>("Left");
    expect(maybe.isRight, isFalse);
    expect(maybe.isLeft, isTrue);
    expect(maybe.getOrElse(100), 100);
    expect(maybe.left, "Left");
    expect(maybe is Either<String, int>, isTrue);
  });

  test('map right', () {
    final maybe = Right<String, int>(1);
    final mapped = maybe.map((value) => value + 1);
    expect(mapped.getOrElse(100), 2);
    expect(mapped is Some<int>, isTrue);
    expect(mapped is Some<String>, isFalse);
    expect(mapped is None, isFalse);
  });

  test('map left', () {
    final maybe = Left<String, int>('Left');
    final mapped = maybe.map((value) => value + 1);
    expect(mapped is Some<int>, isFalse);
    expect(mapped is Some<String>, isFalse);
    expect(mapped is None, isTrue);
    expect(mapped.getOrElse(100), 100);
  });

  test('map right async', () async {
    final maybe = Right<String, int>(1);
    final mapped = await maybe.mapAsync<String>((int value) async {
      return Some('map right async');
    });
    expect(mapped.getOrElse('map left async'), 'map right async');
    expect(mapped is Some<String>, isTrue);
    expect(mapped is None, isFalse);
  });

  test('map left async', () async {
    final maybe = Left<String, int>('map left async');
    final mapped = await maybe.mapAsync<String>((int value) async {
      return Some('map right async');
    });
    expect(mapped.getOrElse('map left async'), 'map left async');
    expect(mapped is Some<String>, isFalse);
    expect(mapped is None, isTrue);
  });

  test('swap left to right', () {
    final maybe = Left<String, String>('right');
    final swapped = maybe.swap();
    expect(swapped.isRight, isTrue);
    expect(swapped.isLeft, isFalse);
    expect(swapped.getOrElse('left'), 'right');
  });

  test('swap right to left', () {
    final maybe = Right<String, String>('left');
    final swapped = maybe.swap();
    expect(swapped.isRight, isFalse);
    expect(swapped.isLeft, isTrue);
    expect(swapped.getOrElse('right'), 'right');
    expect(swapped.left, 'left');
  });

  test('is right matching', () {
    final maybe = Right<String, int>(100);
    maybe.match((p0) {
      expect(p0, 100);
    }, (p0) {
      fail('should not be left');
    });
  });

  test('is left matching', () {
    final maybe = Left<String, int>("left");
    maybe.match((p0) {
      fail('should not be right');
    }, (p0) {
      expect(p0, "left");
    });
  });

  test('is right matching async', () async {
    final maybe = Right<String, int>(300);
    await maybe.matchAsync((p0) async {
      expect(p0, 300);
    }, (p0) async {
      fail('should not be left');
    });
  });

  test('is left matching async', () async {
    final maybe = Left<String, int>("left async");
    await maybe.matchAsync((p0) async {
      fail('should not be right');
    }, (p0) async {
      expect(p0, "left async");
    });
  });

  test('If the result is true when it exists', () {
    final maybe = Right<String, double>(3.14);
    expect(maybe.exists((p0) => p0 == 3.14), isTrue);
  });

  test('If false when the result does not exist', () {
    final maybe = Right<String, double>(3.14);
    expect(maybe.exists((p0) => p0 == 3.13), isFalse);
  });

  test('If Left, it will be false in any case.', () {
    final maybe = Left<String, double>("string");
    expect(maybe.exists((p0) {
      fail("If called, an error will occur.");
    }), isFalse);
  });

  group('fold', () {
    test('fold if Right', () {
      final maybe = Right<String, int>(100);
      expect(
          maybe.fold<String>((right) {
            expect(right, 100);
            return right.toString();
          }, (left) {
            fail('If called, an error will occur.');
          }),
          '100');
    });

    test('fold if Left', () {
      final maybe = Left<String, int>('100');
      expect(
          maybe.fold<int>((right) {
            fail('If called, an error will occur.');
          }, (left) {
            expect(left, '100');
            expect(left is String, isTrue);
            return int.parse(left);
          }),
          100);
    });
  });
}
