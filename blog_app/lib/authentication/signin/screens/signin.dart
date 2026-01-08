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
      body: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
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
                            padding: const EdgeInsets.only(
                              top: 100.0,
                              bottom: 50,
                            ),
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
                            "Welcome back! Glad to see you, Again!",
                            style: AppValue.largeTextStyle,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 5,
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  cursorColor: AppColors.blackColor,
                                  decoration: AppValue.inputDecoration.copyWith(
                                    label: Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: screenHeight / labelFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
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
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Forget Password?',
                                    style: AppValue.smallTextStyle.copyWith(
                                      color: AppColors.darkGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 150),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _submitForm();
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
                              child: Text(
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppValue.smallTextStyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          " Sign Up",
                          style: AppValue.smallTextStyle.copyWith(
                            color: AppColors.orangeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
