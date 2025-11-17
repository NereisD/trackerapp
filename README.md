# Riftbound Tracker

Application mobile de tracking pour les tournois Riftbound. Elle permet de créer des tournois, suivre les scores en temps réel avec un compteur split-screen, et consulter l'historique complet de vos matchs.

## Fonctionnalités

- ✅ **Connexion Google** - Authentification sécurisée et sauvegarde cloud
- 🏆 **Gestion de tournois** - Créez et suivez vos tournois
- 🎯 **Compteur de points split-screen** - Interface intuitive pour tracker les scores
- 📊 **Système Bo3** - Gestion automatique des Best of 3
- 📜 **Historique détaillé** - Revoyez tous vos matchs et statistiques
- 🎲 **Écran Start** - Déterminez qui commence chaque match

## Installation

### 1. Installer les dépendances

```bash
cd mon_app
flutter pub get
```

### 2. Configuration Firebase

#### a) Créer un projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Créez un nouveau projet ou utilisez un projet existant
3. Activez l'authentification Google :
   - Allez dans **Authentication** > **Sign-in method**
   - Activez **Google**

#### b) Configuration Android

1. Dans Firebase Console, ajoutez une application Android
2. Entrez le nom du package : `com.example.mon_app` (ou votre package)
3. Téléchargez le fichier `google-services.json`
4. Placez-le dans `android/app/`

5. Éditez `android/app/build.gradle` :
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // Ajoutez cette ligne
}
```

6. Éditez `android/build.gradle` :
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'  // Ajoutez cette ligne
    }
}
```

#### c) Configuration iOS (optionnel)

1. Dans Firebase Console, ajoutez une application iOS
2. Entrez le Bundle ID : `com.example.monApp`
3. Téléchargez le fichier `GoogleService-Info.plist`
4. Placez-le dans `ios/Runner/`

### 3. Ajouter les images des decks

Placez les images de vos 12 decks dans le dossier `assets/images/decks/` avec les noms suivants :
- `warrior.png`
- `mage.png`
- `rogue.png`
- `ranger.png`
- `paladin.png`
- `warlock.png`
- `druid.png`
- `shaman.png`
- `priest.png`
- `necromancer.png`
- `monk.png`
- `bard.png`

**Note :** Si vous n'avez pas les images, l'application affichera des icônes par défaut.

### 4. Lancer l'application

```bash
flutter run
```

## Structure du projet

```
lib/
├── models/           # Modèles de données (Deck, Tournament, Round, Match)
├── screens/          # Écrans de l'application
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── deck_selection_screen.dart
│   ├── start_screen.dart
│   ├── score_counter_screen.dart
│   └── history_screen.dart
├── services/         # Services (Auth, Firestore)
│   ├── auth_service.dart
│   └── firestore_service.dart
└── main.dart         # Point d'entrée de l'application
```

## Utilisation

### Créer un tournoi

1. Connectez-vous avec votre compte Google
2. Sur la page d'accueil, entrez le nom du tournoi
3. Sélectionnez votre deck
4. Appuyez sur "Créer le tournoi"

### Jouer un match

1. Sélectionnez le deck adverse
2. Choisissez qui commence (vous ou l'adversaire)
3. Utilisez l'écran split-screen pour incrémenter les scores
4. Appuyez sur "Nouveau Match" pour enregistrer le résultat
5. Le système gère automatiquement le Bo3

### Consulter l'historique

1. Accédez à l'onglet "Historique" dans la navbar
2. Explorez vos tournois passés
3. Développez un tournoi pour voir les détails des rounds et matchs

## Technologies utilisées

- **Flutter** - Framework UI
- **Firebase Authentication** - Connexion Google
- **Cloud Firestore** - Base de données NoSQL en temps réel
- **Provider** - Gestion d'état (si nécessaire pour les extensions futures)

## Prochaines améliorations possibles

- [ ] Statistiques avancées (winrate par deck, graphiques)
- [ ] Mode hors ligne avec synchronisation
- [ ] Partage de résultats
- [ ] Notifications
- [ ] Thème sombre
- [ ] Export des données en CSV/PDF

## Support

Pour toute question ou problème, n'hésitez pas à ouvrir une issue.

---

Développé pour la communauté Riftbound 🎮
