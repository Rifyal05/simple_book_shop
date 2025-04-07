import 'package:simple_ecommerce/Model/products.dart';

class CartItemModel {
  final String id;
  final Book book;
  int quantity;

  CartItemModel({required this.book, this.quantity = 1}) : id = book.id;
  CartItemModel copyWith({
    int? quantity,
  }) {
    return CartItemModel(
      book: book,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartItemModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}