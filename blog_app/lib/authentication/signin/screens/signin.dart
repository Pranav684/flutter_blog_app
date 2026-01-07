import 'package:blog_app/authentication/services/auth_services.dart';
import 'package:blog_app/authentication/signup/screens/signup.dart';
import 'package:blog_app/home/screens/my_home_page_screen.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/services/local_storage.dart';
import 'package:blog_app/utility/constants/constant_value.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    dynamic response = await ApiClient.userSignInCall(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (response['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Form Submitted Successfully!')));
      LocalStorage.saveToken(response['token']);
      LocalDb.saveUserData(response['user']);
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => MyHomePage(title: "Blogify")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong!')));
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
      body: SizedBox(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth / paddingSizeHorizontal,
                  right: screenWidth / paddingSizeHorizontal,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.greyColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor,)),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                    Text(
                      "Welcome back! Glad to see you, Again!",
                      style: AppValue.largeTextStyle,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            label: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: screenHeight / labelFontSize,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            label: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: screenHeight / labelFontSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _submitForm();
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
                      Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          " Sign Up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
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
