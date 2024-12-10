import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/add_product.dart';
import 'package:flutter_app/Product.dart';
import 'package:flutter_app/edit_product.dart';

class ProductsManagePage extends StatefulWidget {
  const ProductsManagePage({super.key});

  @override
  _ProductManagePageState createState() => _ProductManagePageState();
}

List<Product> products = [];

class _ProductManagePageState extends State<ProductsManagePage> {
  final DatabaseReference catRef = FirebaseDatabase.instance.ref("Categories");
  final DatabaseReference productRef =
      FirebaseDatabase.instance.ref('Products');
  final newPostKey =
      FirebaseDatabase.instance.ref().child('products').push().key;
  Map<String, String> categoryMap = {};
  String selectedCategory = 'Makeup';
  late List<Product> filteredProducts;

  void fetchCategories() async {
    final snapshot = await catRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          categoryMap = data.map(
            (key, value) => MapEntry(value['title'].toString(), key.toString()),
          );
        });
      }
    } else {
      print("No categories found.");
    }
  }

  Future<void> fetchProducts() async {
    final snapshot = await productRef.get();
    final data = snapshot.value as Map<Object?, Object?>;

    setState(() {
      products = data.entries.map((entry) {
        final key = entry.key.toString();
        final value = Map<String, dynamic>.from(entry.value as Map);
        return Product(
          value['imgURL'],
          value['name'],
          value['price'].toDouble(),
          value['description'],
          value['category'],
          value['quantityInStock'],
          key,
        );
      }).toList();
      filteredProducts = products;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
    fetchCategories();
    fetchProducts();
  }

  void filterProductByCategory(String category) {
    category = category.toLowerCase().trim();
    if (category == "all") {
      selectedCategory = "All";
      filteredProducts = products;
      return;
    }
    bool found = categoryMap.keys
        .any((Cat) => Cat.toLowerCase() == category.toLowerCase());

    if (found) {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product.category.toLowerCase() == category.toLowerCase())
            .toList();
      });
      return;
    } else {
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
            .where((product) =>
                product.category.toLowerCase() ==
                selectedCategory.toLowerCase())
            .toList();
      }
    });
  }

  void addProduct(Product product) async {
    await productRef.child('/$newPostKey').set({
      'category': product.category,
      'description': product.description,
      'imgURL': product.imgURL,
      'name': product.name,
      'price': product.price,
      'quantityInStock': product.quantityInStock
    });

    setState(() {
      products.add(product);
    });
  }

  void updateProduct(int index, Product updatedProduct) async {
    String id = products[index].id;
    await productRef.child('/$id').update({
      'category': updatedProduct.category,
      'description': updatedProduct.description,
      'imgURL': updatedProduct.imgURL,
      'name': updatedProduct.name,
      'price': updatedProduct.price,
      'quantityInStock': updatedProduct.quantityInStock,
    });
    setState(() {
      products[index] = updatedProduct;
    });
  }

  void deleteProduct(String id) async {
    await productRef.child('/$id').remove();
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
                  items: categoryMap.keys
                      .toList()
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
                            categories: categoryMap.keys.toList(),
                            onUpdate: (updatedProduct) {
                              setState(() {
                                products[originalIndex] = updatedProduct;
                                updateProduct(originalIndex, updatedProduct);
                                rebuildFilteredProducts();
                              });
                            },
                            onDelete: () {
                              setState(() {
                                products.removeAt(originalIndex);
                                deleteProduct(product.id);
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
                      leading: product.imgURL.isNotEmpty
                          ? Image.network(
                              product.imgURL,
                              height: 120,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image, size: 80);
                              },
                            )
                          : const Icon(Icons.image, size: 80),
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EGP ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.green)),
                          Text(product.description,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text('Category: ${product.category}',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          Text('Stock: ${product.quantityInStock}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                  categories: categoryMap.keys.toList(),
                  onAdd: (newProduct) {
                    setState(() {
                      addProduct(newProduct);
                    });
                  },
                  newId: newPostKey ?? ''),
            ),
          );
          if (newProduct != null) {
            addProduct(newProduct);
            rebuildFilteredProducts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
