import 'package:flutter_clean_architecture/core/clean/use_case.dart';

abstract class Presenter<T extends UseCaseOutput> {
  void present({required T response});
}
