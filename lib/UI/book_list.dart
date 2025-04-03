import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Model/products.dart';
import '../Providers/cart_providers.dart';

class BookList extends StatelessWidget {
  final List<Book> books;
  final String searchText;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const BookList({
    super.key,
    required this.books,
    this.searchText = '',
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final NumberFormat rupiahFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    List<Book> filteredBooks = _filterBooks(books, searchText);

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        final book = filteredBooks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 125,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CachedNetworkImage(
                      imageUrl: book.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        book.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'oleh ${book.author}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rupiahFormat.format(book.price),
                        style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    cart.addItem(book);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${book.title} ditambahkan ke keranjang'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Book> _filterBooks(List<Book> books, String searchText) {
    if (searchText.isEmpty) {
      return books;
    } else {
      final searchLower = searchText.toLowerCase();
      return books
          .where((book) =>
      book.title.toLowerCase().contains(searchLower) ||
          book.author.toLowerCase().contains(searchLower))
          .toList();
    }
  }
}