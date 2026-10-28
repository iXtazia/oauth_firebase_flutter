import 'package:flutter/material.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:oauth_firebase_flutter/app.dart';
import 'package:oauth_firebase_flutter/data/repositories/article_repository.dart';

import 'fakes.dart';

void main() {
  testWidgets('login screen -> Medium-style feed -> sign out', (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(
      App(authRepository: repo, articleRepository: SampleArticleRepository()),
    );

    // Auth stream has not emitted yet: spinner.
    repo.emit(null);
    await tester.pump();
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);

    await tester.tap(find.byKey(const Key('google_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Welcome back, Ada'), findsOneWidget);
    expect(find.text('For you'), findsOneWidget);
    expect(find.textContaining('MVVM'), findsWidgets);

    repo.emit(null);
    await tester.pump();
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
