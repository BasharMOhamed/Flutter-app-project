import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/productDetails.dart';
import 'package:flutter_app/firebase_options.dart';
import 'signUp.dart';
import 'login.dart';

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
<<<<<<< HEAD
<<<<<<< HEAD
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Sign Up',
      home: LoginPage(),
=======
    return const MaterialApp(
      home: Productdetails(),
>>>>>>> 4489263 (Making product details page with dummy data)
=======
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
>>>>>>> e243eb7 (Finishing the product Details page)
    );
  }
}
