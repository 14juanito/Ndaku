import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/favorite.dart';
import '../services/firestore/favorite_firestore_service.dart';
import 'session_controller.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController({
    required FavoriteFirestoreService favoriteService,
    required SessionController sessionController,
  }) : _favoriteService = favoriteService,
       _sessionController = sessionController {
    _sessionController.addListener(_onSessionChanged);
    _onSessionChanged();
  }

  final FavoriteFirestoreService _favoriteService;
  final SessionController _sessionController;
  StreamSubscription<List<Favorite>>? _subscription;

  final List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Favorite> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isFavorite(String propertyId) =>
      _favorites.any((item) => item.propertyId == propertyId);

  Future<void> toggleFavorite(String propertyId) async {
    final user = _sessionController.currentUser;
    if (user == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      if (isFavorite(propertyId)) {
        await _favoriteService.removeFavorite(user.id, propertyId);
      } else {
        await _favoriteService.addFavorite(user.id, propertyId);
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onSessionChanged() {
    _subscription?.cancel();
    _favorites.clear();
    final user = _sessionController.currentUser;
    if (user == null) {
      notifyListeners();
      return;
    }
    _subscription = _favoriteService.watchFavorites(user.id).listen((items) {
      _favorites
        ..clear()
        ..addAll(items);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sessionController.removeListener(_onSessionChanged);
    _subscription?.cancel();
    super.dispose();
  }
}
