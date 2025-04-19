import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart_providers.dart';
import '../Model/cart_item_model.dart';
import '../Model/products.dart';
import '../DataTest/bookdata.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<Book>> _recommendedBooksFuture;

  @override
  void initState() {
    super.initState();
    _recommendedBooksFuture = _fetchRecommendedBooks();
  }

  Future<List<Book>> _fetchRecommendedBooks() async {
    await Future.delayed(const Duration(milliseconds: 900));
    try {
      final recommendations = bookList.take(6).toList();
      return recommendations;
    } catch (error) {
      throw Exception("Gagal memuat rekomendasi");
    }
  }

  void _showClearCartConfirmationDialog(
      BuildContext context, CartProvider cart) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Kosongkan Keranjang'),
        content: const Text('Yakin ingin menghapus semua item dari keranjang?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          TextButton(
            child:
                Text('Hapus Semua', style: TextStyle(color: colorScheme.error)),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        cart.clearCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Kosongkan Keranjang',
              onPressed: () {
                _showClearCartConfirmationDialog(context, cart);
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                          child: Text('Keranjang belanja masih kosong.')),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (ctx, i) =>
                          CartListItem(cartItem: cartItems[i]),
                      separatorBuilder: (ctx, i) => const Divider(
                          height: 1.0,
                          thickness: 1.0,
                          indent: 16.0,
                          endIndent: 16.0),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32.0, bottom: 8.0, left: 16.0, right: 16.0),
                    child: Text('Rekomendasi Untukmu',
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: FutureBuilder<List<Book>>(
                      future: _recommendedBooksFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator()));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Oops! Gagal memuat rekomendasi.\nError: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada rekomendasi saat ini.'));
                        } else {
                          final recommendations = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 2 / 3.5,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8),
                            itemCount: recommendations.length,
                            itemBuilder: (ctx, index) => BookRecommendationCard(
                                book: recommendations[index]),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total:',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Chip(
                      label: Text('Rp ${cart.totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold)),
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8)),
                  const Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary),
                      onPressed: cartItems.isEmpty ? null : () {},
                      child: const Text('CHECKOUT'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  final CartItemModel cartItem;
  const CartListItem({required this.cartItem, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const double imageSize = 85.0;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: imageSize,
              height: imageSize,
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              margin: const EdgeInsets.only(right: 16.0),
              child: Image.network(cartItem.book.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      color: Colors.grey[600],
                      size: 40),
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : Center(
                              child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ))),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.book.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text('Rp ${cartItem.book.price.toStringAsFixed(0)} / item',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.secondary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Detail untuk: ${cartItem.book.title}')));
                        },
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text("Detail",
                                style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500)))),
                    InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              title: const Text('Hapus Item'),
                              content: Text(
                                  'Yakin ingin menghapus ${cartItem.book.title} dari keranjang?'),
                              actions: <Widget>[
                                TextButton(
                                    child: const Text('Batal'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    }),
                                TextButton(
                                    child: Text('Hapus',
                                        style: TextStyle(
                                            color: colorScheme.error)),
                                    onPressed: () {
                                      Navigator.of(ctx).pop(true);
                                    }),
                              ],
                            ),
                          ).then((confirmed) {
                            if (confirmed == true) {
                              cart.removeItemById(cartItem.book.id);
                            }
                          });
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Icon(Icons.delete_outline,
                                color: colorScheme.error, size: 28))),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () => cart.decreaseQuantity(cartItem.book.id),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Icon(Icons.remove_circle_outline,
                                size: 24,
                                color:
                                    colorScheme.onSurface.withOpacity(0.6)))),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(cartItem.quantity.toString(),
                            style: textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold))),
                    InkWell(
                        onTap: () => cart.addItem(cartItem.book),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Icon(Icons.add_circle_outline,
                                size: 24, color: colorScheme.primary))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookRecommendationCard extends StatelessWidget {
  final Book book;
  const BookRecommendationCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Tap on: ${book.title}')));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Image.network(
                book.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 30, color: Colors.grey)),
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          )),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(book.title,
                        style: textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(book.author,
                        style: textTheme.bodySmall
                            ?.copyWith(fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Text('Rp ${book.price.toStringAsFixed(0)}',
                        style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
