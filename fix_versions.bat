@echo off
echo ====================================
echo Corrigiendo versiones de dependencias
echo ====================================
echo.

echo Limpiando proyecto...
flutter clean

echo.
echo Eliminando pubspec.lock...
del pubspec.lock 2>nul

echo.
echo Obteniendo dependencias con versiones corregidas...
flutter pub get

echo.
echo ====================================
echo Correccion completada!
echo ====================================
echo.
echo Ahora puedes ejecutar: flutter run
echo.
pause
