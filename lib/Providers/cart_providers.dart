import 'package:flutter/material.dart';

import '../Model/products.dart';

class CartProvider with ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => [..._items];

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price);
  }

  void addItem(Book book) {
    _items.add(book);
    notifyListeners();
  }

  void removeItem(Book book) {
    _items.remove(book);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
