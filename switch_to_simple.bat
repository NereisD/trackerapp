@echo off
echo Passage en mode simple (sans Firebase)...
cd /d "%~dp0"

if exist "lib\main.dart" (
    echo Sauvegarde de main.dart vers main_firebase.dart...
    copy /Y "lib\main.dart" "lib\main_firebase.dart"
)

if exist "lib\main_simple.dart" (
    echo Copie de main_simple.dart vers main.dart...
    copy /Y "lib\main_simple.dart" "lib\main.dart"
    echo.
    echo ✅ Mode simple active !
    echo.
    echo Maintenant:
    echo 1. Commitez et pushez
    echo 2. Rebuild sur Codemagic
    echo 3. Testez sur iPhone
    echo.
) else (
    echo ❌ Erreur: main_simple.dart introuvable
)

pause
