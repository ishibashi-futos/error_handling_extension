import 'package:test/test.dart';
import 'package:error_handling_extension/error_handling_extension.dart';

Future<void> main() async {
  test('right generic is right', () {
    final maybe = Right<String, int>(1);
    expect(maybe.isRight, isTrue);
    expect(maybe.isLeft, isFalse);
    expect(maybe.getOrElse(100), 1);
    expect(maybe.right, 1);
  });

  test('left generic is left', () {
    final maybe = Left<String, int>("Left");
    expect(maybe.isRight, isFalse);
    expect(maybe.isLeft, isTrue);
    expect(maybe.getOrElse(100), 100);
    expect(maybe.left, "Left");
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
    Future<Option<String>> Function(int) map = (int value) async {
      return Some('map right async');
    };
    final mapped = await maybe.mapAsync<String>(map);
    expect(mapped.getOrElse('map left async'), 'map right async');
    expect(mapped is Some<String>, isTrue);
    expect(mapped is None, isFalse);
  });

  test('map left async', () async {
    final maybe = Left<String, int>('map left async');
    Future<Option<String>> Function(int) map = (int value) async {
      return Some('map right async');
    };
    final mapped = await maybe.mapAsync<String>(map);
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
}
