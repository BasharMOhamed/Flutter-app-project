import 'package:flutter_app/CartItem.dart';

class Order {
  final List<CartItem> items;
  final String feedback;
  final double rating;
  final String orderDate;
  final double totalPrice;
  Order(this.items, this.feedback, this.rating, this.totalPrice,this.orderDate);

  factory Order.fromMap(Map<String, dynamic> map) {
     
    String fullDate = map['orderDate']?.toString() ?? '';
    String formattedDate = fullDate.split('T').first; 
    return Order(
      (map['items'] as List<dynamic>? ?? [])
          .map((item) =>
              CartItem.fromMap(Map<String, dynamic>.from(item), id: ''))
          .toList(),
      map['feedback']?.toString() ?? 'No feedback',
      (map['rating'] is num) ? map['rating'].toDouble() : 0.0,
      (map['totalPrice'] is num) ? map['totalPrice'].toDouble() : 0.0,
      formattedDate,
      
    );
  }
}
