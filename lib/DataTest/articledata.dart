import '../Model/article.dart';

List<Article> articleList = [
  Article(
    title: 'Judul Artikel 1',
    summary: 'Ringkasan artikel 1. Ini adalah ringkasan singkat tentang isi artikel...',
    imageUrl: 'https://static01.nyt.com/images/2025/03/06/books/review/springpreview-fiction/springpreview-fiction-articleLarge.png?quality=75&auto=webp&disable=upscale',
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Article(
    title: 'Judul Artikel 2',
    summary: 'Ringkasan artikel 2. Artikel ini membahas topik yang menarik...',
    imageUrl: 'https://static01.nyt.com/images/2025/03/06/books/review/springpreview-fiction/springpreview-fiction-articleLarge.png?quality=75&auto=webp&disable=upscale',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Article(
    title: 'Judul Artikel 3',
    summary: 'Ringkasan artikel 3. Temukan informasi terbaru di artikel ini...',
    imageUrl: 'https://static01.nyt.com/images/2025/03/06/books/review/springpreview-fiction/springpreview-fiction-articleLarge.png?quality=75&auto=webp&disable=upscale',
    date: DateTime.now().subtract(const Duration(days: 3)),
  ),
];