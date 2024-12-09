import 'package:flutter_app/Product.dart';

class CartItem {
  final String imgURL;
  final double price;
  final String productName;
  final int qty;
  CartItem(this.productName, this.price, this.imgURL, this.qty);
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      map['productName'] as String,
      (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price'] ?? 0.0,
      map['imgURL'] as String,
      map['quantity'] as int,
    );
  }
}
