import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:oauth_firebase_flutter/data/models/auth_failure.dart';
import 'package:oauth_firebase_flutter/ui/auth/login_viewmodel.dart';

import 'fakes.dart';

void main() {
  late FakeAuthRepository repo;
  late LoginViewModel vm;

  setUp(() {
    repo = FakeAuthRepository();
    vm = LoginViewModel(repo);
  });

  test('google sign-in succeeds and clears busy state', () async {
    await vm.signInWithGoogle();
    expect(repo.googleCalls, 1);
    expect(vm.isBusy, isFalse);
    expect(vm.errorMessage, isNull);
  });

  test('facebook failure exposes a message', () async {
    repo.errorToThrow = const AuthFailure('nope');
    await vm.signInWithFacebook();
    expect(vm.errorMessage, 'nope');
    expect(vm.isBusy, isFalse);
  });

  test('cancellation shows no error', () async {
    repo.errorToThrow = const AuthCancelled();
    await vm.signInWithGoogle();
    expect(vm.errorMessage, isNull);
  });

  test('unexpected errors get a generic message', () async {
    repo.errorToThrow = StateError('boom');
    await vm.signInWithGoogle();
    expect(vm.errorMessage, isNotNull);
  });

  test('ignores a second tap while busy', () async {
    repo.gate = Completer<void>();
    final first = vm.signInWithGoogle();
    expect(vm.isBusyWith(AuthProviderBusy.google), isTrue);
    await vm.signInWithFacebook();
    expect(repo.facebookCalls, 0);
    repo.gate!.complete();
    await first;
    expect(vm.isBusy, isFalse);
  });

  test('dismissError clears the message', () async {
    repo.errorToThrow = const AuthFailure('x');
    await vm.signInWithGoogle();
    vm.dismissError();
    expect(vm.errorMessage, isNull);
  });
}
