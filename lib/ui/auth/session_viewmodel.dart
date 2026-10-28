import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/app_user.dart';
import '../../data/repositories/auth_repository.dart';

enum SessionStatus { loading, signedOut, signedIn }

/// App-wide session state: who is signed in right now.
class SessionViewModel extends ChangeNotifier {
  SessionViewModel(this._repository) {
    _user = _repository.currentUser;
    _status = _user == null ? SessionStatus.loading : SessionStatus.signedIn;
    _subscription = _repository.userChanges.listen(_onUser);
  }

  final AuthRepository _repository;
  late final StreamSubscription<AppUser?> _subscription;

  AppUser? _user;
  SessionStatus _status = SessionStatus.loading;

  AppUser? get user => _user;
  SessionStatus get status => _status;

  void _onUser(AppUser? user) {
    _user = user;
    _status = user == null ? SessionStatus.signedOut : SessionStatus.signedIn;
    notifyListeners();
  }

  Future<void> signOut() => _repository.signOut();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
