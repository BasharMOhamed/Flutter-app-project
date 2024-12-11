import 'package:flutter_app/Product.dart';
class CartItem {
  int quantity;

  String productName;
  double price;
  String imgURL;
  String id;
  CartItem(this.imgURL, this.price, this.productName, this.quantity, this.id);

  factory CartItem.fromMap(Map<String, dynamic> map, {required String id}) {
    return CartItem(map['imageURL'], map['price'], map['productName'],
        map['quantity'] ?? 0, id);
  }
}
