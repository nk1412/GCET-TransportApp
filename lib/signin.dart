// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, use_key_in_widget_constructors


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navigation_widget.dart';
import 'signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _eerrorMessage;
  String? _perrorMessage;
  bool _errorOccurred = false;

  @override
  void initState() {
    super.initState();
    // Check if the user is already signed in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is already signed in, navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationWidget(userId: user.email!)),
        );
      }
    });
  }

  Future<void> signup() async {
    setState(() {
      _eerrorMessage = null;
      _perrorMessage = null;
      _errorOccurred = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _eerrorMessage = null;
      _perrorMessage = null;
      _errorOccurred = false;
    });

    FocusScope.of(context).unfocus();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationWidget(userId: _emailController.text)), // Navigate to the home page
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == "wrong-password") {
          setState(() {
            _perrorMessage = "Wrong password. Please try again.";
            _errorOccurred = true;
          });
        }
        if (e.code == "user-not-found") {
          setState(() {
            _eerrorMessage = "User does not exist, please create an account first.";
            _errorOccurred = true;
          });
        }
        if (e.code == "invalid-email") {
          setState(() {
            _eerrorMessage = "Invalid Email, please recheck!";
            _errorOccurred = true;
          });
        }
      }
      print('Failed to sign up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = _errorOccurred ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.41;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 35, 114),
        body: Center(
          child:Container( 
            decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
            height: containerHeight,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.37,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _eerrorMessage,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _eerrorMessage != null ? Colors.red : Colors.blue),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _eerrorMessage != null ? Colors.red : Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: _perrorMessage,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _perrorMessage != null ? Colors.red : Colors.blue),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: _perrorMessage != null ? Colors.red : Colors.grey),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _signInWithEmailAndPassword,
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 16.0),
                        const Text("Don't have an account?"),
                        const SizedBox(height: 6.0),
                        InkWell(
                          onTap: (){
                            signup();

                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const SignUpPage()),
                            );
                          },
                          child: const Text('Sign Up',style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

