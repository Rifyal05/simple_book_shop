import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/products.dart';
import '../Providers/cart_providers.dart';
import 'book_list.dart';

class Dashboard extends StatelessWidget {
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'Buku 1',
      author: 'Penulis Buku 1',
      price: 25.000,
      imageUrl: 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/97/MTA-146437441/reneluv_selalu_ada_ruang_untuk_pulang_buku_novel_by-_karima_ifha_-_penerbit_reneluv_full01_vkmkazji.jpg',
    ),
    Book(
      id: '2',
      title: 'Buku 2',
      author: 'Penulis Buku 2',
      price: 30.000,
      imageUrl: 'https://cdn.gramedia.com/uploads/items/9786239712716.jpg',
    ),
    Book(
      id: '3',
      title: 'Buku 3',
      author: 'Penulis Buku 3',
      price: 20.000,
      imageUrl: 'https://deepublishstore.com/wp-content/uploads/2018/01/Wujud-Tanpa-Suara-Nurul-depan1.jpg',
    ),
  ];

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DASHBOARD"),
      ),
      body: BookList(books: _books),
    );
  }
}