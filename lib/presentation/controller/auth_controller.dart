import 'package:flutter_clean_architecture/data/model/body/auth_body.dart';
import 'package:flutter_clean_architecture/domain/use_case/auth/register_use_case.dart';
import 'package:flutter_clean_architecture/presentation/state/register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  late final RegisterUseCase _registerUseCase;

  @override
  RegisterState build() {
    _registerUseCase = ref.watch(registerUseCaseProvider);
    return const RegisterState();
  }

  void onChanged({
    String? email,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    bool? agreedToPolicy,
  }) {
    state = state.copyWith(
      email: email ?? state.email,
      password: password ?? state.password,
      confirmPassword: confirmPassword ?? state.confirmPassword,
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      agreedToPolicy: agreedToPolicy ?? state.agreedToPolicy,
    );
  }

  Future<void> submit() async {
    if (!state.agreedToPolicy) {
      state = state.copyWith(errorMessage: 'Bạn phải đồng ý với chính sách.');
      return;
    }

    if (state.password != state.confirmPassword) {
      state = state.copyWith(errorMessage: 'Mật khẩu không khớp.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _registerUseCase.execute(
      body: RegisterBody(
        email: state.email,
        password: state.password,
        firstName: state.firstName,
        lastName: state.lastName,
      ),
      agreedToPolicy: state.agreedToPolicy,
    );

    result.when(
      success: (auth) {
        state = state.copyWith(isLoading: false);
        // có thể lưu token hoặc chuyển màn hình
      },
      failure: (e, _) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      },
    );
  }
}
