import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/products.dart';
import '../Providers/cart_providers.dart';

class BookList extends StatelessWidget {
  final List<Book> books;

  const BookList({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 120,
                  height: 150,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Image.network(
                    book.imageUrl,
                    fit: BoxFit.contain,
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
                        '\$${book.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, color: Colors.green[800]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cart.addItem(book);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${book.title} ditambahkan')),
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
}