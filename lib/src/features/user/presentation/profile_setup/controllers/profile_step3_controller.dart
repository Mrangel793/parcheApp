import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/user/data/user_repository.dart';
import 'package:myapp/src/features/user/domain/user_model.dart';

part 'profile_step3_controller.freezed.dart';

/// Estado del ProfileStep3Controller
@freezed
class ProfileStep3State with _$ProfileStep3State {
  const factory ProfileStep3State({
    EnergyLevel? selectedLevel,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isSuccess,
  }) = _ProfileStep3State;
}

/// Controller para el paso 3 del perfil (Nivel de Energía)
/// Maneja la selección del nivel de energía social
class ProfileStep3Controller extends StateNotifier<ProfileStep3State> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  ProfileStep3Controller(
    this._userRepository,
    this._authRepository,
  ) : super(const ProfileStep3State());

  /// Selecciona un nivel de energía
  void selectEnergyLevel(EnergyLevel level) {
    state = state.copyWith(
      selectedLevel: level,
      errorMessage: null,
    );
  }

  /// Guarda el nivel de energía seleccionado y finaliza el setup
  Future<void> saveAndFinish() async {
    // Validar que se haya seleccionado un nivel
    if (state.selectedLevel == null) {
      state = state.copyWith(
        errorMessage: 'Debes seleccionar un nivel de energía',
      );
      return;
    }

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Obtener usuario actual
      final currentUser = _authRepository.currentUser;
      if (currentUser == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No hay usuario autenticado',
        );
        return;
      }

      // Guardar nivel de energía
      await _userRepository.updateEnergyLevel(
        currentUser.uid,
        state.selectedLevel!,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
    } on UserRepositoryException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado al guardar: ${e.toString()}',
      );
    }
  }

  /// Salta este paso y usa el valor por defecto (media)
  Future<void> skipAndFinish() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Obtener usuario actual
      final currentUser = _authRepository.currentUser;
      if (currentUser == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No hay usuario autenticado',
        );
        return;
      }

      // Guardar nivel de energía por defecto (media)
      await _userRepository.updateEnergyLevel(
        currentUser.uid,
        EnergyLevel.media,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al saltar paso: ${e.toString()}',
      );
    }
  }

  /// Limpia el mensaje de error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reinicia el estado
  void reset() {
    state = const ProfileStep3State();
  }
}

/// Provider del ProfileStep3Controller
final profileStep3ControllerProvider =
    StateNotifierProvider.autoDispose<ProfileStep3Controller, ProfileStep3State>(
  (ref) {
    return ProfileStep3Controller(
      ref.watch(userRepositoryProvider),
      ref.watch(authRepositoryProvider),
    );
  },
);
