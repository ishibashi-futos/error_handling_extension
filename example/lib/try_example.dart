import 'package:functional_error_handling_dart/functional_error_handling_dart.dart';

Future<void> main() async {
  var parsed1 = parseInt("1000");
  print(parsed1.isSuccess); // true
  print(parsed1.getOrElse(1000)); // 2000
  var parsed2 = parseInt("#2000");
  print(parsed2.isFailure); // true
  print(parsed2.getOrElse(1000)); // 1000
  print(parsed2.recover((p0) => Success(0))); // Instance of 'Success<int>'
}

Try<int, Exception> parseInt(String source) {
  try {
    return Success(int.parse(source));
  } on FormatException catch (e) {
    return Failure(e);
  }
}
