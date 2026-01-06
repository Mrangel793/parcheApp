import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget de barra de progreso para el setup de perfil
/// Muestra el paso actual y un indicador visual
class ProfileProgressBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int totalSteps;

  const ProfileProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Paso $currentStep de $totalSteps',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF636E72),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4ECDC4), // Teal
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
