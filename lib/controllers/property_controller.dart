import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/property.dart';
import '../models/property_filter.dart';
import '../services/firestore/property_firestore_service.dart';

class PropertyController extends ChangeNotifier {
  PropertyController({required PropertyFirestoreService propertyService})
    : _propertyService = propertyService;

  final PropertyFirestoreService _propertyService;
  StreamSubscription<List<Property>>? _subscription;

  final List<Property> _properties = [];
  PropertyFilter _filter = const PropertyFilter();
  bool _isLoading = false;
  String? _errorMessage;

  List<Property> get properties => List.unmodifiable(_properties);
  PropertyFilter get filter => _filter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void startWatching() {
    _subscription?.cancel();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    _subscription = _propertyService
        .watchAll(filter: _filter)
        .listen(
          (items) {
            _properties
              ..clear()
              ..addAll(items);
            _isLoading = false;
            notifyListeners();
          },
          onError: (Object error) {
            _errorMessage = error.toString();
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  void applyFilter(PropertyFilter filter) {
    _filter = filter;
    startWatching();
  }

  Future<void> createProperty(Property property) async {
    await _runGuarded(() => _propertyService.create(property));
  }

  Future<void> updateProperty(Property property) async {
    await _runGuarded(() => _propertyService.update(property));
  }

  Future<void> deleteProperty(String propertyId) async {
    await _runGuarded(() => _propertyService.delete(propertyId));
  }

  Future<void> _runGuarded(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
