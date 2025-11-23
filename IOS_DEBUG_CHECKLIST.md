# 🔍 Checklist de Debug iOS - App qui crash au démarrage

## ✅ ÉTAPE 1 : Récupérer les logs de crash (CRITIQUE)

### Sur Codemagic :
1. Allez dans votre dernier build qui a réussi
2. Regardez dans la section **Build logs**
3. Cherchez les erreurs dans le log de build iOS
4. **PARTAGEZ-MOI CES LOGS** - sans ça, on avance à l'aveugle

### Sur votre iPhone (si possible) :
1. **Réglages** → **Confidentialité et sécurité** → **Analyses et améliorations**
2. **Données d'analyse**
3. Cherchez un fichier commençant par `mon_app` ou `Runner` avec la date d'aujourd'hui
4. Ouvrez-le et copiez le contenu
5. **ENVOYEZ-MOI AU MOINS LES 50 PREMIÈRES LIGNES**

---

## ✅ ÉTAPE 2 : Vérifier les fichiers locaux

### 2.1 - Vérifier GoogleService-Info.plist
```bash
# Vérifiez que le fichier existe :
dir ios\Runner\GoogleService-Info.plist
```

**✓ À vérifier dans le fichier :**
- [ ] `REVERSED_CLIENT_ID` présent
- [ ] `BUNDLE_ID` = `com.nereide.cn`
- [ ] `PROJECT_ID` = `riftboundtracker`

### 2.2 - Vérifier Info.plist
```bash
dir ios\Runner\Info.plist
```

**✓ À vérifier :**
- [ ] `CFBundleURLTypes` est présent (lignes 48-58)
- [ ] Le URL scheme correspond au `REVERSED_CLIENT_ID` de GoogleService-Info.plist

### 2.3 - Vérifier Podfile
```bash
dir ios\Podfile
```

**✓ À vérifier :**
- [ ] Le fichier existe
- [ ] `platform :ios, '13.0'` en ligne 2

---

## ✅ ÉTAPE 3 : Vérifier la configuration Codemagic

### 3.1 - Vérifier que tous les fichiers sont bien dans le repo
```bash
git status
git add .
git commit -m "Add all iOS config files"
git push
```

### 3.2 - Vérifier le workflow Codemagic
Dans Codemagic, vérifiez :
- [ ] iOS build est activé
- [ ] Code signing est configuré
- [ ] Le script build inclut `pod install`
- [ ] La version minimum iOS est >= 13.0

---

## ✅ ÉTAPE 4 : Vérifier Firebase Console

### 4.1 - Vérifier l'app iOS dans Firebase
1. Allez sur https://console.firebase.google.com/
2. Sélectionnez **riftboundtracker**
3. **⚙️ Project Settings** → **Your apps**
4. Vérifiez qu'il y a bien une app iOS avec :
   - Bundle ID: `com.nereide.cn`
   - App nickname: (peu importe)

### 4.2 - Télécharger à nouveau GoogleService-Info.plist (au cas où)
1. Dans Firebase Console, sur l'app iOS
2. Cliquez sur **Download GoogleService-Info.plist**
3. Comparez avec votre fichier local
4. Si différent, remplacez le fichier local

### 4.3 - Vérifier Google Sign-In
1. Firebase Console → **Authentication**
2. **Sign-in method**
3. Vérifiez que **Google** est **Enabled**

---

## ✅ ÉTAPE 5 : Construire localement (si possible)

Si vous avez accès à un Mac (ami, collègue) :

```bash
cd mon_app
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter build ios --release
```

Regardez les erreurs qui apparaissent.

---

## ✅ ÉTAPE 6 : Tests spécifiques

### Test 1 : Vérifier le Bundle ID
Dans `ios/Runner.xcodeproj/project.pbxproj`, cherchez `PRODUCT_BUNDLE_IDENTIFIER` :
- Doit être : `com.nereide.cn`

### Test 2 : Vérifier la version Xcode sur Codemagic
- Utilisez Xcode 15.x ou 16.x (pas trop vieux)

### Test 3 : Simplifier main.dart temporairement
Remplacez le contenu de `lib/main.dart` par :

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello iOS!'),
        ),
      ),
    );
  }
}
```

Si ça marche → le problème vient de Firebase
Si ça crash quand même → problème de configuration iOS/signing

---

## 🚨 Erreurs communes

### Erreur 1 : "Missing GoogleService-Info.plist"
**Solution :** Le fichier n'est pas au bon endroit ou pas dans git
```bash
git add ios/Runner/GoogleService-Info.plist
git commit -m "Add GoogleService-Info.plist"
git push
```

### Erreur 2 : "Code signing error"
**Solution :** Vérifier les certificats dans Codemagic

### Erreur 3 : "pod install failed"
**Solution :** Problème de Podfile ou de version iOS

### Erreur 4 : "Firebase initialization failed"
**Solution :** GoogleService-Info.plist incorrect ou Bundle ID ne correspond pas

---

## 📋 CE QUE JE DOIS VÉRIFIER EN PRIORITÉ :

1. **LES LOGS DE CODEMAGIC** (la section Build du dernier build iOS)
2. **LES LOGS DE CRASH** (si vous pouvez les récupérer sur l'iPhone)
3. Le résultat du test avec le `main.dart` simplifié

**⚠️ Sans ces informations, je ne peux que deviner le problème !**

---

## 🎯 Action immédiate

**Faites ces 3 choses dans l'ordre :**

1. ✅ Allez sur Codemagic → Dernier build iOS → Copier les logs de build
2. ✅ Testez avec le main.dart simplifié (ci-dessus)
3. ✅ Partagez-moi les résultats

C'est la seule façon de progresser ! 💪
