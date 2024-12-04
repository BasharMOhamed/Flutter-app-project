import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/productDetails.dart';
import 'package:flutter_app/firebase_options.dart';
import 'signUp.dart';
import 'login.dart';

import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/productDetails.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Sign Up',
      home: LoginPage(),
=======
    return const MaterialApp(
      home: Productdetails(),
>>>>>>> 4489263 (Making product details page with dummy data)
    );
  }
}
