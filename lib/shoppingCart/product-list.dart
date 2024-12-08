import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Product.dart';

class productList extends StatefulWidget {
  @override
  _productListState createState() => _productListState();
}

class _productListState extends State<productList> {
  double totalPrice = 0;
  List<Product> products = [
    Product(
        ID: '1',
        imgURL: 'https://via.placeholder.com/150',
        name: 'shaan',
        price: 200.0,
        description: 'body care product to use',
        category: 'body care',
        quantityInStock: 4),
    Product(
        ID: '2',
        imgURL: 'https://via.placeholder.com/150',
        name: 'eva',
        price: 250.0,
        description: 'body care product to use',
        category: 'body care',
        quantityInStock: 5),
    Product(
        ID: '3',
        imgURL: 'https://via.placeholder.com/150',
        name: 'body splash',
        price: 300.0,
        description: 'perfum product to use',
        category: 'splashes',
        quantityInStock: 8),
  ];
  List<CartItem> cartItems = [
    CartItem(
        product: Product(
            ID: '3',
            imgURL:
                'https://f.nooncdn.com/p/pzsku/Z8D36526F7EFC45853967Z/45/_/1732101070/9ed6b40c-1220-4df8-a09c-1cce7350b770.jpg?format=avif&width=240',
            name: 'body splash',
            price: 300.0,
            description: 'perfum product to use',
            category: 'splashes',
            quantityInStock: 8),
        quantity: 2),
  ];

  void addToCart(Product product) {
    setState(() {
      final index =
          cartItems.indexWhere((item) => item.product.ID == product.ID);
      if (index != -1) {
        cartItems[index].quantity++;
      } else {
        cartItems.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      final index =
          cartItems.indexWhere((item) => item.product.ID == product.ID);
      if (cartItems[index].quantity == 1) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity--;
      }
    });
  }

  void updateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    setState(() {
      totalPrice = total;
    });
  }

  @override
  void initState() {
    updateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 4,
                          child: Row(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  cartItems[index].product.imgURL,
                                  height: 120,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cartItems[index].product.name),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(cartItems[index].product.price.toString())
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () => {
                                          addToCart(cartItems[index].product),
                                          updateTotal()
                                        }),
                                const SizedBox(width: 10),
                                Text(cartItems[index].quantity.toString()),
                                const SizedBox(width: 10),
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () => {
                                          removeFromCart(
                                              cartItems[index].product),
                                          updateTotal()
                                        }),
                              ],
                            )
                          ]),
                        ));
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                  'Proceed to Checkout - \$${totalPrice.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}
