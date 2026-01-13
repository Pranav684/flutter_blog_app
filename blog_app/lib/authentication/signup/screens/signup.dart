import 'dart:io';

import 'package:blog_app/authentication/services/auth_services.dart';
import 'package:blog_app/authentication/signin/screens/signin.dart';
import 'package:blog_app/home/screens/my_home_page_screen.dart';
import 'package:blog_app/services/image_upload.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/services/local_storage.dart';
import 'package:blog_app/splash/screens/splash_screen.dart';
import 'package:blog_app/utility/constants/constant_value.dart';
import 'package:blog_app/utility/theme/colors.dart';
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

  bool isLoading=false;

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
        return;
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
        LocalStorage.saveToken(response['token']);
        LocalDb.saveUserData(response['user']);
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => SplashScreen()),
        );
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
      backgroundColor: AppColors.offWhiteColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth / paddingSizeHorizontal,
                  right: screenWidth / paddingSizeHorizontal,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.greyColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Hello! Register to get started",
                      style: AppValue.largeTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.redColor,
                                      AppColors.orangeColor,
                                      AppColors.offWhiteColor,
                                    ],
                                    stops: [0.2, 0.55, 1.0],
                                  ),
                                ),
                              ),
                              Container(
                                height: 138,
                                width: 138,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 153, 80),
                                      Color.fromARGB(255, 255, 80, 80),
                                      Color.fromARGB(255, 255, 80, 185),
                                      Color.fromARGB(255, 159, 81, 255),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.orangeColor.withAlpha(
                                        126,
                                      ),
                                      blurRadius: 30,
                                    ),
                                  ],

                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                height: 130,
                                width: 130,
                                margin: EdgeInsets.all(
                                  screenWidth / paddingSizeHorizontal,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.offWhiteColor,

                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    imageFile = await pickImage();
                                    setState(() {});
                                  },
                                  child: imageFile != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(
                                            imageFile!,
                                          ),
                                          radius: screenHeight / 12,
                                        )
                                      : Icon(
                                          Icons.photo_camera_outlined,
                                          color: AppColors.blackColor,
                                          size: screenHeight / 20,
                                        ),
                                ),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 2.0,
                                ),
                                child: TextFormField(
                                  controller: _fullNameController,
                                  decoration: AppValue.inputDecoration.copyWith(
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
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 2.0,
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: AppValue.inputDecoration.copyWith(
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
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 8.0,
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  decoration: AppValue.inputDecoration.copyWith(
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
                              setState(() {
                                isLoading=true;
                              });
                              await _submitForm();
                              setState(() {
                                isLoading=false;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 220,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.blackColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: isLoading?CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ):Text(
                                  'Submit',
                                  style: AppValue.mediumTextStyle.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: AppValue.smallTextStyle,),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => SignInScreen()),
                      );
                    },
                    child: Text(
                      " Sign In",
                      style: AppValue.smallTextStyle.copyWith(color: AppColors.orangeColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight / 15,
        decoration: BoxDecoration(color: AppColors.blackColor),
        child: Center(
          child: Text(
            "Blogify @2026",
            style: TextStyle(color: AppColors.offWhiteColor),
          ),
        ),
      ),
    );
  }
}
