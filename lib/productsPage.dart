import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Product.dart';
import 'package:flutter_app/productCard.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = new TextEditingController();
  String selectedCategory = "All";
  String searchTextValue = "";
  Map<String, String> categoryMap = {};
  List<Product> products = [];
  List<Product> filteredProducts = [];

  //FireBase Connection
  final DatabaseReference categoryRef =
      FirebaseDatabase.instance.ref('Categories');
  final DatabaseReference productRef =
      FirebaseDatabase.instance.ref('Products');

  void addProducts() async {
    await categoryRef.set(categories);
  }

  void getCategories() async {
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

  void getProducts() async {
    final snapshot = await productRef.get();
    if (snapshot.exists) {
      setState(() {
        products = (snapshot.value as List<dynamic>)
            .asMap()
            .entries
            .map((entry) => Product.fromMap(
                  Map<String, dynamic>.from(entry.value),
                  entry.key,
                ))
            .toList();
        filteredProducts = products;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    getProducts();
  }

  //Filter Products
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

      searchTextValue = "";
      searchVoiceValue = "";
      _searchController.clear();
      return;
    } else {
      selectedCategory = "None";
      filteredProducts = [];
      Fluttertoast.showToast(msg: "Category not found");
    }
  }

  void filterProductByName(String name) {
    name = name.toLowerCase().trim();
    setState(() {
      filteredProducts = products
          .where((product) => product.name.toLowerCase().contains(name))
          .toList();
    });
  }

//Speech recognition

  String searchVoiceValue = '';
  stt.SpeechToText speech = stt.SpeechToText();
  bool isAvailable = false;
  bool isListining = false;

  Future<void> getMicrophonePermission() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        print('status $status');
        if (status == 'notListening') {
          setState(() {
            isListining = false;
          });
        }
      },
      onError: (error) => print('Error: $error'),
    );

    setState(() {
      isAvailable = available;
    });

    if (!isAvailable) {
      Fluttertoast.showToast(
          msg: "Microphone is not available or permission denied");
    }
  }

  void startSpeechRecognition() async {
    if (!isAvailable) {
      await getMicrophonePermission();
    }
    setState(() {
      isListining = true;
    });
    speech.listen(
      onResult: (result) {
        setState(() {
          searchVoiceValue = result.recognizedWords;
          filterProductByName(searchVoiceValue);
        });
      },
      listenFor: Duration(minutes: 1),
      cancelOnError: true,
    );
  }

  void stopSpeechRecognition() {
    setState(() {
      isListining = false;
    });
    speech.stop();
  }

  //Barcode reading
  String _scanResult = "";

  Future<void> scanCode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '', "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = "Failed to scan code";
    }
    setState(() {
      _scanResult = barcodeScanRes;
      filterProductByName(_scanResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: Stack(children: [
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Flexible(
                    flex: 5,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchTextValue = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search products',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    )),
                const SizedBox(
                  width: 1,
                ),
                Flexible(
                    flex: 3,
                    child: ElevatedButton(
                        onPressed: () {
                          filterProductByName(searchTextValue);
                        },
                        child: Text("Search"))),
              ]),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Category:"),
                  const SizedBox(
                    width: 15,
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text('Select a Category'),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? category) {
                      setState(() {
                        selectedCategory = category.toString();
                        filterProductByCategory(selectedCategory);
                      });
                    },
                  ),
                  Flexible(
                      flex: 1,
                      child: IconButton(
                          onPressed: () async {
                            startSpeechRecognition();
                          },
                          icon: Icon(Icons.mic_rounded))),
                  const SizedBox(
                    width: 1,
                  ),
                  Flexible(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            scanCode();
                          },
                          icon: Icon(Icons.barcode_reader)))
                ],
              ),
              if (filteredProducts.isNotEmpty)
                Expanded(
                    child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return Productcard(
                        productName: filteredProducts[index].name,
                        productPrice: filteredProducts[index].price,
                        description: filteredProducts[index].description,
                        imageURL: filteredProducts[index].imgURL,
                        category: filteredProducts[index].category,
                        quantityInStock:
                            filteredProducts[index].quantityInStock,
                        productId: filteredProducts[index].id);
                  },
                )),
              if (filteredProducts.isEmpty)
                Center(
                  child: Text("No Products Found!",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                )
            ],
          ),
          if (isListining)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          if (isListining)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 40,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: Container(
                width: 100,
                height: 100,
                child: Icon(Icons.mic, size: 80, color: Colors.white),
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color
                  borderRadius: BorderRadius.circular(40), // Rounded corners
                ),
              ),
            ),
          if (isListining)
            Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, size: 40, color: Colors.white),
                  onPressed: () {
                    stopSpeechRecognition();
                  },
                )),
        ]));
  }
}
