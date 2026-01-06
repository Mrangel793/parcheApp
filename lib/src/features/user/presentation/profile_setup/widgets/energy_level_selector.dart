import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/user/domain/user_model.dart';

/// Widget selector visual para el nivel de energía social
/// Muestra 3 cards interactivos: Bajo, Medio, Alto
class EnergyLevelSelector extends StatelessWidget {
  final EnergyLevel? selectedLevel;
  final Function(EnergyLevel) onLevelSelected;

  const EnergyLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEnergyCard(
          level: EnergyLevel.baja,
          icon: Icons.self_improvement,
          title: 'BAJO',
          description: 'Prefiero planes tranquilos y grupos pequeños',
          color: const Color(0xFF74B9FF), // Azul claro
          isSelected: selectedLevel == EnergyLevel.baja,
        ),
        const SizedBox(height: 16),
        _buildEnergyCard(
          level: EnergyLevel.media,
          icon: Icons.thumb_up,
          title: 'MEDIO',
          description: 'Balance entre planes relajados y activos',
          color: const Color(0xFF4ECDC4), // Teal
          isSelected: selectedLevel == EnergyLevel.media,
        ),
        const SizedBox(height: 16),
        _buildEnergyCard(
          level: EnergyLevel.alta,
          icon: Icons.local_fire_department,
          title: 'ALTO',
          description: 'Me encanta la acción y conocer mucha gente',
          color: const Color(0xFFFF6B9D), // Rosa
          isSelected: selectedLevel == EnergyLevel.alta,
        ),
      ],
    );
  }

  Widget _buildEnergyCard({
    required EnergyLevel level,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onLevelSelected(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE0E0E0),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(64),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Ícono
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFFF8F9FA),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFFB2BEC3),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : const Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),

              // Checkmark
              if (isSelected)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
