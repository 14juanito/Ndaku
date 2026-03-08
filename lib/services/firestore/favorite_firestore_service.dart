import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/favorite.dart';

abstract class FavoriteFirestoreService {
  Stream<List<Favorite>> watchFavorites(String userId);
  Future<void> addFavorite(String userId, String propertyId);
  Future<void> removeFavorite(String userId, String propertyId);
}

class FirebaseFavoriteFirestoreService implements FavoriteFirestoreService {
  FirebaseFavoriteFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _favoritesOf(String userId) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  @override
  Stream<List<Favorite>> watchFavorites(String userId) {
    return _favoritesOf(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Favorite(
          propertyId: (data['propertyId'] as String?) ?? doc.id,
          addedAt: (data['addedAt'] is Timestamp)
              ? (data['addedAt'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();
    });
  }

  @override
  Future<void> addFavorite(String userId, String propertyId) async {
    await _favoritesOf(userId).doc(propertyId).set({
      'propertyId': propertyId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String userId, String propertyId) {
    return _favoritesOf(userId).doc(propertyId).delete();
  }
}

class InMemoryFavoriteFirestoreService implements FavoriteFirestoreService {
  final Map<String, List<Favorite>> _storage = {};
  final Map<String, StreamController<List<Favorite>>> _controllers = {};

  StreamController<List<Favorite>> _controllerFor(String userId) {
    return _controllers.putIfAbsent(
      userId,
      () => StreamController<List<Favorite>>.broadcast(),
    );
  }

  void _emit(String userId) {
    final data = List<Favorite>.from(_storage[userId] ?? const []);
    _controllerFor(userId).add(data);
  }

  @override
  Stream<List<Favorite>> watchFavorites(String userId) {
    _emit(userId);
    return _controllerFor(userId).stream;
  }

  @override
  Future<void> addFavorite(String userId, String propertyId) async {
    final list = _storage.putIfAbsent(userId, () => []);
    if (list.any((fav) => fav.propertyId == propertyId)) return;
    list.add(Favorite(propertyId: propertyId, addedAt: DateTime.now()));
    _emit(userId);
  }

  @override
  Future<void> removeFavorite(String userId, String propertyId) async {
    final list = _storage.putIfAbsent(userId, () => []);
    list.removeWhere((fav) => fav.propertyId == propertyId);
    _emit(userId);
  }
}
