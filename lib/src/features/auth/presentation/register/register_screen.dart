import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/auth/provider/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authRepositoryProvider).signUp(
              email: _emailController.text,
              password: _passwordController.text,
              displayName: _nameController.text,
            );
        // Navigate to profile setup
        if (mounted) {
          context.go('/profile/step-1');
        }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            _buildHeader(),
            _buildForm(),
            const SizedBox(height: 32),
            _buildFooter(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Text(
            'Crea tu cuenta',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Únete para empezar a planificar',
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(38),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(
              controller: _nameController,
              label: 'Nombre',
              hint: 'Tu nombre',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _emailController,
              label: 'Email',
              hint: 'tu@email.com',
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _passwordController,
              label: 'Contraseña',
              hint: 'Crea una contraseña segura',
              icon: Icons.lock_outline,
              obscureText: _obscureText,
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            const SizedBox(height: 24),
            _buildRegisterButton(),
          ],
        ),
      ),
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
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC06BFF), width: 2),
            ),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Este campo es obligatorio' : null,
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return InkWell(
      onTap: _submit,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFFC06BFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC06BFF).withAlpha(64),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Registrarse',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
        children: [
          const TextSpan(text: '¿Ya tienes una cuenta? '),
          TextSpan(
            text: 'Inicia sesión',
            style: GoogleFonts.poppins(color: const Color(0xFFC06BFF), fontWeight: FontWeight.w600),
            recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
          ),
        ],
      ),
    );
  }
}
