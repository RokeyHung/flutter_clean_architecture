import 'package:flutter_clean_architecture/core/clean/presenter.dart';
import 'package:flutter_clean_architecture/core/clean/use_case.dart';

abstract class Interactor<T extends UseCaseOutput, Input extends UseCaseInput> {
  Interactor(this.presenter);

  final Presenter<T> presenter;

  Future<void> call(Input input);

  void send({required T output}) {
    presenter.present(response: output);
  }
}
