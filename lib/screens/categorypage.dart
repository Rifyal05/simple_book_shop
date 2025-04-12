import 'package:flutter/material.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';
import '../UI/book_list.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryName,
  });

  List<Book> _getBooksForCategory(String category) {
    List<Book> allBooks = bookList;
    if (category == 'Fiksi') {
      return allBooks.take(3).toList();
    } else if (category == 'Sains') {
      return allBooks.skip(3).take(3).toList();
    } else if (category == 'Anak-Anak') {
      return allBooks.skip(6).take(2).toList();
    } else {
      return allBooks.skip(1).take(4).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Book> categoryBooks = _getBooksForCategory(categoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        elevation: 1.0,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      ),
      body: categoryBooks.isEmpty
          ? Center(
        child: Text(
          'Belum ada produk untuk kategori "$categoryName"',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BookList(
            books: categoryBooks,
            searchText: '',
          ),
        ),
      ),
    );
  }
}