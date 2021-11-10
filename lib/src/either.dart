import 'package:error_handling_extension/src/option.dart';

abstract class Either<L, R> {
  L? _left;
  R? _right;
  bool get isRight => this is Right<L, R>;
  bool get isLeft => this is Left<L, R>;
  L? get left => _left;
  R? get right => _right;

  R getOrElse(R orElse) => isRight ? _right! : orElse;

  Option<T> map<T>(T Function(R) f) {
    if (_right != null) {
      return Some(f(_right!));
    } else {
      return None();
    }
  }

  Future<Option<T>> mapAsync<T>(Future<Option<T>> Function(R) f) async =>
      isLeft ? Future.value(None()) : Future.value(await f(_right!));

  void match<T>(Function(R) fR, Function(L) fL) =>
      isLeft ? fL(_left!) : fR(_right!);

  Future<void> matchAsync<T>(
          Future<void> Function(R) fR, Future<void> Function(L) fL) async =>
      isLeft ? await fL(_left!) : await fR(_right!);

  Either<R, L> swap() => throw ('The method is not overridden');
}

class Left<L, R> extends Either<L, R> {
  Left(L left) {
    _left = left;
  }

  @override
  Either<R, L> swap() {
    return Right(_left!);
  }
}

class Right<L, R> extends Either<L, R> {
  Right(R right) {
    _right = right;
  }

  @override
  Either<R, L> swap() {
    return Left(_right!);
  }
}
