import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/mock/mock_properties.dart';
import '../../models/property.dart';
import '../../models/property_filter.dart';

abstract class PropertyFirestoreService {
  Stream<List<Property>> watchAll({PropertyFilter? filter});
  Stream<List<Property>> watchByOwner(String ownerId);
  Future<Property?> getById(String propertyId);
  Future<void> create(Property property);
  Future<void> update(Property property);
  Future<void> delete(String propertyId);
}

class FirebasePropertyFirestoreService implements PropertyFirestoreService {
  FirebasePropertyFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('properties');

  @override
  Stream<List<Property>> watchAll({PropertyFilter? filter}) {
    return _collection.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      var items = snapshot.docs
          .map((doc) => Property.fromMap(doc.id, doc.data()))
          .toList();
      if (filter == null || filter.isEmpty) return items;
      items = items.where((p) {
        if (filter.minPrice != null && p.price < filter.minPrice!) {
          return false;
        }
        if (filter.maxPrice != null && p.price > filter.maxPrice!) {
          return false;
        }
        if (filter.commune != null &&
            filter.commune!.trim().isNotEmpty &&
            p.commune.toLowerCase() != filter.commune!.trim().toLowerCase()) {
          return false;
        }
        if (filter.query != null && filter.query!.trim().isNotEmpty) {
          final q = filter.query!.trim().toLowerCase();
          final text = '${p.title} ${p.description} ${p.address}'.toLowerCase();
          if (!text.contains(q)) return false;
        }
        return true;
      }).toList();
      return items;
    });
  }

  @override
  Stream<List<Property>> watchByOwner(String ownerId) {
    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Property.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Future<Property?> getById(String propertyId) async {
    final snapshot = await _collection.doc(propertyId).get();
    if (!snapshot.exists) return null;
    return Property.fromMap(snapshot.id, snapshot.data()!);
  }

  @override
  Future<void> create(Property property) async {
    final payload = {
      ...property.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _collection.add(payload);
  }

  @override
  Future<void> update(Property property) async {
    final payload = {
      ...property.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _collection.doc(property.id).update(payload);
  }

  @override
  Future<void> delete(String propertyId) {
    return _collection.doc(propertyId).delete();
  }
}

class InMemoryPropertyFirestoreService implements PropertyFirestoreService {
  final List<Property> _items = List<Property>.of(kMockProperties);
  final StreamController<List<Property>> _controller =
      StreamController<List<Property>>.broadcast();

  void _emit() {
    _controller.add(List.unmodifiable(_items.reversed));
  }

  @override
  Stream<List<Property>> watchAll({PropertyFilter? filter}) {
    _emit();
    return _controller.stream.map((items) {
      if (filter == null || filter.isEmpty) return items;
      return items.where((p) {
        if (filter.minPrice != null && p.price < filter.minPrice!) return false;
        if (filter.maxPrice != null && p.price > filter.maxPrice!) return false;
        if (filter.commune != null &&
            filter.commune!.trim().isNotEmpty &&
            p.commune.toLowerCase() != filter.commune!.trim().toLowerCase()) {
          return false;
        }
        if (filter.query != null && filter.query!.trim().isNotEmpty) {
          final q = filter.query!.trim().toLowerCase();
          final text = '${p.title} ${p.description} ${p.address}'.toLowerCase();
          if (!text.contains(q)) return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Stream<List<Property>> watchByOwner(String ownerId) {
    _emit();
    return _controller.stream.map(
      (items) => items.where((p) => p.ownerId == ownerId).toList(),
    );
  }

  @override
  Future<Property?> getById(String propertyId) async {
    try {
      return _items.firstWhere((item) => item.id == propertyId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> create(Property property) async {
    _items.add(property);
    _emit();
  }

  @override
  Future<void> update(Property property) async {
    final index = _items.indexWhere((item) => item.id == property.id);
    if (index >= 0) {
      _items[index] = property;
      _emit();
    }
  }

  @override
  Future<void> delete(String propertyId) async {
    _items.removeWhere((item) => item.id == propertyId);
    _emit();
  }
}
