@echo off
echo Retour en mode Firebase complet...
cd /d "%~dp0"

if exist "lib\main_firebase.dart" (
    echo Restauration de main_firebase.dart vers main.dart...
    copy /Y "lib\main_firebase.dart" "lib\main.dart"
    echo.
    echo ✅ Mode Firebase restaure !
    echo.
) else (
    echo ❌ Erreur: main_firebase.dart introuvable
    echo Vous devez d'abord utiliser switch_to_simple.bat
)

pause
