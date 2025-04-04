import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Model/products.dart';
import '../Providers/cart_providers.dart';

class BookList extends StatelessWidget {
  final List<Book> books;
  final String searchText;

  const BookList({super.key, required this.books, this.searchText = ''});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final NumberFormat rupiahFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    List<Book> filteredBooks = _filterBooks(books, searchText);

    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menuju halaman produk lengkap')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat Lengkap',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          ...filteredBooks.map((book) => Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 125,
                    margin: const EdgeInsets.only(right: 16.0),
                    child: CachedNetworkImage(
                      imageUrl: book.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          image: DecorationImage(
                            image: ResizeImage(imageProvider, width: 500, height: 709),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'oleh ${book.author}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          rupiahFormat.format(book.price),
                          style: const TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      Book addedBook = book;
                      cart.addItem(addedBook);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${addedBook.title} ditambahkan'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              cart.removeItem(addedBook);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${addedBook.title} dihapus dari keranjang')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  List<Book> _filterBooks(List<Book> books, String searchText) {
    if (searchText.isEmpty) {
      return books;
    } else {
      return books
          .where((book) =>
      book.title.toLowerCase().contains(searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }
}