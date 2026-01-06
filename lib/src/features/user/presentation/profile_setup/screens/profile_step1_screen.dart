import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/controllers/profile_step1_controller.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/city_autocomplete_field.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/photo_picker_widget.dart';
import 'package:myapp/src/features/user/presentation/profile_setup/widgets/profile_progress_bar.dart';

/// Pantalla del Paso 1: Información Básica
/// Campos obligatorios: Ciudad, Edad (18-100), Foto de perfil
class ProfileStep1Screen extends ConsumerStatefulWidget {
  const ProfileStep1Screen({super.key});

  @override
  ConsumerState<ProfileStep1Screen> createState() => _ProfileStep1ScreenState();
}

class _ProfileStep1ScreenState extends ConsumerState<ProfileStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _edadController = TextEditingController();

  String? _selectedCity;
  String? _selectedPlaceId;
  File? _profilePhoto;
  int? _edad;

  @override
  void dispose() {
    _edadController.dispose();
    super.dispose();
  }

  /// Verifica si el formulario es válido
  bool get _isFormValid {
    return _selectedCity != null &&
        _selectedCity!.isNotEmpty &&
        _profilePhoto != null &&
        _edad != null &&
        _edad! >= 18 &&
        _edad! <= 100;
  }

  /// Maneja el submit del formulario
  Future<void> _handleSubmit() async {
    if (!_isFormValid) return;

    await ref.read(profileStep1ControllerProvider.notifier).saveBasicInfo(
          ciudad: _selectedCity!,
          edad: _edad!,
          profilePhoto: _profilePhoto!,
        );
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
    // Escuchar cambios en el estado del controller
    ref.listen<ProfileStep1State>(
      profileStep1ControllerProvider,
      (previous, next) {
        next.when(
          initial: () {},
          loading: () {},
          success: () {
            _showSuccess('Información guardada correctamente');
            // Navegar al siguiente paso
            context.go('/profile/step-2');
          },
          error: (message) {
            _showError(message);
          },
        );
      },
    );

    final state = ref.watch(profileStep1ControllerProvider);
    final isLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Cuéntanos sobre ti',
                'Necesitamos algunos datos básicos para crear tu perfil',
              ),
              const SizedBox(height: 32),

              // Foto de perfil
              PhotoPickerWidget(
                currentPhoto: _profilePhoto,
                onPhotoSelected: (photo) {
                  setState(() {
                    _profilePhoto = photo;
                  });
                },
                size: 150,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Foto de perfil *',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Ciudad
              CityAutocompleteField(
                initialValue: _selectedCity,
                onCitySelected: (cityName, placeId) {
                  setState(() {
                    _selectedCity = cityName;
                    _selectedPlaceId = placeId;
                  });
                },
                // TODO: Reemplazar con tu API Key de Google Places
                googleApiKey: 'YOUR_GOOGLE_API_KEY_HERE',
              ),
              const SizedBox(height: 24),

              // Edad
              _buildEdadField(),
              const SizedBox(height: 32),

              // Botón Continuar
              _buildContinueButton(isLoading),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Completa tu perfil',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      bottom: const ProfileProgressBar(
        currentStep: 1,
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

  Widget _buildEdadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edad',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _edadController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: InputDecoration(
            hintText: 'Ingresa tu edad',
            hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
            prefixIcon: const Icon(
              Icons.cake_outlined,
              color: Color(0xFF636E72),
            ),
            suffixIcon: _edad != null && _edad! >= 18 && _edad! <= 100
                ? const Icon(Icons.check_circle, color: Colors.green)
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _edad = null;
              } else {
                final parsedValue = int.tryParse(value);
                _edad = parsedValue;
              }
            });
          },
        ),
        const SizedBox(height: 4),
        Text(
          'Debes tener al menos 18 años',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF636E72),
          ),
        ),
        if (_edad != null && (_edad! < 18 || _edad! > 100))
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'La edad debe estar entre 18 y 100 años',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContinueButton(bool isLoading) {
    final bool isEnabled = _isFormValid && !isLoading;

    return InkWell(
      onTap: isEnabled ? _handleSubmit : null,
      child: Container(
        height: 56,
        width: double.infinity,
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
