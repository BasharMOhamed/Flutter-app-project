import 'package:flutter/material.dart';
import 'package:flutter_app/Product.dart'; 

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final List<String> categories;
  final Function(Product) onUpdate;
  final VoidCallback onDelete;

  ProductDetailPage({
    required this.product,
    required this.categories,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late String imgUrl;
  late String name;
  late double price;
  late String description;
  late String category;
  late int quantityInStock;

  @override
  void initState() {
    super.initState();
    imgUrl = widget.product.imgURL;
    name = widget.product.name;
    price = widget.product.price;
    description = widget.product.description;
    category = widget.categories.contains(widget.product.category)
        ? widget.product.category
        : widget.categories.first;
    quantityInStock = widget.product.quantityInStock;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: name,
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
                  initialValue: description,
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
                  initialValue: price.toString(),
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
                  initialValue: imgUrl,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) => imgUrl = value!.trim(),
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
                  items: widget.categories
                      .where((cat) => cat != "All" && cat != "None") 
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
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
                  initialValue: quantityInStock.toString(),
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
                      widget.onUpdate(
                        Product(
                          imgUrl,
                          name,
                          price,
                          description,
                          category,
                          quantityInStock,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Changes'),
                ),
                TextButton(
                  onPressed: widget.onDelete,
                  child: Text(
                    'Delete Product',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}