import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';

/// Contract used by ViewModels (easy to fake in tests).
abstract class AuthRepository {
  Stream<AppUser?> get userChanges;
  AppUser? get currentUser;
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithFacebook();
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._service);

  final AuthService _service;

  @override
  Stream<AppUser?> get userChanges =>
      _service.authStateChanges.map(_toAppUser);

  @override
  AppUser? get currentUser => _toAppUser(_service.currentUser);

  @override
  Future<AppUser> signInWithGoogle() async =>
      _toAppUser(await _service.signInWithGoogle())!;

  @override
  Future<AppUser> signInWithFacebook() async =>
      _toAppUser(await _service.signInWithFacebook())!;

  @override
  Future<void> signOut() => _service.signOut();

  AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    final providerId = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : '';
    return AppUser(
      uid: user.uid,
      displayName: user.displayName ?? user.email ?? 'Reader',
      email: user.email,
      photoUrl: user.photoURL,
      provider: switch (providerId) {
        'google.com' => AuthProviderType.google,
        'facebook.com' => AuthProviderType.facebook,
        _ => AuthProviderType.other,
      },
    );
  }
}
