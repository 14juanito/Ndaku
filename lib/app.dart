import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/map_controller.dart';
import 'controllers/property_controller.dart';
import 'controllers/session_controller.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_providers.dart';
import 'services/auth/auth_service.dart';
import 'services/auth/firebase_auth_service.dart';
import 'services/auth/local_auth_service.dart';
import 'services/firestore/favorite_firestore_service.dart';
import 'services/firestore/property_firestore_service.dart';
import 'services/firestore/user_firestore_service.dart';

class NdakuApp extends StatefulWidget {
  const NdakuApp({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  State<NdakuApp> createState() => _NdakuAppState();
}

class _NdakuAppState extends State<NdakuApp> {
  late final AuthService _authService;
  late final PropertyFirestoreService _propertyService;
  late final FavoriteFirestoreService _favoriteService;
  late final UserFirestoreService _userService;

  late final SessionController _sessionController;
  late final AuthController _authController;
  late final PropertyController _propertyController;
  late final FavoritesController _favoritesController;
  late final MapController _mapController;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _authService = widget.firebaseReady
        ? FirebaseAuthService()
        : LocalAuthService();
    _propertyService = widget.firebaseReady
        ? FirebasePropertyFirestoreService()
        : InMemoryPropertyFirestoreService();
    _favoriteService = widget.firebaseReady
        ? FirebaseFavoriteFirestoreService()
        : InMemoryFavoriteFirestoreService();
    _userService = widget.firebaseReady
        ? FirebaseUserFirestoreService()
        : LocalUserService();

    _sessionController = SessionController(_authService)..start();
    _authController = AuthController(
      authService: _authService,
      userService: _userService,
    );
    _propertyController = PropertyController(propertyService: _propertyService);
    _favoritesController = FavoritesController(
      favoriteService: _favoriteService,
      sessionController: _sessionController,
    );
    _mapController = MapController();
    _router = createRouter(_sessionController);
  }

  @override
  void dispose() {
    _sessionController.dispose();
    _authController.dispose();
    _propertyController.dispose();
    _favoritesController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: createAppProviders(
        sessionController: _sessionController,
        authController: _authController,
        propertyController: _propertyController,
        favoritesController: _favoritesController,
        mapController: _mapController,
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Ndaku',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
