import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/adminChart.dart';

import 'package:flutter_app/productDetails.dart';

import 'package:flutter_app/adminTransactions.dart';
import 'package:flutter_app/checkout-page.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/shoppingCart/product-list.dart';
import 'signUp.dart';
import 'login.dart';
import 'navBar.dart';

import 'package:flutter_app/productsPage.dart';
import 'package:flutter_app/product_management.dart';
import 'package:flutter_app/categories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Sign Up',
      home: LoginPage(),
    );
  }
}
