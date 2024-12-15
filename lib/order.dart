import 'package:flutter_app/CartItem.dart';

class Order {
  final List<CartItem> items;
  final String feedback;
  final double rating;
  final double totalPrice;
  Order(this.items, this.feedback, this.rating, this.totalPrice);

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      (map['items'] as List<dynamic>? ?? [])
          .map((item) =>
              CartItem.fromMap(Map<String, dynamic>.from(item), id: ''))
          .toList(),
      map['feedback']?.toString() ?? 'No feedback',
      (map['rating'] is num) ? map['rating'].toDouble() : 0.0,
      (map['totalPrice'] is num) ? map['totalPrice'].toDouble() : 0.0,
    );
  }
}
