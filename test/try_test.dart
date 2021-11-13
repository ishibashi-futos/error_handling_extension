import 'package:test/test.dart';
import 'package:functional_error_handling_dart/functional_error_handling_dart.dart';

Future<void> main() async {
  test('Success generic is right', () {
    final maybe = Success("1000");
    expect(maybe.isSuccess, isTrue);
    expect(maybe.isFailure, isFalse);
    expect(maybe.getOrElse("2000"), "1000");
    expect(maybe is Try<String, Exception>, isTrue);
  });

  test('Failure generic is right', () {
    final maybe = Failure<String>(new Exception('Failure...'));
    expect(maybe.isFailure, isTrue);
    expect(maybe.isSuccess, isFalse);
    expect(maybe.getOrElse("2000"), "2000");
    expect(maybe is Try<String, Exception>, isTrue);
  });

  test('to Option if success', () {
    final maybe = Success("3.14").toOption();
    expect(maybe.isDefined, isTrue);
    expect(maybe.isEmpty, isFalse);
    expect(maybe is Option<String>, isTrue);
    expect(maybe is Some<String>, isTrue);
  });

  test('to Option if failure', () {
    final maybe = Failure<String>(new Exception('Failure...')).toOption();
    expect(maybe.isEmpty, isTrue);
    expect(maybe.isDefined, isFalse);
    expect(maybe is Option<String>, isTrue);
    expect(maybe is None, isTrue);
  });

  test('to Either if success', () {
    final maybe = Success("3.14").toEither();
    expect(maybe.isRight, isTrue);
    expect(maybe.isLeft, isFalse);
    expect(maybe is Either<Exception, String>, isTrue);
    expect(maybe is Right<Exception, String>, isTrue);
  });

  test('to Either if failure', () {
    final maybe = Failure<String>(new Exception('Failure...')).toEither();
    expect(maybe.isLeft, isTrue);
    expect(maybe.isRight, isFalse);
    expect(maybe is Either<Exception, String>, isTrue);
    expect(maybe is Left<Exception, String>, isTrue);
  });

  test('map Success', () {
    final maybe = Success<int>(1);
    final mapped = maybe.map((value) => value + 1);
    expect(mapped.getOrElse(100), 2);
    expect(mapped is Option<int>, isTrue);
  });

  test('map Failure', () {
    final maybe = Failure<int>(new Exception('Failure...'));
    final mapped = maybe.map((value) => value + 1);
    expect(mapped.getOrElse(100), 100);
    expect(mapped is Option<int>, isTrue);
  });

  test('map success async', () async {
    final maybe = Success<int>(1);
    final mapped = await maybe.mapAsync<String>((int value) async {
      return Some('map success async');
    });
    expect(mapped.getOrElse('map failure async'), 'map success async');
    expect(mapped is Option<String>, isTrue);
  });

  test('map left async', () async {
    final maybe = Failure<int>(new Exception('Failure...'));
    final mapped = await maybe.mapAsync<String>((int value) async {
      return Some('map success async');
    });
    expect(mapped.getOrElse('map failure async'), 'map failure async');
    expect(mapped is Option<String>, isTrue);
  });

  test('is success matching', () {
    final maybe = Success<int>(100);
    maybe.match((p0) {
      expect(p0, 100);
    }, (p0) {
      fail('should not be left');
    });
  });

  test('is failure matching', () {
    final maybe = Failure<String>(new Exception('has Error'));
    maybe.match((p0) {
      fail('should not be right');
    }, (p0) {
      expect(p0.toString(), 'Exception: has Error');
    });
  });

  test('is success matching async', () async {
    await (Success<int>(100)).matchAsync((p0) async {
      expect(p0, 100);
    }, (p0) async {
      fail('should not be left');
    });
  });

  test('is failure matching async', () async {
    await (Failure<String>(new Exception('has Error'))).matchAsync((p0) async {
      fail('should not be right');
    }, (p0) async {
      expect(p0.toString(), 'Exception: has Error');
    });
  });

  test('If the result is true when it exists', () {
    final maybe = Success<double>(3.14);
    expect(maybe.exists((p0) => p0 == 3.14), isTrue);
  });

  test('If false when the result does not exist', () {
    final maybe = Success<double>(3.14);
    expect(maybe.exists((p0) => p0 == 3.13), isFalse);
  });

  test('If Left, it will be false in any case.', () {
    final maybe = Failure<double>(new Exception());
    expect(maybe.exists((p0) {
      fail("If called, an error will occur.");
    }), isFalse);
  });

  test('recovery is do not work', () {
    final maybe = Success<String>("Success!");
    var ng = maybe.recover((p0) {
      fail('Do not work');
    });
    expect(ng is Try<String, Exception>, isTrue);
    expect(ng is Success<String>, isTrue);
    expect(ng is Failure<String>, isFalse);
  });

  test('recovery on failure', () {
    final maybe = Failure<String>(new Exception('has Error'));
    var ok = maybe.recover((p0) {
      expect(p0.toString(), 'Exception: has Error');
      expect(p0 is Exception, isTrue);
      return Success("ok");
    });
    expect(ok is Try<String, Exception>, isTrue);
    expect(ok is Success<String>, isTrue);
    expect(ok is Failure<String>, isFalse);
  });

  test('async recovery is do not work', () async {
    final maybe = Success<String>("Success!");
    var ng = await maybe.recoverAsync((p0) async {
      fail('Do not work');
    });
    expect(ng is Try<String, Exception>, isTrue);
    expect(ng is Success<String>, isTrue);
    expect(ng is Failure<String>, isFalse);
  });

  test('async recovery on failure', () async {
    final maybe = Failure<String>(new Exception('has Error'));
    var ok = await maybe.recoverAsync((p0) async {
      expect(p0.toString(), 'Exception: has Error');
      expect(p0 is Exception, isTrue);
      return Success("ok");
    });
    expect(ok is Try<String, Exception>, isTrue);
    expect(ok is Success<String>, isTrue);
    expect(ok is Failure<String>, isFalse);
  });
}
