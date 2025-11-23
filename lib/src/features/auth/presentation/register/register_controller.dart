import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/auth/data/database_repository.dart';
import 'package:myapp/src/features/auth/domain/app_user.dart';

part 'register_controller.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.loading() = _Loading;
  const factory RegisterState.success() = _Success;
  const factory RegisterState.error(String message) = _Error;
}

class RegisterController extends StateNotifier<RegisterState> {
  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;

  RegisterController(this._authRepository, this._databaseRepository) : super(const RegisterState.initial());

  Future<void> registerWithEmailAndPassword(String email, String password, String name) async {
    state = const RegisterState.loading();
    try {
      final userCredential = await _authRepository.signUp(email: email, password: password, displayName: name);
      final user = userCredential.user;
      if (user != null) {
        final appUser = AppUser(uid: user.uid, email: user.email, displayName: name);
        await _databaseRepository.createUser(appUser);
      }
      state = const RegisterState.success();
    } on AuthException catch (e) {
      state = RegisterState.error(e.toString());
    }
  }
}

final registerControllerProvider =
    StateNotifierProvider.autoDispose<RegisterController, RegisterState>((ref) {
  return RegisterController(ref.watch(authRepositoryProvider), ref.watch(databaseRepositoryProvider));
});
