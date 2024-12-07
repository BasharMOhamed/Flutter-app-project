import 'package:flutter/material.dart';
import './Product.dart';
import './shoppingCart/product-list.dart';

void main() {
  runApp(MyApp());
}

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }

// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: productList(),
    );
  }
}
