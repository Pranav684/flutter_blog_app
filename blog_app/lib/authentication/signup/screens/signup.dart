import 'dart:io';

import 'package:blog_app/authentication/services/auth_services.dart';
import 'package:blog_app/authentication/signin/screens/signin.dart';
import 'package:blog_app/home/screens/my_home_page_screen.dart';
import 'package:blog_app/services/image_upload.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/services/local_storage.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _urlController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? imageFile;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urlController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email Validation
  String? _emailValidation(String? email) {
    if (email == null || email.isEmpty) {
      return "Enter your email!";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email!";
    }
    return null;
  }

  // Password Validation
  String? _passwordValidation(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter your password!";
    }
    if (password.length < 6) {
      return "Please enter at least 6 characters!";
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // All validations passed ✅
      if (imageFile == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please attach an image!')));
      }
      var url = await uploadImage(imageFile!);
      _urlController.text = url!;
      dynamic response = await ApiClient.userSignUpCall(
        _urlController.text,
        _fullNameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (response['success']) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MyHomePage(title: "Blogify")),
        );
        LocalStorage.saveToken(response['token']);
        LocalDb.saveUserData(response['user']);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Form Submitted Successfully!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Something went wrong!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int paddingSizeHorizontal = 10;
    int labelFontSize = 60;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: screenHeight / 30,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight / 6,
                      width: screenHeight / 6,
                      margin: EdgeInsets.all(screenWidth / paddingSizeHorizontal),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            imageFile!=null?CircleAvatar(
                              backgroundImage: FileImage(imageFile!),
                              radius: screenHeight/12,
                            ):Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: screenHeight / 8,
                            ),
                            GestureDetector(
                              onTap: () async {
                                imageFile = await pickImage();
                                setState(() {
                                  
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth / paddingSizeHorizontal,
                            right: screenWidth / paddingSizeHorizontal,
                          ),
                          child: TextFormField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              label: Text(
                                "Full Name",
                                style: TextStyle(
                                  fontSize: screenHeight / labelFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth / paddingSizeHorizontal,
                            right: screenWidth / paddingSizeHorizontal,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              label: Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: screenHeight / labelFontSize,
                                ),
                              ),
                            ),
                            validator: _emailValidation,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth / paddingSizeHorizontal,
                            right: screenWidth / paddingSizeHorizontal,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              label: Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: screenHeight / labelFontSize,
                                ),
                              ),
                            ),
                            validator: _passwordValidation,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _submitForm();
                      },
                      child: Container(
                        height: screenHeight / 20,
                        width: screenWidth / 3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: screenHeight / 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx) => SignInScreen()),
                            );
                          },
                          child: Text(
                            " Sign In",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
