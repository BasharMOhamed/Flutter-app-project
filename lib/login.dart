import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/adminChart.dart';
import 'package:flutter_app/navBar.dart';
import 'package:flutter_app/productsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signUp.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials().then((_) {
      if (_rememberMe &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        _login();
      }
    });
  }

  // Load saved credentials
  Future<void> _loadUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  // Save credentials if "Remember Me" is checked
  Future<void> _saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

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
        _saveUserCredentials();
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref('users/${userCredential.user?.uid}');

        DataSnapshot snapshot = await userRef.get();

        final userData = snapshot.value as Map<dynamic, dynamic>;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavBar(isAdmin: userData['isadmin'])),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text("Remember Me"),
                    ],
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
                    child: Text("Forget password?"),
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
