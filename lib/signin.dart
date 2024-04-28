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

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed in: ${userCredential.user!.uid}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationWidget(userId: _emailController.text)), // Navigate to the home page
      );
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
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
                        onTap: (){Navigator.of(context).push(
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
    );
  }
}

