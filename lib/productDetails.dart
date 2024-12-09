import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Productdetails extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String description;
  final String imageURL;
  final String category;
  final int quantityInStock;
  final int productId;
  // const Productdetails({super.key});

  Productdetails(
      {required this.productName,
      required this.productPrice,
      required this.description,
      required this.imageURL,
      required this.category,
      required this.quantityInStock,
      required this.productId});

  @override
  _ProductdetailsState createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late DatabaseReference productRef;
  late int currentQuantityInStock;

  @override
  void initState() {
    super.initState();
    currentQuantityInStock = widget.quantityInStock;
    productRef = FirebaseDatabase.instance.ref('Products/${widget.productId}');
  }

  // Add To Cart Function
  Future<void> addToCart() async {
    String? userId = auth.currentUser?.uid;
    late final DatabaseReference database;
    if (userId != null) {
      database = FirebaseDatabase.instance
          .ref('users/$userId/shoppingCart/${widget.productId}');
      final snapshot = await database.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        await database.update({
          'quantity': data['quantity'] + 1,
        });
      } else {
        await database.set({
          'productName': widget.productName,
          'imageURL': widget.imageURL,
          'price': widget.productPrice,
          'quantity': 1,
        });
      }
      final productSnap = await productRef.get();
      final productData = productSnap.value as Map;
      final updatedStock = productData['quantityInStock'] - 1;
      await productRef.update({
        'quantityInStock': updatedStock,
      });

      setState(() {
        currentQuantityInStock = updatedStock;
      });
    } else {
      // Navigate to the Login Page
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Image.network(
                  widget.imageURL,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Product Name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Category Label
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 231, 239),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.category,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Product Price
              Text(
                '\$${widget.productPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Product Description
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Add to Cart Button
              Center(
                child: ElevatedButton(
                  onPressed: currentQuantityInStock > 0
                      ? () async {
                          try {
                            await addToCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to Cart')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      : null,
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
