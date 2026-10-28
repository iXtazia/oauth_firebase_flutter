import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/article_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'ui/auth/login_view.dart';
import 'ui/auth/login_viewmodel.dart';
import 'ui/auth/session_viewmodel.dart';
import 'ui/home/home_viewmodel.dart';
import 'ui/home/medium_home_view.dart';

/// Root widget. Owns the long-lived ViewModels (composition root for the UI).
class App extends StatefulWidget {
  const App({
    super.key,
    required this.authRepository,
    required this.articleRepository,
  });

  final AuthRepository authRepository;
  final ArticleRepository articleRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SessionViewModel _session;
  late final LoginViewModel _login;
  late final HomeViewModel _home;

  @override
  void initState() {
    super.initState();
    _session = SessionViewModel(widget.authRepository);
    _login = LoginViewModel(widget.authRepository);
    _home = HomeViewModel(widget.articleRepository);
    _session.addListener(_syncFeed);
    _syncFeed();
  }

  // Load the feed when signed in.
  bool _feedRequested = false;
  void _syncFeed() {
    if (_session.status == SessionStatus.signedIn) {
      if (!_feedRequested) {
        _feedRequested = true;
        _home.load();
      }
    } else {
      _feedRequested = false;
    }
  }

  @override
  void dispose() {
    _session.removeListener(_syncFeed);
    _session.dispose();
    _login.dispose();
    _home.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inkwell',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: ListenableBuilder(
        listenable: _session,
        builder: (context, _) {
          switch (_session.status) {
            case SessionStatus.loading:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case SessionStatus.signedOut:
              return LoginView(viewModel: _login);
            case SessionStatus.signedIn:
              return MediumHomeView(
                viewModel: _home,
                user: _session.user!,
                onSignOut: _session.signOut,
              );
          }
        },
      ),
    );
  }
}
