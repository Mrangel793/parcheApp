# Social Plans Flutter App

This is a Flutter application for social plans, built with a clean architecture approach.

## Setup Instructions

1. **Install Flutter:** Make sure you have Flutter installed on your machine. You can find the installation instructions [here](https://docs.flutter.dev/get-started/install).

2. **Clone the repository:**
   ```bash
   git clone <repository-url>
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## Flavors

This project is configured with two flavors: `development` and `production`.

* **Development:** To run the app in development mode, use the following command:
  ```bash
  flutter run --flavor development --target lib/main_development.dart
  ```

* **Production:** To run the app in production mode, use the following command:
  ```bash
  flutter run --flavor production --target lib/main_production.dart
  ```

## Project Structure

The project follows the Clean Architecture principles, with the following directory structure:

```
lib
├── src
│   ├── core
│   ├── features
│   │   └── auth
│   │       ├── data
│   │       ├── domain
│   │       └── presentation
│   ├── config
│   │   └── router
│   └── shared
└── main.dart
```
