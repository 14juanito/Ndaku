import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_user.dart';

abstract class UserFirestoreService {
  Future<void> upsertUser(AppUser user);
  Future<AppUser?> getUser(String uid);
}

class FirebaseUserFirestoreService implements UserFirestoreService {
  FirebaseUserFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<void> upsertUser(AppUser user) async {
    await _users.doc(user.id).set({
      ...user.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AppUser.fromMap(doc.id, doc.data()!);
  }
}

class LocalUserService implements UserFirestoreService {
  final Map<String, AppUser> _users = {};

  @override
  Future<AppUser?> getUser(String uid) async => _users[uid];

  @override
  Future<void> upsertUser(AppUser user) async {
    _users[user.id] = user;
  }
}
