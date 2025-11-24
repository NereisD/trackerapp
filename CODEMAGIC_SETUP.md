# 🚀 Configuration Codemagic - Guide rapide

## ⚠️ Le problème principal : Pod install manquant

Votre app crash parce que **CocoaPods n'est pas installé pendant le build**.

## 🎯 Solution rapide (2 options)

### OPTION 1 : Via l'interface Codemagic (PLUS SIMPLE)

Si vous utilisez déjà l'interface de workflow :

1. **Ouvrez Codemagic** → votre app → **Workflow settings**

2. **Dans la section "Build"**, trouvez la partie **"Pre-build script"**

3. **Ajoutez ce script** :
   ```bash
   #!/bin/sh
   set -e
   set -x
   
   echo "Installing CocoaPods dependencies..."
   cd ios
   pod install
   cd ..
   echo "Pod install complete!"
   ```

4. **Sauvegardez**

5. **Lancez un nouveau build**

6. **VÉRIFIEZ dans le build log** que vous voyez :
   ```
   Installing CocoaPods dependencies...
   Analyzing dependencies
   Installing Firebase (10.x.x)
   Installing FirebaseAuth (10.x.x)
   Installing GoogleSignIn (7.x.x)
   Pod install complete!
   ```

✅ **C'est tout !** Si vous voyez ces lignes dans le log, le problème est résolu.

---

### OPTION 2 : Via codemagic.yaml (plus avancé)

Si vous préférez utiliser un fichier de configuration :

1. **Avant de continuer**, vous devez configurer l'intégration App Store Connect dans Codemagic :
   - Allez dans **Teams** → **Integrations** → **App Store Connect**
   - Connectez votre compte Apple Developer
   - Nommez l'intégration : `codemagic`

2. **Commitez et pushez** le fichier `codemagic.yaml` :
   ```bash
   git add codemagic.yaml
   git commit -m "Add Codemagic config"
   git push
   ```

3. **Dans Codemagic** :
   - Allez dans **App settings** → **Workflow**
   - Basculez de "Workflow Editor" vers **"codemagic.yaml"**
   - Sélectionnez le workflow `ios-workflow`

4. **Configurez le code signing** dans l'interface (certificats, provisioning profiles)

5. **Lancez le build**

---

## 🔍 Comment savoir si ça marche

### Dans le build log, vous DEVEZ voir :

```
✓ Get Flutter packages
✓ Install CocoaPods dependencies
   Analyzing dependencies
   Downloading dependencies
   Installing Firebase (10.x.x)
   Installing FirebaseAuth (10.x.x)  
   Installing FirebaseCore (10.x.x)
   Installing GoogleSignIn (7.x.x)
   Installing GTMAppAuth (x.x.x)
   ...
   Generating Pods project
   Integrating client project
   Pod installation complete!
✓ Flutter build ipa
```

### Si vous NE VOYEZ PAS "Installing Firebase" → pod install ne s'exécute pas

---

## ❌ Erreurs courantes

### Erreur 1 : "validation errors in codemagic.yaml"

**Solution** : Utilisez plutôt l'OPTION 1 (interface UI) qui est plus simple.

### Erreur 2 : "Code signing failed"

**Solution** : 
- Vérifiez vos certificats dans Apple Developer
- Configurez le code signing dans Codemagic UI
- Utilisez `codemagic-simple.yaml` pour tester sans signing

### Erreur 3 : Le log ne montre pas "pod install"

**Solution** : 
- Le script n'est pas au bon endroit
- Mettez-le dans **Pre-build script** ou **avant** flutter build

---

## 📋 Checklist avant de build

- [ ] Podfile est dans le repo (`ios/Podfile`)
- [ ] GoogleService-Info.plist est dans le repo (`ios/Runner/GoogleService-Info.plist`)
- [ ] Script pod install est configuré (Option 1 ou 2)
- [ ] Version dans pubspec.yaml est incrémentée (actuellement 1.0.3+1)
- [ ] Tout est commité et pushé

---

## 🎯 Recommandation

**Utilisez l'OPTION 1** (interface UI avec Pre-build script).

C'est :
- ✅ Plus simple
- ✅ Moins d'erreurs de configuration
- ✅ Plus flexible pour les certificats
- ✅ Fonctionne immédiatement

Une fois que pod install fonctionne et que l'app ne crash plus, vous pourrez migrer vers codemagic.yaml si vous voulez.

---

## 📞 Après le build

Une fois que le build réussit :

1. ✅ Téléchargez le .ipa
2. ✅ Installez sur iPhone (via TestFlight ou direct)
3. ✅ L'app devrait s'ouvrir sans crash !

Si elle crash encore, **partagez-moi le nouveau crash log** (mais je suis quasi certain que pod install résoudra le problème).

---

**Allez-y, testez l'OPTION 1 maintenant ! 🚀**
