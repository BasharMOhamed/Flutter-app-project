import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/productDetails.dart';
import 'package:flutter_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Productdetails(
          productName: "Shaan Body Milk",
          productPrice: 5,
          productId: 0,
          description: "body milk 72 hours 300 ml.",
          category: "SkinCare",
          quantityInStock: 1,
          imageURL:
              "https://m.media-amazon.com/images/I/51c+8faWUWL._AC_SY300_SX300_.jpg"),
    );
  }
}
