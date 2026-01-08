import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget de autocomplete para ciudades usando Google Places API
/// Filtra solo resultados de tipo ciudad
class CityAutocompleteField extends StatefulWidget {
  final String? initialValue;
  final Function(String cityName, String? placeId) onCitySelected;
  final String? googleApiKey;

  const CityAutocompleteField({
    super.key,
    this.initialValue,
    required this.onCitySelected,
    this.googleApiKey,
  });

  @override
  State<CityAutocompleteField> createState() => _CityAutocompleteFieldState();
}

class _CityAutocompleteFieldState extends State<CityAutocompleteField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ciudad',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Google Places Autocomplete
        GooglePlaceAutoCompleteTextField(
          textEditingController: _controller,
          googleAPIKey: widget.googleApiKey ?? 'AIzaSyAZSgqUXXP9bk9SdbrnB0NUIF5siaS5614',
          inputDecoration: InputDecoration(
            hintText: 'Busca tu ciudad...',
            hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
            prefixIcon: const Icon(
              Icons.location_city,
              color: Color(0xFF636E72),
            ),
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
          debounceTime: 300,
          isLatLngRequired: false,
          itemClick: (Prediction prediction) {
            _controller.text = prediction.description ?? '';
            widget.onCitySelected(
              prediction.description ?? '',
              prediction.placeId,
            );
          },
          getPlaceDetailWithLatLng: (prediction) {
            // Callback opcional para obtener detalles completos
            print('Lugar seleccionado: ${prediction.description}');
          },
        ),

        // Mensaje de ayuda
        const SizedBox(height: 4),
        Text(
          'Escribe el nombre de tu ciudad',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF636E72),
          ),
        ),
      ],
    );
  }
}
