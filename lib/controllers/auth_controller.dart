import 'package:flutter/foundation.dart';

import '../core/utils/fire_error_mapper.dart';
import '../models/app_user.dart';
import '../services/auth/auth_service.dart';
import '../services/firestore/user_firestore_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthService authService,
    required UserFirestoreService userService,
  }) : _authService = authService,
       _userService = userService;

  final AuthService _authService;
  final UserFirestoreService _userService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    return _runGuarded(
      () => _authService.signInWithEmail(email: email, password: password),
    );
  }

  Future<AppUser?> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final user = await _runGuarded(
      () => _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
    if (user != null) {
      await _userService.upsertUser(user);
    }
    return user;
  }

  Future<AppUser?> loginWithGoogle() async {
    final user = await _runGuarded(_authService.signInWithGoogle);
    if (user != null) {
      await _userService.upsertUser(user);
    }
    return user;
  }

  Future<void> logout() async {
    await _runGuarded(_authService.signOut);
  }

  Future<T?> _runGuarded<T>(Future<T> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      return await action();
    } catch (error) {
      _errorMessage = mapFirebaseError(error);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
