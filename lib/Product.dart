class Product {
  String imgURL;
  String name;
  double price;
  String description;
<<<<<<< HEAD
<<<<<<< HEAD
 String category;
int quantityInStock;
=======
  String category;
  int quantityInStock;
>>>>>>> 33b21bb4d0502c9247db7447665b2c03618e1f89

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
