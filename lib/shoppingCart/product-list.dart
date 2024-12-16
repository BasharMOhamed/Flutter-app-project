import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/checkout-page.dart';
import '../Product.dart';

class productList extends StatefulWidget {
  @override
  _productListState createState() => _productListState();
}

class _productListState extends State<productList> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase data = FirebaseDatabase.instance;

  double totalPrice = 0;
  bool isButtonEnabled = false;
  List<CartItem> cartItems = [];

  //
  Future<int?> getQuantityInStock(String id) async {
    try {
      // Create a reference to the specific product
      DatabaseReference prodRef = FirebaseDatabase.instance.ref('Products/$id');

      // Fetch the data snapshot
      DataSnapshot snapshot = await prodRef.get();

      if (snapshot.exists) {
        // Access the 'quantityInStock' field
        final data = snapshot.value as Map<dynamic, dynamic>;
        int quantity = data['quantityInStock'] ?? 0;
        print('Quantity in Stock: $quantity');
        return quantity;
      } else {
        print('No data available for this product.');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
    return null;
  }

  void addToCart(String id) async {
    // String userId = "eBKvUeeoFYUIbaXinkBcTVHSnPo2";
    String? userId = auth.currentUser?.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/$userId/shoppingCart/$id');
    int? quantityInStock = await getQuantityInStock(id);
    DatabaseReference prodRef = FirebaseDatabase.instance.ref('Products/$id');

    if (quantityInStock != null && quantityInStock > 0) {
      setState(() {
        final index = cartItems.indexWhere((item) => item.id == id);
        if (index != -1) {
          cartItems[index].quantity++;
        }
      });
      updateTotal();
      await ref.update(
          {'quantity': cartItems.firstWhere((item) => item.id == id).quantity});
      await prodRef.update({'quantityInStock': quantityInStock - 1});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Out Of Stock")),
      );
    }
  }

  void removeFromCart(String id) async {
    // String userId = "eBKvUeeoFYUIbaXinkBcTVHSnPo2";
    String? userId = auth.currentUser?.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/$userId/shoppingCart/$id');
    DatabaseReference prodRef = FirebaseDatabase.instance.ref('Products/$id');
    int? quantityInStock = await getQuantityInStock(id);

    setState(() {
      final index = cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        if (cartItems[index].quantity == 1) {
          cartItems.removeAt(index);
          ref.remove();
        } else {
          cartItems[index].quantity--;
          ref.update({'quantity': cartItems[index].quantity});
        }
      }
    });

    await prodRef.update({'quantityInStock': quantityInStock! + 1});
    updateTotal();
  }

  void updateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    setState(() {
      if (total > 0) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
      totalPrice = total;
    });
  }

  @override
  void initState() {
    super.initState();
    getCartProducts();
  }

  void getCartProducts() async {
    // String userId = "eBKvUeeoFYUIbaXinkBcTVHSnPo2";
    String? userId = auth.currentUser?.uid;
    if (userId != null) {
      DatabaseReference cartRef =
          FirebaseDatabase.instance.ref('users/$userId/shoppingCart');
      DataSnapshot snapshot = await cartRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?> ?? {};

        setState(() {
          cartItems = data.entries.map((entry) {
            final key = entry.key.toString();
            final value = Map<String, dynamic>.from(entry.value as Map);
            return CartItem(
              value['imageURL'],
              value['price'].toDouble(),
              value['productName'],
              value['quantity'],
              key,
            );
          }).toList();
        });
      }
    }
    updateTotal();
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
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image, size: 80);
                                  },
                                )),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cartItems[index].productName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(children: [
                                  Text(
                                      'EGP${cartItems[index].price.toString()}',
                                      style: TextStyle(color: Colors.green)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () => {
                                                addToCart(cartItems[index].id),
                                              }),
                                      Text(
                                          cartItems[index].quantity.toString()),
                                      IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () => {
                                                removeFromCart(
                                                    cartItems[index].id),
                                              }),
                                    ],
                                  )
                                ])
                              ],
                            ),
                          ]),
                        ));
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      print("navigate to checkout Page");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutPage()),
                      );
                    }
                  : null,
              child: Text(
                  'Proceed to Checkout - EGP${totalPrice.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}
