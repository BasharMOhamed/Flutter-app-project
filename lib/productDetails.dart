import 'package:flutter/material.dart';

class Productdetails extends StatelessWidget {
  // DUMMY DATA (WAITING FOR SAHLOL)
  final String productName = "Mobile";
  final String productImage =
      "https://m.media-amazon.com/images/I/61vIdWlDGcL._AC_SL1500_.jpg";
  final double productPrice = 120.5;
  final String productDescription =
      "A nice mobile phone which can trn trn trn trn trn";
  const Productdetails({super.key});

  // Productdetails({
  //   required this.productName,
  //   required this.productImage,
  //   required this.productPrice,
  //   required this.productDescription,
  // });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
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
                  productImage,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Product Name
              Text(
                productName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Product Price
              Text(
                '\$${productPrice.toStringAsFixed(2)}',
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
                productDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Add to Cart Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Cart')),
                    );
                  },
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
