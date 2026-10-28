/// Provider the user signed in with.
enum AuthProviderType { google, facebook, other }

/// App-level user model. Keeps Firebase types out of ViewModels and Views.
class AppUser {
  const AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.provider,
  });

  final String uid;
  final String displayName;
  final String? email;
  final String? photoUrl;
  final AuthProviderType provider;

  String get firstName => displayName.split(' ').first;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts.last[0] : '';
    return (first + second).toUpperCase();
  }
}
