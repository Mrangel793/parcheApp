import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/auth/presentation/forgot_password/forgot_password_screen.dart';
import 'package:myapp/src/features/auth/presentation/login/login_screen.dart';
import 'package:myapp/src/features/home/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);
