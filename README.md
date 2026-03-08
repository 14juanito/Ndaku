# Ndaku - Application mobile de gestion immobiliere

Oui, l'application est bien developpee en **Flutter** (Dart), avec une architecture **MVC** et **Provider** pour la gestion d'etat.

## Stack technique
- Flutter / Dart
- Firebase Auth
- Cloud Firestore
- Firebase Storage (stub pour sprint suivant)
- Provider
- go_router
- google_maps_flutter
- API REST externe (Nominatim OpenStreetMap pour geocodage)

## Etat actuel du projet
Le socle de l'application est en place:
- Architecture MVC separee (`models`, `views`, `controllers`, `services`)
- Navigation de base avec protection de routes auth
- Theme + charte graphique orange (`#FE460A`) et fond clair
- Ecrans MVP structures:
  - Splash
  - Login / Register
  - Home
  - Detail bien
  - Formulaire bien (ajout/modification)
  - Mes annonces
  - Favoris
  - Carte Kinshasa
  - Profil
- Controle de zone cartographique Kinshasa (bornes definies)
- Composant logo integre dans les ecrans principaux

## Structure principale
```text
lib/
  controllers/
  core/
    constants/
    routing/
    theme/
    utils/
  models/
  providers/
  services/
    api/
    auth/
    firestore/
    storage/
  views/
    screens/
    widgets/
```

## Lancer le projet
1. Installer Flutter SDK
2. Depuis la racine du projet:
```bash
flutter pub get
flutter run
```

## Configuration Firebase (a faire sur ta machine)
1. Creer le projet Firebase
2. Ajouter Android/iOS
3. Placer:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Generer `firebase_options.dart` avec FlutterFire CLI (recommande)
5. Verifier les permissions et la configuration Google Sign-In

## Tests et qualite
```bash
flutter analyze
flutter test
```

## Documents de reference
- [Architecture MVC Flutter](docs/architecture_flutter_mvc.md)
- [Plan Sprint 1](docs/sprint_1_demarrage.md)
