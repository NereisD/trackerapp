@echo off
echo ========================================
echo   VERIFICATION FICHIERS iOS
echo ========================================
echo.

cd /d "%~dp0"

set ERRORS=0

echo [1/5] Verification Podfile...
if exist "ios\Podfile" (
    echo     ✓ Podfile trouve
) else (
    echo     ✗ ERREUR: Podfile manquant
    set ERRORS=1
)

echo.
echo [2/5] Verification GoogleService-Info.plist...
if exist "ios\Runner\GoogleService-Info.plist" (
    echo     ✓ GoogleService-Info.plist trouve
) else (
    echo     ✗ ERREUR: GoogleService-Info.plist manquant
    set ERRORS=1
)

echo.
echo [3/5] Verification Info.plist...
if exist "ios\Runner\Info.plist" (
    echo     ✓ Info.plist trouve
) else (
    echo     ✗ ERREUR: Info.plist manquant
    set ERRORS=1
)

echo.
echo [4/5] Verification codemagic.yaml...
if exist "codemagic.yaml" (
    echo     ✓ codemagic.yaml trouve
) else (
    echo     ! ATTENTION: codemagic.yaml manquant
    echo       Vous devrez ajouter pod install manuellement dans Codemagic
)

echo.
echo [5/5] Verification pubspec.yaml...
if exist "pubspec.yaml" (
    findstr /C:"version:" pubspec.yaml
    echo     ✓ pubspec.yaml trouve
) else (
    echo     ✗ ERREUR: pubspec.yaml manquant
    set ERRORS=1
)

echo.
echo ========================================
if %ERRORS%==0 (
    echo   ✓ TOUS LES FICHIERS SONT PRETS
    echo ========================================
    echo.
    echo PROCHAINE ETAPE:
    echo.
    echo 1. Commitez tous les fichiers:
    echo    git add .
    echo    git commit -m "Fix iOS crash: add pod install"
    echo    git push
    echo.
    echo 2. Dans Codemagic:
    echo    - Activez codemagic.yaml
    echo    OU
    echo    - Ajoutez ce script avant flutter build:
    echo      cd ios ^&^& pod install ^&^& cd ..
    echo.
    echo 3. Lancez un nouveau build
    echo.
    echo 4. VERIFIEZ dans le build log que vous voyez:
    echo    "Installing CocoaPods dependencies"
    echo    "Installing Firebase"
    echo    "Installing GoogleSignIn"
    echo.
) else (
    echo   ✗ ERREURS DETECTEES
    echo ========================================
    echo.
    echo Corrigez les fichiers manquants avant de continuer.
)

echo.
pause
