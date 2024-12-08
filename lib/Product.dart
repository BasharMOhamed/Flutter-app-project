class Product {
  String imgURL;
  String name;
  double price;
  String description;
  String category;
  int quantityInStock;
  int id;

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
        id ?? 0);
  }
}
