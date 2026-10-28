class Article {
  const Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.topic,
    required this.publishedAt,
    required this.readMinutes,
    required this.paragraphs,
    required this.accentIndex,
  });

  final String id;
  final String title;
  final String subtitle;
  final String author;
  final String topic;
  final DateTime publishedAt;
  final int readMinutes;
  final List<String> paragraphs;

  /// Picks a thumbnail colour (no network images needed).
  final int accentIndex;
}
