class Product {
  String imgURL;
  String name;
  double price;
  String description;
  String category;
  int quantityInStock;
  String id;

  Product(this.imgURL, this.name, this.price, this.description, this.category,
      this.quantityInStock, this.id);

  factory Product.fromMap(Map<String, dynamic> map, id) {
    return Product(
        map['imgURL'].toString().trim() ?? '',
        map['name'] ?? '',
        map['price']?.toDouble() ?? 0.0,
        map['description'] ?? '',
        map['category'] ?? '',
        map['quantityInStock']?.toInt() ?? 0,
        id);
  }
}

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
