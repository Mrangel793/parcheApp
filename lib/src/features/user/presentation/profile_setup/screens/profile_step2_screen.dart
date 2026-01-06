import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/controllers/profile_step2_controller.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/interest_grid.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/profile_progress_bar.dart';

/// Pantalla del Paso 2: Selección de Intereses
/// Permite seleccionar entre 3 y 10 intereses
/// Este paso es opcional (se puede saltar)
class ProfileStep2Screen extends ConsumerStatefulWidget {
  const ProfileStep2Screen({super.key});

  @override
  ConsumerState<ProfileStep2Screen> createState() =>
      _ProfileStep2ScreenState();
}

class _ProfileStep2ScreenState extends ConsumerState<ProfileStep2Screen> {
  /// Maneja el guardado de intereses
  Future<void> _handleSave() async {
    await ref.read(profileStep2ControllerProvider.notifier).saveInterests();
  }

  /// Maneja el saltar este paso
  Future<void> _handleSkip() async {
    await ref.read(profileStep2ControllerProvider.notifier).skipStep();
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
    final state = ref.watch(profileStep2ControllerProvider);
    final controller = ref.read(profileStep2ControllerProvider.notifier);

    // Escuchar cambios en el estado
    ref.listen<ProfileStep2State>(
      profileStep2ControllerProvider,
      (previous, next) {
        // Mostrar error si existe
        if (next.errorMessage != null) {
          _showError(next.errorMessage!);
          controller.clearError();
        }

        // Navegar al siguiente paso en caso de éxito
        if (next.isSuccess) {
          _showSuccess('Intereses guardados correctamente');
          context.go('/profile/step-3');
        }
      },
    );

    final selectedCount = state.selectedInterests.length;
    final canProceed = controller.canProceed();
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
              '¿Qué te gusta hacer?',
              'Selecciona entre 3 y 10 intereses que te representen',
            ),
            const SizedBox(height: 24),

            // Grid de intereses
            InterestGrid(
              selectedInterestIds: state.selectedInterests,
              onToggleInterest: (interestId) {
                controller.toggleInterest(interestId);
              },
            ),
            const SizedBox(height: 32),

            // Botones de acción
            _buildActionButtons(canProceed, isLoading),
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
        'Tus intereses',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      bottom: const ProfileProgressBar(
        currentStep: 2,
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

  Widget _buildActionButtons(bool canProceed, bool isLoading) {
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

        // Botón Continuar
        Expanded(
          flex: 2,
          child: _buildContinueButton(canProceed, isLoading),
        ),
      ],
    );
  }

  Widget _buildContinueButton(bool canProceed, bool isLoading) {
    final bool isEnabled = canProceed && !isLoading;

    return InkWell(
      onTap: isEnabled ? _handleSave : null,
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
              : Text(
                  'Continuar',
                  style: GoogleFonts.poppins(
                    color: isEnabled ? Colors.white : Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
