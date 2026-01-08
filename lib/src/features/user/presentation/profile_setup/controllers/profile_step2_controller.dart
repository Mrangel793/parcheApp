import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/auth/provider/auth_provider.dart';
import 'package:myapp/src/features/user/data/user_repository.dart';

part 'profile_step2_controller.freezed.dart';

/// Estado del ProfileStep2Controller
@freezed
class ProfileStep2State with _$ProfileStep2State {
  const factory ProfileStep2State({
    @Default([]) List<String> selectedInterests,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isSuccess,
  }) = _ProfileStep2State;
}

/// Controller para el paso 2 del perfil (Intereses)
/// Maneja la selección de intereses (min 3, max 10)
class ProfileStep2Controller extends StateNotifier<ProfileStep2State> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  ProfileStep2Controller(
    this._userRepository,
    this._authRepository,
  ) : super(const ProfileStep2State());

  /// Agrega o quita un interés de la lista de seleccionados
  void toggleInterest(String interestId) {
    final currentInterests = List<String>.from(state.selectedInterests);

    if (currentInterests.contains(interestId)) {
      // Quitar interés
      currentInterests.remove(interestId);
    } else {
      // Agregar interés solo si no se ha alcanzado el máximo
      if (currentInterests.length < 10) {
        currentInterests.add(interestId);
      } else {
        // Mostrar error si se intenta agregar más de 10
        state = state.copyWith(
          errorMessage: 'Solo puedes seleccionar hasta 10 intereses',
        );
        return;
      }
    }

    state = state.copyWith(
      selectedInterests: currentInterests,
      errorMessage: null,
    );
  }

  /// Verifica si se puede continuar (mínimo 3 intereses)
  bool canProceed() {
    return state.selectedInterests.length >= 3;
  }

  /// Guarda los intereses seleccionados
  Future<void> saveInterests() async {
    // Validar que haya al menos 3 intereses
    if (!canProceed()) {
      state = state.copyWith(
        errorMessage: 'Debes seleccionar al menos 3 intereses',
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

      // Guardar intereses
      await _userRepository.updateInterests(
        currentUser.uid,
        state.selectedInterests,
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
        errorMessage: 'Error inesperado al guardar intereses: ${e.toString()}',
      );
    }
  }

  /// Salta este paso (guarda lista vacía)
  Future<void> skipStep() async {
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

      // Guardar lista vacía
      await _userRepository.updateInterests(currentUser.uid, []);

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
    state = const ProfileStep2State();
  }
}

/// Provider del ProfileStep2Controller
final profileStep2ControllerProvider =
    StateNotifierProvider.autoDispose<ProfileStep2Controller, ProfileStep2State>(
  (ref) {
    return ProfileStep2Controller(
      ref.watch(userRepositoryProvider),
      ref.watch(authRepositoryProvider),
    );
  },
);
