import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/navBar.dart';
import 'AddNewAddressPage.dart';
import 'CartItem.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = "Paypal";
  String _phone = "+2";
  String _address = "Cairo";
  List<CartItem> cartItems = [];
  final double shippingFee = 5.0;
  final double taxRate = 0.05;
  String Feedback = "";
  String rating = "";
  double totalPrice = 0.0;

  TextEditingController ratingController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCartProducts();
  }

  double get subtotal {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get tax {
    return subtotal * taxRate;
  }

  double get orderTotal {
    totalPrice = subtotal + shippingFee + tax;
    return subtotal + shippingFee + tax;
  }

  void getCartProducts() async {
    // String userId = "eBKvUeeoFYUIbaXinkBcTVHSnPo2";
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DatabaseReference cartRef =
          FirebaseDatabase.instance.ref('users/$userId/shoppingCart');
      DataSnapshot snapshot = await cartRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>;
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
  }

  void removeShoppingCart() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference cartRef =
        FirebaseDatabase.instance.ref('users/$userId/shoppingCart');
    await cartRef.remove();
  }

  void saveOrderDetails() async {
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref('Orders');

    //String ratingText = ratingController.text;
    //double? rating = double.tryParse(ratingText);
    // if (rating == null) {
    //   rating = 0.0;  // Default rating if the input is not valid
    // }
    String newOrderKey = ordersRef.push().key ?? '';
    Map<String, dynamic> orderData = {
      "totalPrice": orderTotal,
      "feedback": Feedback,
      "rating": double.tryParse(rating),
      "orderDate": DateTime.now().toIso8601String(),
      //"address": _address,
      //"phone": _phone,
      "items": cartItems
          .map((item) => {
                "productName": item.productName,
                "price": item.price,
                "quantity": item.quantity,
                "imageURL": item.imgURL,
              })
          .toList(),
    };
    try {
      await ordersRef.child(newOrderKey).set(orderData);
      print("Order saved successfully");
    } catch (e) {
      print("Error saving order: $e");
    }
  }

  void updateProductTotalSell(List<CartItem> items) async {
    DatabaseReference totalSellRef = FirebaseDatabase.instance.ref('totalSell');

    for (var item in items) {
      try {
        DataSnapshot snapshot = await totalSellRef.get();

        if (snapshot.exists) {
          bool productExists = false;

          for (var child in snapshot.children) {
            Map<String, dynamic> productData =
                Map<String, dynamic>.from(child.value as Map);

            if (productData['productName'] == item.productName) {
              productExists = true;
              double currentTotalSell =
                  productData['totalSell']?.toDouble() ?? 0.0;
              double newTotalSell = currentTotalSell + item.quantity;

              await totalSellRef.child(child.key!).update({
                "totalSell": newTotalSell,
              });

              print("Updated totalSell for product ${item.productName}");
              break;
            }
          }
          if (!productExists) {
            await totalSellRef.push().set({
              "productName": item.productName,
              "totalSell": item.quantity,
            });
            print("Added new product ${item.productName} to totalSell");
          }
        }
        // else {
        //   // If the `totalSell` node is empty, add the first entry
        //   await totalSellRef.push().set({
        //     "productName": item.productName,
        //     "totalSell":  item.quantity,
        //   });
        //   print("Initialized totalSell with product ${item.productName}");
        // }
      } catch (e) {
        print("Error updating totalSell for product ${item.productName}: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Review"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 4,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  cartItems[index].imgURL,
                                  height: 120,
                                  width: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image, size: 80);
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cartItems[index].productName),
                                  const SizedBox(height: 15),
                                  Text(
                                      "EGP${cartItems[index].price.toString()}"),
                                  Text(
                                      "x${cartItems[index].quantity.toString()}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(height: 32, thickness: 1),
                PricingSection(
                  subtotal: subtotal,
                  shippingFee: shippingFee,
                  tax: tax,
                  total: orderTotal,
                ),
                Divider(height: 32, thickness: 1),
                ListTile(
                  title: Text("Payment Method"),
                  trailing: TextButton(
                    child: Text("Change"),
                    onPressed: () {
                      _showPaymentMethodDialog(context);
                    },
                  ),
                  subtitle: Text(_selectedPaymentMethod),
                ),
                Divider(height: 32, thickness: 1),
                ListTile(
                  title: Text("Personal Information"),
                  trailing: TextButton(
                    child: Text("Edit"),
                    onPressed: () async {
                      final newAddressData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewAddressPage(
                            initialPhone: _phone,
                            initialAddress: _address,
                          ),
                        ),
                      );
                      if (newAddressData != null) {
                        setState(() {
                          _phone = newAddressData['phone'];
                          _address = newAddressData['address'];
                        });
                      }
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16),
                          SizedBox(width: 8),
                          Text(_phone),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(_address),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    //saveOrderDetails();
                    _showCheckoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text("Checkout EGP${orderTotal.toStringAsFixed(2)}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Payment Method"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("PayPal"),
                onTap: () {
                  _changePaymentMethod("PayPal");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Credit Card"),
                onTap: () {
                  _changePaymentMethod("Credit Card");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Apple Pay"),
                onTap: () {
                  _changePaymentMethod("Apple Pay");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Google Pay"),
                onTap: () {
                  _changePaymentMethod("Google Pay");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changePaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _showCheckoutDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Form key for validation
    final TextEditingController feedbackController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Payment Successful!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: feedbackController,
                      decoration: InputDecoration(
                        labelText: "Feedback",
                        hintText: "Enter your feedback",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a Feedback';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: ratingController,
                      decoration: InputDecoration(
                        labelText: "Rating From (1-5)",
                        hintText: "Enter a number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a Rating';
                        }
                        final rating = double.tryParse(value.trim());
                        if (rating == null || rating < 1 || rating > 5) {
                          return 'Please enter number between 1 and 5';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Enforce min and max values
                        if (value.isNotEmpty) {
                          final number = int.tryParse(value);
                          if (number != null) {
                            if (number < 1) {
                              ratingController.text = '1';
                              // ratingController.selection =
                              //     TextSelection.fromPosition(
                              //   TextPosition(offset: ratingController.text.length),
                              // );
                            } else if (number > 5) {
                              ratingController.text = '5';
                              // ratingController.selection =
                              //     TextSelection.fromPosition(
                              //   TextPosition(offset: ratingController.text.length),
                              // );
                            }
                            ratingController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: ratingController.text.length),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          rating = ratingController.text;
                          Feedback = feedbackController.text;
                          saveOrderDetails();
                          updateProductTotalSell(cartItems);
                          removeShoppingCart();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavBar(isAdmin: false)),
                          );
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}

class PricingSection extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double total;

  PricingSection({
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceRow(label: "Subtotal", value: "EGP${subtotal.toStringAsFixed(2)}"),
        PriceRow(
            label: "Shipping Fee",
            value: "EGP${shippingFee.toStringAsFixed(2)}"),
        PriceRow(label: "Tax Fee", value: "EGP${tax.toStringAsFixed(2)}"),
        Divider(),
        PriceRow(
            label: "Order Total",
            value: "EGP${total.toStringAsFixed(2)}",
            bold: true),
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  PriceRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          Text(
            value,
            style: bold ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ],
      ),
    );
  }
}
