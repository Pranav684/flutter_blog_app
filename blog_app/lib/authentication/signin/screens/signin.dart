import 'package:blog_app/authentication/services/auth_services.dart';
import 'package:blog_app/authentication/signup/screens/signup.dart';
import 'package:blog_app/home/screens/my_home_page_screen.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/services/local_storage.dart';
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
      Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MyHomePage(title: "Blogify")),
      );
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
      appBar: AppBar(
        title: Text(
          "Sign In",
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: screenHeight / 30,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
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
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: screenHeight / 8,
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
                      ),
                    ),
                  ],
                ),
              ],
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
    );
  }
}
