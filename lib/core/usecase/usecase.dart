// CORE - usecase.dart
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
