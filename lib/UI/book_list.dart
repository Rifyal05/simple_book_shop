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
                const SnackBar(content: Text('Fitur "Lihat Lengkap" belum ada')),
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
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 110,
                    margin: const EdgeInsets.only(right: 12.0),
                    child: CachedNetworkImage(
                      imageUrl: book.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                      errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.book, color: Colors.grey)),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'oleh ${book.author}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          rupiahFormat.format(book.price),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    tooltip: 'Tambah ke keranjang',
                    // color: Theme.of(context).primaryColor,
                    color: Colors.white,
                    onPressed: () {
                      cart.addItem(book);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${book.title}" ditambahkan'),
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              cart.decreaseQuantity(book.id);

                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Penambahan "${book.title}" dibatalkan')),
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
      String lowerSearchText = searchText.toLowerCase();
      return books
          .where((book) =>
      book.title.toLowerCase().contains(lowerSearchText) ||
          book.author.toLowerCase().contains(lowerSearchText))
          .toList();
    }
  }
}