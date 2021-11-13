import 'package:functional_error_handling_dart/src/option.dart';
import 'package:functional_error_handling_dart/src/either.dart';

abstract class Try<S, E extends Exception> {
  late final E _failed;
  late final S _success;

  // True if failure.
  bool get isFailure => this is Failure<S>;
  // True if success.
  bool get isSuccess => this is Success<S>;

  // get value or else.
  S getOrElse(S orElse) => isFailure ? orElse : _success!;

  // transform into option.
  Option<S> toOption() => isFailure ? None() : Some(_success!);
  // transform into either.
  Either<E, S> toEither() => isFailure ? Left(_failed) : Right(_success);

  // transform value.
  Option<T> map<T>(T Function(S) f) => isFailure ? None() : Some(f(_success!));

  // transform value async.
  Future<Option<T>> mapAsync<T>(Future<Option<T>> Function(S) f) =>
      isFailure ? Future.value(None()) : f(_success!);

  // pattern match.
  void match(Function(S) fR, Function(E) fL) =>
      isFailure ? fL(_failed) : fR(_success);

  // pattern match async.
  Future<void> matchAsync(
          Future<void> Function(S) fS, Future<void> Function(E) fE) async =>
      isFailure ? await fE(_failed) : await fS(_success);

  // the value exists or not.
  bool exists(bool Function(S) fS) => isFailure ? false : fS(_success!);

  // recover if it fails.
  Try<S, E> recover(Try<S, E> Function(E) pf) => isSuccess ? this : pf(_failed);

  // async recover if it fails.
  Future<Try<S, E>> recoverAsync(Future<Try<S, E>> Function(E) pf) =>
      isSuccess ? Future.value(this) : pf(_failed);
}

class Success<S> extends Try<S, Exception> {
  Success(S s) {
    this._success = s;
  }
}

class Failure<S> extends Try<S, Exception> {
  Failure(Exception e) {
    this._failed = e;
  }
}
