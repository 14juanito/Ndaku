import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth/auth_service.dart';

enum SessionStatus { checking, authenticated, unauthenticated }

class SessionController extends ChangeNotifier {
  SessionController(this._authService);

  final AuthService _authService;
  StreamSubscription<AppUser?>? _subscription;

  SessionStatus _status = SessionStatus.checking;
  AppUser? _currentUser;

  SessionStatus get status => _status;
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _status == SessionStatus.authenticated;

  void start() {
    _currentUser = _authService.currentUser;
    _status = _currentUser == null
        ? SessionStatus.unauthenticated
        : SessionStatus.authenticated;
    notifyListeners();

    _subscription ??= _authService.authStateChanges().listen((user) {
      _currentUser = user;
      _status = user == null
          ? SessionStatus.unauthenticated
          : SessionStatus.authenticated;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
