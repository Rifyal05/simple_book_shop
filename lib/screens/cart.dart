import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/cart_providers.dart';
import '../UI/cart_item.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItem(book: cart.items[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    cart.clearCart();
                    Navigator.pop(context); // Kembali ke beranda
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Keranjang dikosongkan')),
                    );
                  },
                  child: Text('Bayar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}