@echo off
echo ====================================
echo Instalando dependencias de Flutter
echo ====================================
echo.

echo Limpiando cache anterior...
flutter clean

echo.
echo Obteniendo dependencias...
flutter pub get

echo.
echo Generando archivos (si es necesario)...
flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo ====================================
echo Instalacion completada!
echo ====================================
echo.
echo Ahora puedes ejecutar: flutter run
echo.
pause
