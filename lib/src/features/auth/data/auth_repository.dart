import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// A custom exception class for handling authentication-related errors.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

/// Main repository for handling all authentication-related tasks.
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._googleSignIn);

  /// Stream of [User] to notify when the authentication state changes.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Synchronously get the current user.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Signs in a user with the given [email] and [password].
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthError(e.code));
    } catch (_) {
      throw AuthException('Ocurrió un error inesperado.');
    }
  }

  /// Signs in a user with their Google account.
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (_) {
      throw AuthException('El inicio de sesión con Google falló.');
    }
  }

  /// Signs in a user with their Apple account.
  Future<void> signInWithApple() async {
    // Only available on Apple platforms
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw AuthException('El inicio de sesión con Apple solo está disponible en dispositivos Apple.');
    }

    // Generate a nonce for replay protection
    final rawNonce = _generateNonce();
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce, // Pass the original nonce here
      );

      await _firebaseAuth.signInWithCredential(oauthCredential);

      // Update user profile if it's the first sign-in
      final user = _firebaseAuth.currentUser;
      if (user != null && (user.displayName == null || user.email == null)) {
        if (appleCredential.givenName != null || appleCredential.familyName != null || appleCredential.email != null) {
          await user.updateDisplayName(
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
          );
           // Apple only provides the email on the first sign-in
          if(appleCredential.email != null) {
            await user.verifyBeforeUpdateEmail(appleCredential.email!);
          }
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return; // User canceled
      throw AuthException('El inicio de sesión con Apple falló.');
    } catch (_) {
      throw AuthException('Ocurrió un error inesperado con Apple Sign-In.');
    }
  }

  /// Signs up a new user with the given [email], [password], and [displayName].
  Future<UserCredential> signUp(
      {required String email, required String password, String? displayName}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (displayName != null) {
        await credential.user?.updateDisplayName(displayName);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthError(e.code));
    } catch (_) {
      throw AuthException('Ocurrió un error inesperado.');
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      // Also sign out from Google to allow account switching
      await _googleSignIn.signOut();
    } catch (_) {
      throw AuthException('Error al cerrar sesión.');
    }
  }

  /// Sends a password reset link to the given [email].
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthError(e.code));
    } catch (_) {
      throw AuthException('Ocurrió un error inesperado.');
    }
  }

  /// Handles Firebase Auth error codes and returns a user-friendly message.
  String _handleAuthError(String code) {
    switch (code) {
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta para ese correo electrónico.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Correo electrónico o contraseña incorrectos.';
      case 'invalid-email':
        return 'El formato del correo electrónico es inválido.';
      default:
        return 'Ocurrió un error de autenticación.';
    }
  }

  /// Generates a random 32-character nonce.
  String _generateNonce([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}

// --- Providers --- //

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final googleSignInProvider = Provider<GoogleSignIn>((_) => GoogleSignIn());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  );
});

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
