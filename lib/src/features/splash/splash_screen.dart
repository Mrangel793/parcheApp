import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _particleController;
  List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _particles = List.generate(30, (_) => Particle(MediaQuery.of(context).size));
      _particleController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      )..repeat();
       _animationController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        final authRepository = ref.read(authRepositoryProvider);
        final user = authRepository.currentUser;
        if (user != null) {
          context.go('/');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (mounted) {
      _particleController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          if (_particles.isNotEmpty) {
            for (var particle in _particles) {
              particle.update();
            }
          }
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF6B9D), Color(0xFFC06BFF)],
              ),
            ),
            child: Stack(
              children: [
                if (_particles.isNotEmpty)
                  CustomPaint(
                    painter: ParticlePainter(_particles),
                    child: Container(),
                  ),
                child!,
              ],
            ),
          );
        },
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.hub, // Icon representing connection/network
                    color: Colors.white,
                    size: 60,
                    shadows: [
                      Shadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PlanIt',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w900, // Poppins Black
                      fontSize: 48,
                      color: Colors.white,
                      shadows: [
                        const Shadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Conecta. Descubre. Vive.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withAlpha(204),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Particle {
  late Offset position;
  late double size;
  late Color color;
  late Offset speed;
  final Size boundary;

  Particle(this.boundary) {
    reset();
  }

  void reset() {
    final random = Random();
    position = Offset(random.nextDouble() * boundary.width, random.nextDouble() * boundary.height);
    size = random.nextDouble() * 2.5 + 0.5;
    color = Colors.white.withAlpha((255 * (random.nextDouble() * 0.3 + 0.1)).round());
    speed = Offset(random.nextDouble() * 0.4 - 0.2, random.nextDouble() * 0.4 - 0.2);
  }

  void update() {
    position += speed;
    if (position.dx < 0 || position.dx > boundary.width || position.dy < 0 || position.dy > boundary.height) {
      reset();
      position = Offset(Random().nextDouble() * boundary.width, boundary.height);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var particle in particles) {
      paint.color = particle.color;
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
