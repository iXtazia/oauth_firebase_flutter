import 'dart:async';

import 'package:oauth_firebase_flutter/data/models/app_user.dart';
import 'package:oauth_firebase_flutter/data/models/auth_failure.dart';
import 'package:oauth_firebase_flutter/data/repositories/auth_repository.dart';

const testUser = AppUser(
  uid: 'u1',
  displayName: 'Ada Lovelace',
  email: 'ada@example.com',
  photoUrl: null,
  provider: AuthProviderType.google,
);

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<AppUser?>.broadcast();
  Object? errorToThrow;
  Completer<void>? gate;
  int googleCalls = 0;
  int facebookCalls = 0;
  AppUser? _current;

  @override
  Stream<AppUser?> get userChanges => _controller.stream;

  @override
  AppUser? get currentUser => _current;

  Future<AppUser> _signIn() async {
    await gate?.future;
    if (errorToThrow != null) throw errorToThrow!;
    _current = testUser;
    _controller.add(testUser);
    return testUser;
  }

  @override
  Future<AppUser> signInWithGoogle() {
    googleCalls++;
    return _signIn();
  }

  @override
  Future<AppUser> signInWithFacebook() {
    facebookCalls++;
    return _signIn();
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }

  void emit(AppUser? user) {
    _current = user;
    _controller.add(user);
  }
}

AuthFailure failure(String m) => AuthFailure(m);
