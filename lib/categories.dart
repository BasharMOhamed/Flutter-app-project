import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late List<String> categories = [];
  late int categoryCount;
  final DatabaseReference catRef = FirebaseDatabase.instance.ref("Categories");
  Map<String, String> categoryMap = {};

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void addCategory(String newCategory) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    String? uniqueKey = ref.push().key;
    await catRef.child('$uniqueKey').set({"title": newCategory});

    setState(() {
      categories.add(newCategory);
      fetchCategories();
    });
  }

  void fetchCategories() async {
    final snapshot = await catRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          categoryMap = data.map(
            (key, value) => MapEntry(value['title'].toString(), key.toString()),
          );
           // Exclude "All" or any unwanted keys from the categoryMap
          categoryMap.removeWhere((key, value) => key.toLowerCase() == 'all');
        });
      }
    } else {
      print("No categories found.");
    }
  }

  void deleteCategory(String category) async {
    final id = categoryMap[category];
    // final DatabaseReference categoryRef = FirebaseDatabase.instance.ref('Categories/$id');
    await catRef.child("$id").remove();
    setState(() {
      categories.remove(category);
      fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categoryMap.length,
        itemBuilder: (context, index) {
          final title = categoryMap.keys.elementAt(index);
          print(title);
          final id = categoryMap[title]!;
          return Card(
            child: ListTile(
              title: Text(title),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteCategory(title);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCategory = await showDialog<String>(
            context: context,
            builder: (context) {
              final _formKey = GlobalKey<FormState>();
              String categoryName = '';
              return AlertDialog(
                title: Text('Add New Category'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Category Name'),
                    onChanged: (value) {
                      categoryName = value;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid category name';
                      }
                      if (categories.any((Cat) =>
                          Cat.toLowerCase() == categoryName.toLowerCase())) {
                        return 'Category already exists';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, categoryName.trim());
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
          if (newCategory != null && newCategory.isNotEmpty) {
            addCategory(newCategory);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
