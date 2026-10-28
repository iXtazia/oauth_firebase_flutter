import '../models/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> fetchArticles();
}

/// In-memory sample feed. Swap for Firestore / REST without touching the UI.
class SampleArticleRepository implements ArticleRepository {
  @override
  Future<List<Article>> fetchArticles() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _articles;
  }
}

final _articles = <Article>[
  Article(
    id: '1',
    title: 'Why MVVM keeps Flutter apps calm as they grow',
    subtitle:
        'Views draw, ViewModels decide, repositories fetch. Three rules that '
        'end most spaghetti.',
    author: 'Camille Laurent',
    topic: 'Flutter',
    publishedAt: DateTime(2026, 10, 24),
    readMinutes: 6,
    accentIndex: 0,
    paragraphs: const [
      'Every Flutter project starts with a single widget and a setState call. '
          'It works, until the widget also talks to a server, formats dates and '
          'decides what to show on failure.',
      'MVVM splits those jobs. The View only renders state and forwards taps. '
          'The ViewModel owns that state and exposes actions. The repository '
          'hides where data comes from.',
      'The payoff shows up in tests: a ViewModel can be tested with a fake '
          'repository and no widgets at all.',
    ],
  ),
  Article(
    id: '2',
    title: 'Sign in with Google and Facebook using only Firebase Auth',
    subtitle:
        'You can skip the Facebook SDK entirely and let Firebase run the '
        'OAuth flow for you.',
    author: 'Nolan Brooks',
    topic: 'Firebase',
    publishedAt: DateTime(2026, 10, 21),
    readMinutes: 8,
    accentIndex: 1,
    paragraphs: const [
      'Native social SDKs bring manifest edits, hash keys and plist entries. '
          'Firebase can run the OAuth dance in a browser tab and hand back a '
          'credential instead.',
      'You still configure each provider once in the console, and register '
          'the redirect URI with the provider.',
    ],
  ),
  Article(
    id: '3',
    title: 'What UPS telemetry teaches you about anomaly detection',
    subtitle:
        'Most “anomalies” are a battery doing exactly what batteries do.',
    author: 'Mei Zhang',
    topic: 'IoT',
    publishedAt: DateTime(2026, 10, 18),
    readMinutes: 9,
    accentIndex: 2,
    paragraphs: const [
      'Streaming voltage, load and temperature every few seconds produces a '
          'lot of noise. The first win is knowing what normal looks like per '
          'device, not globally.',
      'Isolation-based methods are a good baseline because they need little '
          'tuning, but context such as time of day still matters.',
    ],
  ),
  Article(
    id: '4',
    title: 'Writing a go-to-market plan nobody ignores',
    subtitle: 'One page, three audiences, and a ruthless “not now” list.',
    author: 'Elena Rossi',
    topic: 'Product',
    publishedAt: DateTime(2026, 10, 15),
    readMinutes: 5,
    accentIndex: 3,
    paragraphs: const [
      'Plans get ignored when they try to please everyone. Start with the '
          'single customer problem and work outwards.',
      'Give each regional team a clear role, then list what you are '
          'deliberately not doing this quarter.',
    ],
  ),
  Article(
    id: '5',
    title: 'Learning Mandarin as a developer: build your own flashcards',
    subtitle:
        'Spaced repetition plus a language model makes a surprisingly good '
        'tutor.',
    author: 'Hugo Martin',
    topic: 'Flutter',
    publishedAt: DateTime(2026, 10, 9),
    readMinutes: 7,
    accentIndex: 4,
    paragraphs: const [
      'Tones and characters reward daily, short sessions. A small app that '
          'schedules reviews will beat any marathon weekend.',
      'Let a language model generate example sentences, but keep the review '
          'schedule deterministic.',
    ],
  ),
];
