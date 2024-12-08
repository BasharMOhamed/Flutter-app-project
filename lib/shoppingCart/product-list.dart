import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Product.dart';

class productList extends StatefulWidget {
  @override
  _productListState createState() => _productListState();
}

class _productListState extends State<productList> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase data = FirebaseDatabase.instance;

  double totalPrice = 0;

  List<CartItem> cartItems = [];

  void addToCart(String id) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == id);
      // if (index != -1) {
      cartItems[index].quantity++;
      // } else {
      //   cartItems.add(CartItem(product, 1, 'hbjhb'));
      // }
    });
  }

  void removeFromCart(String id) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == id);
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
      total += item.price * item.quantity;
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

  void getCartProducts() async {
    String? userId = auth.currentUser?.uid;
    if (userId != null) {
      DatabaseReference cartRef =
          FirebaseDatabase.instance.ref('users/$userId/shoppingCart');
      DataSnapshot snapshot = await cartRef.get();
      final data = snapshot.value as Map<Object?, Object?>;

      setState(() {
        cartItems = data.entries.map((entry) {
          final key = entry.key.toString();
          final value = Map<String, dynamic>.from(entry.value as Map);
          return CartItem(
            value['imgURL'],
            value['price'].toDouble(),
            value['productName'],
            value['quantity'],
            key,
          );
        }).toList();
      });
    }
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
                                  cartItems[index].imgURL,
                                  height: 120,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cartItems[index].productName),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(cartItems[index].price.toString()),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(cartItems[index].productName),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(cartItems[index].price.toString())
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
                                          addToCart(cartItems[index].id),
                                          updateTotal()
                                        }),
                                const SizedBox(width: 10),
                                Text(cartItems[index].quantity.toString()),
                                const SizedBox(width: 10),
                                IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () => {
                                          removeFromCart(cartItems[index].id),
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
