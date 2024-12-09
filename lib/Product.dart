class Product {
  String imgURL;
  String name;
  double price;
  String description;
<<<<<<< HEAD
 String category;
int quantityInStock;

  Product(this.imgURL, this.name, this.price, this.description, this.category,
      this.quantityInStock);

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      map['imgURL'].toString().trim() ?? '',
      map['name'] ?? '',
      map['price']?.toDouble() ?? 0.0,
      map['description'] ?? '',
      map['category'] ?? '',
      map['quantityInStock']?.toInt() ?? 0,
    );
  }
=======
  String category;
  Product(this.imgURL, this.name, this.price, this.description, this.category);
>>>>>>> e243eb7 (Finishing the product Details page)
}
