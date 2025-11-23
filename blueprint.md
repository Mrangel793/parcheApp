# Blueprint: Flutter Authentication App

## 1. Project Overview

This document outlines the architecture, features, and design of a robust Flutter application with a primary focus on a comprehensive and secure authentication system. The application serves as a foundation for future feature development, providing a seamless and intuitive user onboarding experience.

It is built using modern Flutter practices, incorporating Riverpod for state management, GoRouter for navigation, and Firebase for backend services.

---

## 2. Implemented Features

### Core
- **Firebase Integration**: Core setup with Firebase, including initialization and platform-specific options.
- **State Management**: Implemented using `hooks_riverpod` for efficient and scalable state management across the app.
- **Navigation**: Declarative, authentication-aware routing handled by `go_router`.
- **Dependency Management**: Clean and organized dependency injection using Riverpod's providers.

### Authentication
- **Centralized Auth Repository**: A single `AuthRepository` class encapsulates all authentication logic.
- **Email & Password**: Standard sign-up and sign-in functionality.
- **Google Sign-In**: Seamless one-tap sign-in with Google.
- **Apple Sign-In**: Secure sign-in with Apple ID, including nonce generation for replay attack prevention.
- **Password Reset**: "Forgot Password" flow that sends a reset email to the user.
- **Authentication State Persistence**: The app listens to `authStateChanges` to automatically manage user sessions.
- **Custom Error Handling**: A custom `AuthException` class provides user-friendly error messages.

### User Interface (UI)
- **Splash Screen**: A vibrant, animated entry screen that serves as the app's loading and redirection hub.
- **Login Screen**: A completely redesigned, modern, and pixel-perfect login screen with options for email/password, Google, Apple, and Facebook sign-in.
- **Registration Screen**: A new, multi-step, and user-friendly registration screen with real-time validation and a clear progress indicator.
- **Forgot Password Screen**: A basic, functional screen for users to request a password reset.
- **Home Screen**: A functional welcome screen for authenticated users, displaying their email and providing a logout button.

---

## 3. Design and Style

### Theming & Core UI
- **Typography**: Custom typography implemented using the `google_fonts` package (`Poppins`, `Inter`, etc.).
- **Assets**: Management of SVG image assets via the `flutter_svg` package.

### Login Screen Specifics
- **Layout**: A responsive single-column layout with distinct header, form, and footer sections.
- **Form Card**: A floating card UI with a soft `BoxShadow`.
- **Buttons**:
    - **Login Button**: A full-width button with a pink-to-purple gradient (`#FF6B9D` to `#C06BFF`).
    - **Social Buttons**: Uniformly styled `OutlinedButton`s for Google, Apple, and Facebook, using their official SVG logos.
- **Layout Correction**: The "Mantener sesión iniciada" and "¿Olvidaste tu contraseña?" elements are now perfectly aligned on a single, responsive line using `Row` and `Flexible` widgets.

### Registration Screen Specifics
- **Header**: Features a back button, a centered title (`Poppins SemiBold`), and a multi-step progress bar (currently at Step 1 of 3).
- **Structure**: The form is organized with clear section headers ("Información básica") and descriptive text.
- **Real-time Validation**:
    - **Email**: Shows a green checkmark for valid email formats.
    - **Password**: Includes a strength indicator bar (Weak/Medium/Fuerte) and a checklist for specific requirements (length, uppercase, number, special character).
    - **Confirm Password**: Displays a red 'X' or a green checkmark to indicate if the passwords match.
- **Interactive Button**: The "Continuar" button is disabled (grayed out) until all form fields and the terms & conditions checkbox are correctly filled, at which point it becomes enabled with a vibrant gradient.
- **T&C**: Includes a checkbox and tappable links for "términos y condiciones" and "política de privacidad".

---

## 4. Plan for Last Request: Redesign Register Screen & Fix Login Screen

**Objective**: Implement a brand-new, detailed registration screen and apply final pixel-perfect corrections to the login screen.

**Steps Executed**:

1.  **Register Screen Rewrite**: Completely rewrote the `lib/src/features/auth/presentation/register/register_screen.dart` file.
    - Implemented a `StatefulWidget` to manage the complex real-time validation logic for all fields.
    - Built all UI components according to the design prompt: header with progress bar, styled form fields, a dynamic password strength indicator, a requirements checklist, and an interactive "Continuar" button.
    - Added `GestureRecognizer` to the terms and privacy policy text to make them tappable.

2.  **Login Screen Fixes**:
    - **Layout Correction**: Modified the `_buildRememberMeAndForgotPassword` widget in `login_screen.dart`, replacing the `Wrap` widget with a `Row` containing `Flexible` children. This achieves the precise side-by-side alignment from the design while preventing pixel overflow on smaller screens.
    - **Gradient Update**: Changed the `_buildLoginButton` to use a `LinearGradient` with the specified pink and purple colors (`#FF6B9D`, `#C06BFF`).

3.  **Documentation**: Updated this blueprint to reflect all the recent changes and corrections.