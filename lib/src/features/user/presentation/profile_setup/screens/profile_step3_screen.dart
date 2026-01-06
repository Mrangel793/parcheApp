import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/user/domain/user_model.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/controllers/profile_step3_controller.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/energy_level_selector.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/profile_progress_bar.dart';

/// Pantalla del Paso 3: Nivel de Energía Social
/// Permite seleccionar entre 3 niveles: Bajo, Medio, Alto
/// Este paso es opcional (se puede saltar)
class ProfileStep3Screen extends ConsumerStatefulWidget {
  const ProfileStep3Screen({super.key});

  @override
  ConsumerState<ProfileStep3Screen> createState() =>
      _ProfileStep3ScreenState();
}

class _ProfileStep3ScreenState extends ConsumerState<ProfileStep3Screen> {
  /// Maneja el guardado del nivel de energía
  Future<void> _handleFinish() async {
    await ref.read(profileStep3ControllerProvider.notifier).saveAndFinish();
  }

  /// Maneja el saltar este paso (guarda nivel medio por defecto)
  Future<void> _handleSkip() async {
    await ref.read(profileStep3ControllerProvider.notifier).skipAndFinish();
  }

  /// Muestra un SnackBar con mensaje de error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra un SnackBar con mensaje de éxito
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileStep3ControllerProvider);
    final controller = ref.read(profileStep3ControllerProvider.notifier);

    // Escuchar cambios en el estado
    ref.listen<ProfileStep3State>(
      profileStep3ControllerProvider,
      (previous, next) {
        // Mostrar error si existe
        if (next.errorMessage != null) {
          _showError(next.errorMessage!);
          controller.clearError();
        }

        // Navegar al Home en caso de éxito
        if (next.isSuccess) {
          _showSuccess('¡Perfil completado exitosamente!');
          // Ir al Home (ruta raíz)
          context.go('/');
        }
      },
    );

    final hasSelection = state.selectedLevel != null;
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              '¿Cómo te describes?',
              'Esto nos ayudará a sugerirte mejores planes',
            ),
            const SizedBox(height: 32),

            // Selector de nivel de energía
            EnergyLevelSelector(
              selectedLevel: state.selectedLevel,
              onLevelSelected: (level) {
                controller.selectEnergyLevel(level);
              },
            ),
            const SizedBox(height: 32),

            // Botones de acción
            _buildActionButtons(hasSelection, isLoading),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Nivel de energía',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      bottom: const ProfileProgressBar(
        currentStep: 3,
        totalSteps: 3,
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF636E72),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool hasSelection, bool isLoading) {
    return Row(
      children: [
        // Botón Saltar
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: isLoading ? null : _handleSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
            child: Text(
              'Saltar',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isLoading
                    ? Colors.grey.shade400
                    : const Color(0xFF636E72),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Botón Finalizar
        Expanded(
          flex: 2,
          child: _buildFinishButton(hasSelection, isLoading),
        ),
      ],
    );
  }

  Widget _buildFinishButton(bool hasSelection, bool isLoading) {
    // El botón siempre está habilitado, solo se deshabilita durante loading
    final bool isEnabled = !isLoading;

    return InkWell(
      onTap: isEnabled ? _handleFinish : null,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF55E1D5)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isEnabled ? null : Colors.grey.shade300,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withAlpha(77),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Finalizar',
                      style: GoogleFonts.poppins(
                        color: isEnabled ? Colors.white : Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_circle_outline,
                      color: isEnabled ? Colors.white : Colors.grey.shade600,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
