import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

enum PasswordStrength {
  none,
  weak,
  medium,
  strong
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEmailValid = false;
  bool _passwordsMatch = false;
  bool _termsAccepted = false;

  bool _hasMin8Chars = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  PasswordStrength _passwordStrength = PasswordStrength.none;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (isValid != _isEmailValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMin8Chars = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      int strengthScore = 0;
      if (_hasMin8Chars) strengthScore++;
      if (_hasUppercase) strengthScore++;
      if (_hasNumber) strengthScore++;
      if (_hasSpecialChar) strengthScore++;

      if (strengthScore < 2) {
        _passwordStrength = PasswordStrength.weak;
      } else if (strengthScore < 4) {
        _passwordStrength = PasswordStrength.medium;
      } else {
        _passwordStrength = PasswordStrength.strong;
      }
      if (password.isEmpty) {
         _passwordStrength = PasswordStrength.none;
      }

       _validateConfirmPassword();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _passwordsMatch = _passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text;
    });
  }

  bool get _isContinueButtonEnabled {
    return _isEmailValid &&
        _passwordsMatch &&
        _termsAccepted &&
        _passwordStrength == PasswordStrength.strong &&
        _nameController.text.isNotEmpty;
  }

  Future<void> _submit() async {
    if (_isContinueButtonEnabled) {
      try {
        await ref.read(authRepositoryProvider).signUp(
              email: _emailController.text,
              password: _passwordController.text,
              displayName: _nameController.text,
            );
        // GoRouter redirect will handle navigation
      } on AuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildSectionHeader('Información básica', 'Empecemos con los datos esenciales.'),
              const SizedBox(height: 24),
              _buildTextFormField(
                controller: _nameController,
                label: 'Nombre completo',
                hint: 'Juan Pérez',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 24),
              _buildTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'planit@app.com',
                  icon: Icons.mail_outline,
                  suffixIcon: _isEmailValid
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null),
              const SizedBox(height: 24),
              _buildPasswordSection(),
              const SizedBox(height: 24),
               _buildTextFormField(
                controller: _confirmPasswordController,
                label: 'Confirmar contraseña',
                hint: '········',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
                suffixIcon: _confirmPasswordController.text.isEmpty
                    ? null
                    : Icon(
                        _passwordsMatch ? Icons.check_circle : Icons.cancel,
                        color: _passwordsMatch ? Colors.green : Colors.red,
                      ),
              ),
              const SizedBox(height: 24),
              _buildTermsAndConditions(),
              const SizedBox(height: 32),
              _buildContinueButton(),
              const SizedBox(height: 32),
              _buildFooter(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Crear cuenta',
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Paso 1 de 3', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              const LinearProgressIndicator(
                value: 0.33,
                backgroundColor: Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF2D3436)),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF636E72)),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF2D3436), fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB2BEC3)),
            prefixIcon: Icon(icon, color: const Color(0xFF636E72)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
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
          validator: (value) => (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
          onChanged: (_) => setState(() {}), // Re-render to update button state
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      children: [
         _buildTextFormField(
          controller: _passwordController,
          label: 'Contraseña',
          hint: '········',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 16),
        _buildPasswordRequirements(),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    Color strengthColor;
    String strengthText;
    double strengthValue;

    switch (_passwordStrength) {
      case PasswordStrength.weak:
        strengthValue = 0.25;
        strengthColor = Colors.red;
        strengthText = 'Débil';
        break;
      case PasswordStrength.medium:
        strengthValue = 0.6;
        strengthColor = Colors.orange;
        strengthText = 'Media';
        break;
      case PasswordStrength.strong:
        strengthValue = 1.0;
        strengthColor = Colors.green;
        strengthText = 'Fuerte';
        break;
      case PasswordStrength.none:
        strengthValue = 0;
        strengthColor = Colors.transparent;
        strengthText = '';
        break;
    }

    return Column(
      children: [
        LinearProgressIndicator(
          value: strengthValue,
          backgroundColor: const Color(0xFFE0E0E0),
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
          minHeight: 6,
        ),
        if (_passwordStrength != PasswordStrength.none)
          Align(
            alignment: Alignment.centerRight,
            child: Text(strengthText, style: TextStyle(color: strengthColor, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRequirementRow(_hasMin8Chars, 'Mínimo 8 caracteres'),
          _buildRequirementRow(_hasUppercase, 'Una mayúscula'),
          _buildRequirementRow(_hasNumber, 'Un número'),
          _buildRequirementRow(_hasSpecialChar, 'Un carácter especial'),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(bool isMet, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            color: isMet ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: isMet ? Colors.black : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (value) => setState(() => _termsAccepted = value!),
          activeColor: const Color(0xFF4ECDC4),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(text: 'Acepto los '),
                TextSpan(
                  text: 'términos y condiciones',
                  style: const TextStyle(color: Color(0xFF4ECDC4), decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () { /* Navigate to Terms */ },
                ),
                const TextSpan(text: ' y la '),
                 TextSpan(
                  text: 'política de privacidad',
                  style: const TextStyle(color: Color(0xFF4ECDC4), decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () { /* Navigate to Privacy */ },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return InkWell(
      onTap: _isContinueButtonEnabled ? _submit : null,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _isContinueButtonEnabled
              ? const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF55E1D5)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: _isContinueButtonEnabled ? null : Colors.grey.shade300,
          boxShadow: _isContinueButtonEnabled ? [
            BoxShadow(
              color: const Color(0xFF4ECDC4).withAlpha(77),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ] : [],
        ),
        child: Center(
          child: Text(
            'Continuar',
            style: GoogleFonts.poppins(
              color: _isContinueButtonEnabled ? Colors.white : Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
          children: [
            const TextSpan(text: '¿Ya tienes cuenta? '),
            TextSpan(
              text: 'Inicia sesión',
              style: const TextStyle(color: Color(0xFF4ECDC4), fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
