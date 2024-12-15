import 'package:flutter_app/Product.dart';

class CartItem {
  int quantity;

  String productName;
  double price;
  String imgURL;
  String id;
  CartItem(this.imgURL, this.price, this.productName, this.quantity, this.id);

  factory CartItem.fromMap(Map<String, dynamic> map, {required String id}) {
    return CartItem(
        map['imageURL']?.toString() ?? '',
        (map['price'] is num) ? map['price'].toDouble() : 0.0,
        map['productName']?.toString() ?? '',
        (map['quantity'] is int) ? map['quantity'] : 0,
        id);
  }
}
