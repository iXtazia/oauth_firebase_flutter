import 'package:flutter/foundation.dart';

import '../../data/models/article.dart';
import '../../data/repositories/article_repository.dart';

/// State for the Medium-style feed.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);

  static const allTopics = 'For you';

  final ArticleRepository _repository;

  List<Article> _articles = const [];
  final Set<String> _saved = {};
  String _topic = allTopics;
  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;
  String get selectedTopic => _topic;

  List<String> get topics => [
    allTopics,
    ...{for (final a in _articles) a.topic},
  ];

  List<Article> get visibleArticles => _topic == allTopics
      ? _articles
      : _articles.where((a) => a.topic == _topic).toList();

  bool isSaved(Article article) => _saved.contains(article.id);

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _articles = await _repository.fetchArticles();
    } catch (_) {
      _error = 'Could not load stories. Pull to retry.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectTopic(String topic) {
    if (topic == _topic) return;
    _topic = topic;
    notifyListeners();
  }

  void toggleSaved(Article article) {
    if (!_saved.remove(article.id)) _saved.add(article.id);
    notifyListeners();
  }
}
