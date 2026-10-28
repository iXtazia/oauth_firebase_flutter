/// A user-presentable authentication error.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thrown when the user closes the sign-in sheet/browser. Not an error to show.
class AuthCancelled implements Exception {
  const AuthCancelled();
}
