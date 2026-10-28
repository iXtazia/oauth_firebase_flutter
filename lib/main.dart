import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/article_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/auth_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    App(
      authRepository: FirebaseAuthRepository(AuthService()),
      articleRepository: SampleArticleRepository(),
    ),
  );
}
