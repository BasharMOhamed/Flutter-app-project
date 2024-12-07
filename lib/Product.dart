class Product {
   String ID;
   String imgURL;
   String name;
   double price;
   String description;
   String category;
   int quantityInStock;

  Product( {required this.ID, required this.imgURL,required this.name, required this.price,required this.description,required this.category,required this.quantityInStock});
}

class CartItem {
  Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
