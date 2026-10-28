import 'package:flutter/foundation.dart';

import '../../data/models/auth_failure.dart';
import '../../data/repositories/auth_repository.dart';

/// State + actions for the login screen.
class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._repository);

  final AuthRepository _repository;

  AuthProviderBusy? _busy;
  String? _errorMessage;

  bool get isBusy => _busy != null;
  bool isBusyWith(AuthProviderBusy provider) => _busy == provider;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithGoogle() =>
      _run(AuthProviderBusy.google, _repository.signInWithGoogle);

  Future<void> signInWithFacebook() =>
      _run(AuthProviderBusy.facebook, _repository.signInWithFacebook);

  void dismissError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _run(AuthProviderBusy provider, Future<void> Function() action) async {
    if (isBusy) return;
    _busy = provider;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      // Success: SessionViewModel reacts to the auth stream and swaps screens.
    } on AuthCancelled {
      // User backed out; stay silent.
    } on AuthFailure catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _busy = null;
      notifyListeners();
    }
  }
}

enum AuthProviderBusy { google, facebook }
