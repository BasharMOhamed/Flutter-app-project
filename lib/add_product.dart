import 'package:flutter/material.dart';
import 'package:flutter_app/Product.dart';

class AddProductPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> categories;
  final Function(Product) onAdd;
  final String newId;

  AddProductPage(
      {required this.categories, required this.onAdd, required this.newId});

  late String name = '';
  late String description = '';
  late double price = 0.0;
  late String imgURL = '';
  late String category = categories.firstWhere(
    (cat) => cat != 'All' && cat != 'None',
    orElse: () => '',
  );
  late int quantityInStock = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) => name = value!.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = double.parse(value!.trim()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid price';
                    }
                    if (double.tryParse(value.trim()) == null ||
                        double.parse(value.trim()) <= 0) {
                      return 'Price must be a positive number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) => imgURL = value!.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid image URL';
                    }
                    if (!Uri.parse(value.trim()).isAbsolute) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  items: categories
                      .where((cat) =>
                          cat != 'All' &&
                          cat != 'None') // Filter out "All" and "None"
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    category = value!;
                  },
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a valid category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity in Stock'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      quantityInStock = int.parse(value!.trim()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid quantity';
                    }
                    if (int.tryParse(value.trim()) == null ||
                        int.parse(value.trim()) < 0) {
                      return 'Quantity must be a non-negative number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      onAdd(
                        Product(imgURL, name, price, description, category,
                            quantityInStock, newId),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
