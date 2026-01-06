import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/user/domain/interests_constants.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/interest_chip.dart';

/// Grid de intereses con búsqueda y contador
/// Permite seleccionar entre 3 y 10 intereses
class InterestGrid extends StatefulWidget {
  final List<String> selectedInterestIds;
  final Function(String interestId) onToggleInterest;

  const InterestGrid({
    super.key,
    required this.selectedInterestIds,
    required this.onToggleInterest,
  });

  @override
  State<InterestGrid> createState() => _InterestGridState();
}

class _InterestGridState extends State<InterestGrid> {
  final TextEditingController _searchController = TextEditingController();
  List<Interest> _filteredInterests = InterestsConstants.allInterests;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterInterests);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInterests);
    _searchController.dispose();
    super.dispose();
  }

  void _filterInterests() {
    setState(() {
      _filteredInterests =
          InterestsConstants.searchInterests(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = widget.selectedInterestIds.length;
    final isMaxReached = selectedCount >= 10;
    final canProceed = selectedCount >= 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SearchBar
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar intereses...',
            hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF636E72),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF636E72)),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4ECDC4), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Contador
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$selectedCount/10 seleccionados',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: canProceed
                    ? const Color(0xFF4ECDC4)
                    : const Color(0xFF636E72),
              ),
            ),
            if (selectedCount < 3)
              Text(
                'Mínimo 3 intereses',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Grid de intereses
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: _filteredInterests.length,
          itemBuilder: (context, index) {
            final interest = _filteredInterests[index];
            final isSelected =
                widget.selectedInterestIds.contains(interest.id);
            final isDisabled = isMaxReached && !isSelected;

            return InterestChip(
              interest: interest,
              isSelected: isSelected,
              isDisabled: isDisabled,
              onTap: () => widget.onToggleInterest(interest.id),
            );
          },
        ),

        // Mensaje cuando no hay resultados
        if (_filteredInterests.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 48,
                    color: Color(0xFFB2BEC3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No se encontraron intereses',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
