import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Product.dart';


class productList extends StatefulWidget{
  @override
  _productListState  createState() => _productListState();
}
class _productListState extends State<productList>{
  List<Product> products  = [
    Product(ID: '1'
      ,imgURL:'https://via.placeholder.com/150',
     name:'shaan',
     price:200.0,
     description:'body care product to use',
     category:'body care',quantityInStock: 4),


     Product(ID: '2',imgURL:'https://via.placeholder.com/150',
     name:'eva',
     price:250.0,
     description:'body care product to use',
     category:'body care',quantityInStock: 5),

     Product(ID: '3',imgURL:'https://via.placeholder.com/150',
     name:'body splash',
     price:300.0,
     description:'perfum product to use',
     category:'splashes',quantityInStock: 8),

  ];
   List<CartItem> cartItems = [];

   void addToCart(Product product){
     setState(() {
       final index=cartItems.indexWhere((item)=>item.product.ID==product.ID);
       if(index!=-1){
        cartItems[index].quantity++;
       }
       else{
        cartItems.add(CartItem(product:product,quantity: 1));
       }
     });
   }

   void removeFromCart(Product product){
    setState(() {
      cartItems.removeWhere((item)=>item.product.ID==product.ID);
    });
   }

    void updateQuantity(Product product, int quantity) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.product.ID == product.ID);
      if (index != -1 && quantity > 0 ) {
        cartItems[index].quantity = quantity;
      }
    });
  }
  double get total {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(product.imgURL),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => addToCart(product),
                  ),
                );
              },
            ),
          ),

          
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return ListTile(
                  leading: Image.network(cartItem.product.imgURL),
                  title: Text(cartItem.product.name),
                  subtitle: Text('\$${cartItem.product.price}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            updateQuantity(cartItem.product, cartItem.quantity - 1);
                          } else {
                            removeFromCart(cartItem.product);
                          }
                        },
                      ),
                      Text('x${cartItem.quantity}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (cartItem.quantity < cartItem.product.quantityInStock) {
                            updateQuantity(cartItem.product, cartItem.quantity + 1);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
               
              },
              child: Text('Proceed to Checkout - \$${total.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}
  
 