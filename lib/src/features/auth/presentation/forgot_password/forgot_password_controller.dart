import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';

part 'forgot_password_controller.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState.initial() = _Initial;
  const factory ForgotPasswordState.loading() = _Loading;
  const factory ForgotPasswordState.success() = _Success;
  const factory ForgotPasswordState.error(String message) = _Error;
}

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordController(this._authRepository) : super(const ForgotPasswordState.initial());

  Future<void> sendPasswordResetEmail(String email) async {
    state = const ForgotPasswordState.loading();
    try {
      await _authRepository.resetPassword(email);
      state = const ForgotPasswordState.success();
    } on AuthException catch (e) {
      state = ForgotPasswordState.error(e.toString());
    } 
  }
}

final forgotPasswordControllerProvider = StateNotifierProvider.autoDispose<ForgotPasswordController, ForgotPasswordState>((ref) {
  return ForgotPasswordController(ref.watch(authRepositoryProvider));
});
