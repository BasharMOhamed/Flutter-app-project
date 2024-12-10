import 'package:flutter/material.dart';
import 'package:flutter_app/add_product.dart';
import 'package:flutter_app/Product.dart';
import 'package:flutter_app/edit_product.dart';

class ProductsManagePage extends StatefulWidget {
  const ProductsManagePage({super.key});

  @override
  _ProductManagePageState createState() => _ProductManagePageState();
}

class _ProductManagePageState extends State<ProductsManagePage> {
  final List<Product> products = [
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 1',
        100,
        'loreLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Skincare',
        5),
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 2',
        200,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Makeup',
        10),
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 3',
        300,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Clothes',
        15),
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 4',
        400,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Tv',
        20),
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 5',
        500,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Tv',
        25),
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 6',
        600,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Skincare',
        30),
    Product(
        'https://f.nooncdn.com/p/pzsku/Z1CE9C5578009988E50C4Z/45/_/1731503123/46d3dd93-efb2-46a5-8c22-370d3135d2b9.jpg?format=avif&width=240',
        'Product 7',
        700,
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Clothes',
        35),
  ];

  String selectedCategory = 'All'; 

  List<String> categories = [
    "All",
    "Makeup",
    "Clothes",
    "Skincare",
    "Tv",
    "None"
  ]; 
  late List<Product> filteredProducts;

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void filterProductByCategory(String category) {
    category = category.toLowerCase().trim();
    if (category == "all") {
      selectedCategory = "All";
      filteredProducts = products;
      return;
    }
    bool found =
        categories.any((Cat) => Cat.toLowerCase() == category.toLowerCase());
    if (found) {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product.category.toLowerCase() == category.toLowerCase())
            .toList();
      });
     return;
    } 
    else {
      selectedCategory = "None";
      filteredProducts = [];
    }
  }

  void rebuildFilteredProducts() {
  setState(() {
    if (selectedCategory == 'All') {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products
          .where((product) => product.category.toLowerCase() == selectedCategory.toLowerCase())
          .toList();
    }
  });
}



  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void updateProduct(int index, Product updatedProduct) {
    setState(() {
      products[index] = updatedProduct;
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Category: '),
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text('Select a Category'),
                  items: categories
                      .map((String category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (String? category) {
                    setState(() {
                      selectedCategory = category.toString();
                      filterProductByCategory(selectedCategory);
                      rebuildFilteredProducts();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final originalIndex = products.indexWhere((p) => p == product);
                return GestureDetector(
                  onTap: () {
                     if (originalIndex != -1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: product,
                          categories: categories,
                          onUpdate: (updatedProduct) {
                              setState(() {
                                products[originalIndex] = updatedProduct; 
                                rebuildFilteredProducts();
                              });
                            },
                          onDelete: () {
                              setState(() {
                                products.removeAt(originalIndex); 
                                rebuildFilteredProducts();
                              });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                    }
                  },
                  child: Card(
                    child: ListTile(
                      leading: product.imgURL.isNotEmpty // Check if the URL is not empty
                          ? Image.network(
                              product.imgURL,
                              height: 120,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Handle invalid URLs by displaying a placeholder
                                return Icon(Icons.image, size: 80);
                              },
                            )
                          : Icon(Icons.image, size: 80), // Placeholder for empty URL
                      title: Text(product.name), // Product name
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EGP ${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)), 
                          Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis), 
                          Text('Category: ${product.category}', style: TextStyle(fontStyle: FontStyle.italic)), 
                          Text('Stock: ${product.quantityInStock}', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                );
              },
            ),
          ), 
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
           MaterialPageRoute(
              builder: (context) => AddProductPage(
                categories: categories, 
                onAdd: (newProduct) {
                  setState(() {
                    addProduct(newProduct);
                  });
                },
              ),
            ),
          );
          if (newProduct != null){
             addProduct(newProduct);
             rebuildFilteredProducts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}