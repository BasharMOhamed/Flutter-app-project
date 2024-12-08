class Product {
   int ID;
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
  int id;

  CartItem({required this.product, required this.quantity,required this.id});

   factory CartItem.fromMap(Map<String, dynamic> map, {required int id}) {
    return CartItem(
    product:  map['product'] is Product
          ? map['product'] 
          : Product(ID:3,imgURL: 'baa',name: 'eva',price: 10.0, description:'bbb',category: 'vvv',quantityInStock: 10),
       quantity:  map['quantity'] ?? 0,
       id:  id );
  }
}
