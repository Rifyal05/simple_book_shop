import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DataTest/articledata.dart';
import '../Model/article.dart';
import '../UI4BUILD/articlecard.dart';

class AllArticlesPage extends StatelessWidget {
  const AllArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Article> articles = articleList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel & Berita"),
        elevation: 1.0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ArticleCard(
              title: article.title,
              summary: article.summary,
              imageUrl: article.imageUrl,
              date: article.date,
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Membuka artikel: ${article.title}"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}