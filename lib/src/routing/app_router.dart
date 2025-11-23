import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/src/features/auth/data/auth_repository.dart';
import 'package:myapp/src/features/auth/presentation/login/login_screen.dart';
import 'package:myapp/src/features/auth/presentation/register/register_screen.dart';
import 'package:myapp/src/features/auth/presentation/forgot_password/forgot_password_screen.dart';
import 'package:myapp/src/features/home/home_screen.dart';
import 'package:myapp/src/features/splash/splash_screen.dart';

enum AppRoute {
  splash,
  home,
  login,
  register,
  forgotPassword,
}

class GoRouterNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  StreamSubscription<dynamic>? _authSubscription;

  GoRouterNotifier(this._authRepository) {
    _authSubscription = _authRepository.authStateChanges.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final notifier = GoRouterNotifier(authRepository);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authRepository.currentUser != null;
      final location = state.uri.toString();
      final onSplashScreen = location == '/splash';

      // If the user is on the splash screen, do nothing. 
      // The splash screen itself will handle navigation away from it.
      if (onSplashScreen) {
        return null;
      }

      final onAuthRoute = ['/login', '/register', '/forgot-password'].contains(location);

      // If the user is logged in and trying to access an auth route, redirect to home.
      if (isLoggedIn && onAuthRoute) {
        return '/';
      }

      // If the user is NOT logged in and trying to access a protected route, redirect to login.
      if (!isLoggedIn && !onAuthRoute) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRoute.forgotPassword.name,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  );
});
