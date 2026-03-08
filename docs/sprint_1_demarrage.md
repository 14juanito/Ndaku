# Sprint 1 - Demarrage (Architecture + fondations)

## Objectif
Mettre en place une base propre, compilee, et prete pour l'implementation des fonctionnalites.

## Taches
1. Initialisation projet Flutter + lints
2. Ajout dependances de base:
   - `provider`
   - `go_router`
   - `firebase_core`
   - `firebase_auth`
   - `cloud_firestore`
   - `firebase_storage`
   - `google_sign_in`
   - `google_maps_flutter`
   - `http`
   - `geolocator`
3. Creation arborescence MVC (dossiers vides + fichiers de base)
4. Theme global (couleurs/typo/radius/shadows)
5. Routing minimum:
   - Splash -> Login/Register -> Home
6. Controllers vides avec `isLoading`, `errorMessage`
7. Modeles:
   - `AppUser`
   - `Property`
   - `Favorite`
8. Services (interfaces + stubs):
   - Auth
   - Firestore property/favorite/user
   - Geocoding API

## Definition of Done
- App demarre sans erreur
- Architecture des dossiers conforme MVC
- Navigation de base fonctionnelle
- Theme de la charte applique globalement
- Base de code prete pour Sprint 2 (Auth complet)

## Convention commits (proposee)
- `chore: init flutter project and base dependencies`
- `feat(core): add app theme and design tokens`
- `feat(routing): setup go_router with auth flow`
- `feat(architecture): scaffold mvc folders and base classes`
