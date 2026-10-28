import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/app_user.dart';
import '../../data/models/article.dart';
import 'article_view.dart';
import 'home_viewmodel.dart';

/// Medium-style reading feed.
class MediumHomeView extends StatelessWidget {
  const MediumHomeView({
    super.key,
    required this.viewModel,
    required this.user,
    required this.onSignOut,
  });

  final HomeViewModel viewModel;
  final AppUser user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inkwell',
          style: TextStyle(
            fontFamily: AppTheme.serif,
            fontFamilyFallback: AppTheme.serifFallback,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          _AccountMenu(user: user, onSignOut: onSignOut),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading && viewModel.visibleArticles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null && viewModel.visibleArticles.isEmpty) {
            return _ErrorState(
              message: viewModel.error!,
              onRetry: viewModel.load,
            );
          }
          return RefreshIndicator(
            onRefresh: viewModel.load,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
                      child: Text(
                        'Welcome back, ${user.firstName}',
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _TopicBar(viewModel: viewModel),
                    const Divider(),
                    for (final article in viewModel.visibleArticles) ...[
                      _ArticleCard(
                        article: article,
                        saved: viewModel.isSaved(article),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ArticleView(article: article),
                          ),
                        ),
                        onToggleSaved: () => viewModel.toggleSaved(article),
                      ),
                      const Divider(indent: 20, endIndent: 20),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AccountMenu extends StatelessWidget {
  const _AccountMenu({required this.user, required this.onSignOut});

  final AppUser user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(0, 48),
      onSelected: (value) {
        if (value == 'signout') onSignOut();
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (user.email != null)
                Text(
                  user.email!,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(value: 'signout', child: Text('Sign out')),
      ],
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppTheme.accents[0],
        foregroundImage:
            user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
        child: Text(
          user.initials,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
          ),
        ),
      ),
    );
  }
}

class _TopicBar extends StatelessWidget {
  const _TopicBar({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: viewModel.topics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final topic = viewModel.topics[i];
          final selected = topic == viewModel.selectedTopic;
          return ChoiceChip(
            label: Text(topic),
            selected: selected,
            onSelected: (_) => viewModel.selectTopic(topic),
            selectedColor: AppTheme.ink,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppTheme.ink,
              fontSize: 13,
            ),
            shape: const StadiumBorder(),
          );
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.article,
    required this.saved,
    required this.onTap,
    required this.onToggleSaved,
  });

  final Article article;
  final bool saved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;

  static String _date(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.accents[article.accentIndex % AppTheme.accents.length];
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: color,
                  child: Text(
                    article.author[0],
                    style: const TextStyle(fontSize: 11, color: AppTheme.ink),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  article.author,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontFamily: AppTheme.serif,
                          fontFamilyFallback: AppTheme.serifFallback,
                          fontSize: 20,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    article.topic[0],
                    style: const TextStyle(
                      fontFamily: AppTheme.serif,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${_date(article.publishedAt)}  ·  ${article.readMinutes} min read',
                  style: const TextStyle(fontSize: 13, color: AppTheme.muted),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    article.topic,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: saved ? 'Remove from reading list' : 'Save',
                  icon: Icon(
                    saved ? Icons.bookmark : Icons.bookmark_border,
                    color: saved ? AppTheme.ink : AppTheme.muted,
                  ),
                  onPressed: onToggleSaved,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
