# Prochaines étapes pour lancer l'application

## ✅ Ce qui est déjà fait

- ✅ Structure du projet créée
- ✅ Tous les écrans implémentés
- ✅ Modèles de données configurés
- ✅ Services d'authentification et Firestore
- ✅ Dépendances installées

## 🚀 Ce qu'il reste à faire

### 1. Configurer Firebase (OBLIGATOIRE)

#### Option A : Configuration rapide avec FlutterFire CLI (recommandé)

```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Se connecter à Firebase
firebase login

# Configurer le projet
flutterfire configure
```

Cette commande va :
- Créer ou sélectionner un projet Firebase
- Configurer automatiquement Android et iOS
- Générer les fichiers de configuration nécessaires

#### Option B : Configuration manuelle

Suivez les instructions détaillées dans le fichier `README.md` section "Configuration Firebase".

### 2. Activer l'authentification Google dans Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Sélectionnez votre projet
3. Allez dans **Authentication** > **Sign-in method**
4. Cliquez sur **Google** et activez-le
5. Ajoutez votre email de support
6. Cliquez sur **Enregistrer**

### 3. Activer Firestore Database

1. Dans Firebase Console, allez dans **Firestore Database**
2. Cliquez sur **Créer une base de données**
3. Sélectionnez **Mode test** pour commencer (vous pourrez changer les règles plus tard)
4. Choisissez une localisation proche de vous (ex: europe-west)

### 4. Ajouter les images des decks (OPTIONNEL)

Placez vos images dans `assets/images/decks/` :
- warrior.png
- mage.png
- rogue.png
- ranger.png
- paladin.png
- warlock.png
- druid.png
- shaman.png
- priest.png
- necromancer.png
- monk.png
- bard.png

**Note :** Si vous n'avez pas les images, l'app fonctionnera quand même avec des icônes par défaut.

### 5. Lancer l'application

```bash
# Vérifier les appareils connectés
flutter devices

# Lancer sur un appareil Android/iOS
flutter run

# Ou lancer en mode debug
flutter run --debug
```

## 📱 Test de l'application

### Premier lancement
1. L'écran de connexion Google s'affiche
2. Connectez-vous avec votre compte Google
3. Vous arrivez sur l'écran d'accueil

### Créer un tournoi
1. Entrez un nom (ex: "Tournoi Local 2024")
2. Sélectionnez votre deck
3. Cliquez sur "Créer le tournoi"
4. Sélectionnez le deck adverse
5. Choisissez qui commence (vous ou adversaire)
6. Utilisez l'écran split pour compter les points
7. Cliquez sur "Nouveau Match" pour enregistrer

### Consulter l'historique
1. Cliquez sur l'onglet "Historique" en bas
2. Vous verrez tous vos tournois
3. Développez un tournoi pour voir les détails

## 🐛 Dépannage

### Erreur "Firebase not initialized"
- Assurez-vous d'avoir configuré Firebase (étape 1)
- Vérifiez que les fichiers de configuration sont bien placés

### Erreur de connexion Google
- Vérifiez que l'authentification Google est activée dans Firebase Console
- Sur Android, vérifiez que le SHA-1 est correctement configuré

### Images des decks non affichées
- C'est normal si vous n'avez pas ajouté les images
- Les icônes par défaut sont affichées à la place

## 📞 Besoin d'aide ?

Si vous rencontrez des problèmes :
1. Consultez la documentation Firebase : https://firebase.google.com/docs
2. Vérifiez la documentation Flutter : https://docs.flutter.dev
3. Ouvrez une issue sur le projet

---

**Bon jeu sur Riftbound ! 🎮**
