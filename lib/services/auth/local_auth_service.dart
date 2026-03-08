import 'dart:async';

import '../../models/app_user.dart';
import 'auth_service.dart';

class LocalAuthService implements AuthService {
  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();
  final Map<String, String> _passwordByEmail = {};
  final Map<String, AppUser> _userByEmail = {};

  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    final expected = _passwordByEmail[normalized];
    if (expected == null || expected != password) {
      throw Exception('user-not-found');
    }
    _currentUser = _userByEmail[normalized];
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (_passwordByEmail.containsKey(normalized)) {
      throw Exception('email-already-in-use');
    }
    final user = AppUser(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      email: normalized,
      fullName: fullName,
    );
    _passwordByEmail[normalized] = password;
    _userByEmail[normalized] = user;
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final user = AppUser(
      id: 'local_google_user',
      email: 'google.local@ndaku.app',
      fullName: 'Google User',
    );
    _currentUser = user;
    _controller.add(_currentUser);
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}
