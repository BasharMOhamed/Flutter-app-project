import 'package:flutter/material.dart';
import 'package:flutter_app/productDetails.dart';

class Productcard extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String description;
  final String imageURL;
  final String category;
  final int quantityInStock;
  final String productId;

  Productcard(
      {Key? key,
      required this.productName,
      required this.productPrice,
      required this.description,
      required this.imageURL,
      required this.category,
      required this.quantityInStock,
      required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Productdetails(
                      productName: productName,
                      productPrice: productPrice,
                      description: description,
                      imageURL: imageURL,
                      category: category,
                      quantityInStock: quantityInStock,
                      productId: productId)));
        },
        child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: imageURL.isNotEmpty
                          ? Image.network(
                              imageURL,
                              height: 120,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image, size: 80);
                              },
                            )
                          : const Icon(Icons.image, size: 80),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'EGP${productPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
