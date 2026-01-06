
# Project Blueprint

## Overview

This document outlines the plan for implementing a comprehensive authentication service using Firebase in a Flutter application. The service will handle user authentication through various providers and manage the user's authentication state.

## Current Task: Create Authentication Service

### 1. Project Structure
   - The core logic for authentication will be encapsulated within `lib/src/features/auth/data/auth_repository.dart`.
   - A custom exception class, `AuthException`, will be created to provide user-friendly error messages.

### 2. Dependencies
   - Add the following packages to `pubspec.yaml`:
     - `firebase_auth`: For core Firebase authentication.
     - `google_sign_in`: For Google Sign-In.
     - `sign_in_with_apple`: For Sign in with Apple.

### 3. `auth_repository.dart` Implementation
   - **Firebase and GoogleSignIn Instances**:
     - Initialize `FirebaseAuth` and `GoogleSignIn`.
   - **Authentication State Stream**:
     - Expose `_firebaseAuth.authStateChanges()` to listen for authentication status changes in real-time.
   - **Sign-In Methods**:
     - `signInWithEmail(email, password)`: Sign in using email and password.
     - `signInWithGoogle()`:
       - Handle the Google Sign-In flow.
       - Obtain the `GoogleSignInAccount`.
       - Get the `GoogleSignInAuthentication` credentials.
       - Create a Firebase `AuthCredential`.
       - Sign in to Firebase with the credential.
     - `signInWithApple()`:
       - Handle the Sign in with Apple flow.
       - Obtain the `AuthorizationCredentialAppleID`.
       - Create an `OAuthProvider` credential.
       - Sign in to Firebase with the credential.
   - **Sign-Up Method**:
     - `signUp(email, password, displayName)`:
       - Create a new user with email and password.
       - Optionally update the user's display name.
   - **Sign-Out Method**:
     - `signOut()`:
       - Sign out from `FirebaseAuth`.
       - Sign out from `GoogleSignIn` to allow account switching.
   - **Password Reset**:
     - `resetPassword(email)`: Send a password reset email.
   - **Custom Error Handling**:
     - Create a private `_handleAuthError(code)` method to map Firebase error codes to user-friendly messages.
     - Implement a custom `AuthException` class to throw consistent errors.

## UI Integration and State Management

### 1. **State Management with Riverpod**
    -   **Providers (`lib/src/features/auth/provider/auth_provider.dart`):**
        -   `firebaseAuthProvider`: Provides the `FirebaseAuth` instance.
        -   `googleSignInProvider`: Provides the `GoogleSignIn` instance.
        -   `authRepositoryProvider`: Provides the `AuthRepository` instance.
        -   `authStateChangesProvider`: A `StreamProvider` that listens to the authentication state changes from the `AuthRepository`.
    -   **`main.dart`:**
        -   Initializes Firebase using `Firebase.initializeApp()`.
        -   Wraps the root `MyApp` widget with a `ProviderScope` to make Riverpod providers available throughout the app.

### 2. **Routing and Navigation**
    -   **`lib/src/config/router/app_router.dart`:**
        -   Uses `go_router` for navigation.
        -   Defines routes for `/login`, `/`, and `/forgot-password`.
    -   **`lib/src/app.dart`:**
        -   Uses a `ConsumerWidget` to watch the `authStateChangesProvider`.
        -   Conditionally renders `HomeScreen` if the user is authenticated (`user != null`).
        -   Renders `LoginScreen` if the user is not authenticated.
        -   Shows a loading indicator while the authentication state is being determined.

### 3. **Authentication Screens**
    -   **Login Screen (`lib/src/features/auth/presentation/login/login_screen.dart`):**
        -   Provides UI for email/password and social sign-in (Google, Apple).
        -   Uses `ConsumerStatefulWidget` to interact with the `authRepositoryProvider`.
        -   Calls the appropriate sign-in methods from the `AuthRepository`.
        -   Navigates to the registration screen or the forgot password screen.
    -   **Registration Screen (`lib/src/features/auth/presentation/register/register_screen.dart`):**
        -   Provides a form for new users to sign up with their name, email, and password.
        -   Calls the `signUp` method from the `AuthRepository`.
        -   Navigates back to the login screen on successful registration.
    -   **Forgot Password Screen (`lib/src/features/auth/presentation/forgot_password/forgot_password_screen.dart`):**
        -   Provides a form for users to request a password reset email.
        -   Calls the `resetPassword` method from the `AuthRepository`.

### 4. **Home Screen**
    -   **`lib/src/features/home/presentation/screens/home_screen.dart`:**
        -   Displays the logged-in user's email.
        -   Includes a logout button in the `AppBar`.
        -   The logout button calls the `signOut` method from the `AuthRepository`.
