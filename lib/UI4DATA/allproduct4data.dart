import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../Model/products.dart';
import '../Providers/cart_providers.dart';

class AllProduct4Data extends StatelessWidget {
  final List<Book> books;
  final String searchText;

  const AllProduct4Data({super.key, required this.books, this.searchText = ''});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final NumberFormat rupiahFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    List<Book> filteredBooks = _filterBooks(books, searchText);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.builder(
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            return Card(
              margin: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: index == 0 ? 0.0 : 4.0,
                bottom: 4.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 110,
                      margin: const EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.grey[300],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: CachedNetworkImage(
                          imageUrl: book.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2.0)),
                          errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.book_outlined, color: Colors.grey, size: 40)),
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
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            rupiahFormat.format(book.price),
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                          tooltip: 'Tambah ke keranjang',
                          color: Theme.of(context).colorScheme.primary,
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
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                          content: Text(
                                              'Penambahan "${book.title}" dibatalkan')),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Menampilkan detail untuk: ${book.title}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            "Detail",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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