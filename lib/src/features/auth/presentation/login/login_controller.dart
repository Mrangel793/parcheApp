import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/auth/provider/auth_provider.dart';

part 'login_controller.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success() = _Success;
  const factory LoginState.error(String message) = _Error;
}

class LoginController extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginController(this._authRepository) : super(const LoginState.initial());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const LoginState.loading();
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      state = const LoginState.success();
    } on AuthException catch (e) {
      state = LoginState.error(e.message);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const LoginState.loading();
    try {
      await _authRepository.signInWithGoogle();
      state = const LoginState.success();
    } on AuthException catch (e) {
      state = LoginState.error(e.message);
    }
  }

  Future<void> signInWithApple() async {
    state = const LoginState.loading();
    try {
      await _authRepository.signInWithApple();
      state = const LoginState.success();
    } on AuthException catch (e) {
      state = LoginState.error(e.message);
    }
  }
}

final loginControllerProvider = StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
  return LoginController(ref.watch(authRepositoryProvider));
});
