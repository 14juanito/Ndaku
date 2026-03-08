# Architecture de travail - Application Flutter "Gestion Immobiliere"

## 1) Stack technique
- Framework: Flutter (mobile Android/iOS)
- Langage: Dart
- Auth: Firebase Authentication
- Base de donnees: Cloud Firestore
- Stockage media: Firebase Storage (photos des biens)
- State management: Provider (`ChangeNotifier`)
- Navigation: `go_router`
- Cartographie: `google_maps_flutter`
- API REST externe: Nominatim (OpenStreetMap) pour geocodage/recherche d'adresses a Kinshasa

## 2) Principes d'architecture
- Pattern principal: MVC strict
- Separation des responsabilites:
  - `models`: classes metier + mapping JSON/Firestore
  - `views`: ecrans/widgets uniquement UI
  - `controllers`: logique metier et orchestration UI <-> services
  - `services`: acces Firebase/API externe
- Un controller ne contient pas de code d'affichage.
- Une view ne parle pas directement a Firebase/API.

## 3) Arborescence proposee
```text
lib/
  main.dart
  app.dart
  core/
    constants/
      app_colors.dart
      app_spacing.dart
      kinshasa_bounds.dart
    theme/
      app_theme.dart
    routing/
      app_router.dart
    utils/
      validators.dart
      fire_error_mapper.dart
  models/
    app_user.dart
    property.dart
    favorite.dart
    property_filter.dart
  services/
    auth/
      auth_service.dart
      firebase_auth_service.dart
    firestore/
      property_firestore_service.dart
      favorite_firestore_service.dart
      user_firestore_service.dart
    storage/
      property_image_service.dart
    api/
      geocoding_service.dart
  controllers/
    auth_controller.dart
    session_controller.dart
    property_controller.dart
    favorites_controller.dart
    map_controller.dart
  views/
    screens/
      splash_screen.dart
      auth/
        login_screen.dart
        register_screen.dart
      home/
        home_screen.dart
      property/
        property_detail_screen.dart
        property_form_screen.dart
        my_properties_screen.dart
      favorites/
        favorites_screen.dart
      map/
        kinshasa_map_screen.dart
      profile/
        profile_screen.dart
    widgets/
      property_card.dart
      filter_bottom_sheet.dart
      app_snackbar.dart
      loading_overlay.dart
  providers/
    app_providers.dart
```

## 4) Modele de donnees Firestore

### Collection `users`
- document id: `uid` (Firebase Auth)
- champs:
  - `fullName` (String)
  - `email` (String)
  - `phone` (String?)
  - `createdAt` (Timestamp)
  - `photoUrl` (String?)

### Collection `properties`
- document id: auto
- champs:
  - `ownerId` (String, uid)
  - `title` (String)
  - `description` (String)
  - `price` (num)
  - `currency` (String: "USD" ou "CDF")
  - `type` (String: appartement, maison, terrain...)
  - `commune` (String)
  - `city` (String, "Kinshasa")
  - `country` (String, "RDC")
  - `address` (String)
  - `location` (GeoPoint)
  - `surfaceM2` (num?)
  - `rooms` (int?)
  - `bathrooms` (int?)
  - `images` (List<String>)
  - `isAvailable` (bool)
  - `createdAt` (Timestamp)
  - `updatedAt` (Timestamp)

### Collection `users/{uid}/favorites`
- document id: `propertyId`
- champs:
  - `propertyId` (String)
  - `addedAt` (Timestamp)

## 5) Regles carte Kinshasa
- Centre initial: `LatLng(-4.4419, 15.2663)`
- Bornes (validation app):
  - latitude min: `-4.75`
  - latitude max: `-4.20`
  - longitude min: `14.95`
  - longitude max: `15.55`
- Toute annonce hors bornes est refusee avec message utilisateur.

## 6) Flux fonctionnels (MVP)
- Auth:
  - Inscription Email/MDP
  - Connexion Email/MDP
  - Provider supplementaire: Google (minimum 1 provider externe)
  - Persistance session + deconnexion
- Biens:
  - Liste + filtres prix/commune
  - Detail bien
  - Ajouter/Modifier/Supprimer (proprietaire seulement)
- Favoris:
  - Ajouter/Retirer
  - Ecran "Mes favoris"
- API externe:
  - Geocodage adresse -> coordonnees
  - Reverse geocoding coordonnees -> adresse/commune

## 7) Etat (Provider)
- `SessionController`: session globale (user courant, etat auth)
- `AuthController`: login/register/logout/providers
- `PropertyController`: chargement liste, CRUD, filtres
- `FavoritesController`: statut favoris + sync Firestore
- `MapController`: etat map, markers, validation Kinshasa

Chaque controller expose:
- `isLoading`
- `errorMessage`
- methodes d'action (`login`, `createProperty`, `toggleFavorite`, etc.)

## 8) Navigation (10 ecrans)
1. Splash
2. Login
3. Register
4. Home (liste + filtres)
5. Detail bien
6. Formulaire bien (ajout/modification)
7. Mes annonces
8. Favoris
9. Carte Kinshasa
10. Profil (deconnexion)

## 9) Charte graphique (integration dans le code)
- Fond principal: `#F8F7F3`
- Couleur primaire: `#FE460A`
- Texte principal: `#333333`
- Police: Montserrat (ou Lato)
- Cartes arrondies + ombres legeres
- Bottom navigation: fond charcoal, item actif orange

## 10) Roadmap d'implementation
1. Initialiser projet Flutter + dependances
2. Installer Firebase (Auth + Firestore + Storage)
3. Poser architecture dossiers + models + services
4. Implementer auth complete
5. Implementer CRUD biens Firestore
6. Implementer favoris
7. Integrer carte Kinshasa + bornes
8. Integrer API geocodage externe
9. Finaliser UX feedback (loading/snackbar/dialog)
10. Tests manuels + commits Git par fonctionnalite

