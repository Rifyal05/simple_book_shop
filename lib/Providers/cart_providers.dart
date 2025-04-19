import 'package:flutter/material.dart';
import 'package:simple_ecommerce/Model/products.dart';
import 'package:simple_ecommerce/Model/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => [..._items];

  double get totalPrice {
    return _items.fold(
        0.0, (sum, item) => sum + (item.book.price * item.quantity));
  }

  int get itemCount {
    return _items.length;
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(Book book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItemModel(book: book, quantity: 1));
    }
    notifyListeners();
  }

  void removeItemById(String bookId) {
    _items.removeWhere((item) => item.id == bookId);
    notifyListeners();
  }

  void increaseQuantity(String bookId) {
    final index = _items.indexWhere((item) => item.id == bookId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String bookId) {
    final index = _items.indexWhere((item) => item.id == bookId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
