import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/products.dart';
import '../Providers/cart_providers.dart';

class CartItem extends StatelessWidget {
  final Book book;

  CartItem({required this.book});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      child: ListTile(
        leading: Image.network(book.imageUrl, width: 50, height: 70),
        title: Text(book.title),
        subtitle: Text('\$${book.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.remove_shopping_cart),
          onPressed: () {
            cart.removeItem(book);
          },
        ),
      ),
    );
  }
}
