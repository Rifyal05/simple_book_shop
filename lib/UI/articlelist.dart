import 'package:flutter/material.dart';

import '../Model/article.dart';
import 'articlecard.dart';
class ArticleList extends StatelessWidget {
  final List<Article> articles;

  const ArticleList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ArticleCard(
            title: article.title,
            summary: article.summary,
            imageUrl: article.imageUrl,
            date: article.date,
            onTap: () {
              print('Artikel ${article.title} diklik');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Menuju halaman ${article.title}')),
              );
            },
          );
        },
      ),
    );
  }
}