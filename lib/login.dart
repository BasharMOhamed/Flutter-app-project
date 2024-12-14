import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/productsPage.dart';
import 'signUp.dart';
import 'forgetpassword.dart';
//import 'Product.dart'; // Import Home Page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          _isLoading = false;
        });
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref('users/${userCredential.user?.uid}');

        DataSnapshot snapshot = await userRef.get();

        final userData = snapshot.value as Map<dynamic, dynamic>;

        if (userData['isadmin'] == false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProductsPage()),
          );
        } else if (userData['isadmin'] == true) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => ProductsPage()),
          // );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );

        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Product()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });

        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        } else {
          message = 'An error occurred. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an email";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _login,
                          child: Text('Login'),
                        ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to the Login page
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Text("Having no account? SignUp"),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to the Login page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Forgetpassword()));
                    },
                    child: Text("Forget password"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
