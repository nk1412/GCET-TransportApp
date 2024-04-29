// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, use_key_in_widget_constructors


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'navigation_widget.dart';
//import 'signin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUpWithEmailAndPassword() async {
    FocusScope.of(context).unfocus();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed up: ${userCredential.user!.uid}');
      Navigator.pop(context);
    } catch (e) {
      print('Failed to sign up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor : const Color.fromARGB(255, 27, 35, 114),
        body: Center(
          child:Container( 
            decoration: BoxDecoration(
              color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
            height: MediaQuery.of(context).size.height * 0.41,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.37,
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
                        onPressed: _signUpWithEmailAndPassword,
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 16.0),
                      const Text("Already have an account?"),
                      const SizedBox(height: 6.0),
                      InkWell(
                        onTap: (){Navigator.pop(context);
                        },
                        child: const Text('Sign In',style: TextStyle(color: Colors.blue),),
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
