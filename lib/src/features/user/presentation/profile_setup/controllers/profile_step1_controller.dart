import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/auth/provider/auth_provider.dart';
import 'package:myapp/src/features/user/data/user_repository.dart';

part 'profile_step1_controller.freezed.dart';

/// Estados del ProfileStep1Controller
@freezed
class ProfileStep1State with _$ProfileStep1State {
  const factory ProfileStep1State.initial() = _Initial;
  const factory ProfileStep1State.loading() = _Loading;
  const factory ProfileStep1State.success() = _Success;
  const factory ProfileStep1State.error(String message) = _Error;
}

/// Controller para el paso 1 del perfil (Info Básica)
/// Maneja: ciudad, edad y foto de perfil
class ProfileStep1Controller extends StateNotifier<ProfileStep1State> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  ProfileStep1Controller(
    this._userRepository,
    this._authRepository,
  ) : super(const ProfileStep1State.initial());

  /// Guarda la información básica del perfil
  /// Valida que todos los campos estén completos antes de guardar
  Future<void> saveBasicInfo({
    required String ciudad,
    required int edad,
    required File profilePhoto,
  }) async {
    // Validaciones
    if (ciudad.isEmpty) {
      state = const ProfileStep1State.error('La ciudad es obligatoria');
      return;
    }

    if (edad < 18 || edad > 100) {
      state = const ProfileStep1State.error('La edad debe estar entre 18 y 100 años');
      return;
    }

    try {
      state = const ProfileStep1State.loading();

      // Obtener usuario actual
      final currentUser = _authRepository.currentUser;
      if (currentUser == null) {
        state = const ProfileStep1State.error('No hay usuario autenticado');
        return;
      }

      // Guardar información básica usando el UserRepository
      await _userRepository.updateBasicInfo(
        userId: currentUser.uid,
        ciudad: ciudad,
        edad: edad,
        profilePhoto: profilePhoto,
      );

      state = const ProfileStep1State.success();
    } on UserRepositoryException catch (e) {
      state = ProfileStep1State.error(e.message);
    } catch (e) {
      state = ProfileStep1State.error(
        'Error inesperado al guardar la información: ${e.toString()}',
      );
    }
  }

  /// Reinicia el estado a inicial
  void reset() {
    state = const ProfileStep1State.initial();
  }
}

/// Provider del ProfileStep1Controller
final profileStep1ControllerProvider =
    StateNotifierProvider.autoDispose<ProfileStep1Controller, ProfileStep1State>(
  (ref) {
    return ProfileStep1Controller(
      ref.watch(userRepositoryProvider),
      ref.watch(authRepositoryProvider),
    );
  },
);
