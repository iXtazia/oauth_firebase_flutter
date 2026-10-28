import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_failure.dart';

/// Talks to the Firebase / Google SDKs. Nothing above this layer imports them.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _auth = firebaseAuth ?? FirebaseAuth.instance,
      _google = googleSignIn ?? GoogleSignIn.instance;

  /// Web OAuth client ID (Firebase console > Authentication > Google).
  /// Needed on Android when google-services.json has no oauth_client entry.
  /// Pass with: --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com
  static const _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  Future<void>? _googleInit;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // google_sign_in v7: initialize() must be called exactly once.
  Future<void> _ensureGoogleInitialized() {
    return _googleInit ??= _google.initialize(
      serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
    );
  }

  Future<User> signInWithGoogle() async {
    try {
      await _ensureGoogleInitialized();
      if (!_google.supportsAuthenticate()) {
        throw const AuthFailure('Google sign-in is not supported here.');
      }
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthFailure('Google did not return an ID token.');
      }
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return _requireUser(result);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelled();
      }
      throw AuthFailure('Google sign-in failed (${e.code.name}).');
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  /// Uses Firebase's built-in OAuth flow (system browser), so no Facebook SDK
  /// or native Facebook config is needed. App ID/secret live in the Firebase
  /// console only.
  Future<User> signInWithFacebook() async {
    try {
      final provider = FacebookAuthProvider()
        ..addScope('email')
        ..addScope('public_profile');
      final result = await _auth.signInWithProvider(provider);
      return _requireUser(result);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _ensureGoogleInitialized();
      await _google.signOut();
    } catch (_) {
      // Not signed in with Google (or not initialised): nothing to clear.
    }
    await _auth.signOut();
  }

  User _requireUser(UserCredential result) {
    final user = result.user;
    if (user == null) throw const AuthFailure('Sign-in returned no user.');
    return user;
  }

  Exception _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'canceled':
      case 'web-context-canceled':
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return const AuthCancelled();
      case 'account-exists-with-different-credential':
        return const AuthFailure(
          'An account already exists with this email using another '
          'sign-in method. Sign in with that one first.',
        );
      case 'network-request-failed':
        return const AuthFailure('No network connection. Please try again.');
      case 'operation-not-allowed':
        return const AuthFailure(
          'This sign-in method is not enabled in the Firebase console.',
        );
      case 'user-disabled':
        return const AuthFailure('This account has been disabled.');
      default:
        return AuthFailure(e.message ?? 'Authentication failed (${e.code}).');
    }
  }
}
