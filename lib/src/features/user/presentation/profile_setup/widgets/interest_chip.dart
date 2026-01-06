import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/user/domain/interests_constants.dart';

/// Chip interactivo para representar un interés
/// Muestra ícono, nombre y estado de selección
class InterestChip extends StatelessWidget {
  final Interest interest;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDisabled;

  const InterestChip({
    super.key,
    required this.interest,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      interest.color,
                      interest.color.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: interest.color.withAlpha(64),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícono
                Icon(
                  interest.icon,
                  size: 32,
                  color: isSelected ? Colors.white : interest.color,
                ),
                const SizedBox(height: 8),

                // Nombre
                Text(
                  interest.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF2D3436),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Checkmark si está seleccionado
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: interest.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
