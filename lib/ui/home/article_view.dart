import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/article.dart';

/// Reader page for a single story.
class ArticleView extends StatelessWidget {
  const ArticleView({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
            children: [
              Text(
                article.title,
                style: const TextStyle(
                  fontFamily: AppTheme.serif,
                  fontFamilyFallback: AppTheme.serifFallback,
                  fontSize: 32,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${article.author}  ·  ${article.readMinutes} min read',
                style: const TextStyle(fontSize: 14, color: AppTheme.muted),
              ),
              const Divider(height: 40),
              for (final p in article.paragraphs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Text(
                    p,
                    style: const TextStyle(
                      fontFamily: AppTheme.serif,
                      fontFamilyFallback: AppTheme.serifFallback,
                      fontSize: 19,
                      height: 1.6,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
