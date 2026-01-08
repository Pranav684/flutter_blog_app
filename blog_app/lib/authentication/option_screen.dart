import 'package:blog_app/authentication/signin/screens/signin.dart';
import 'package:blog_app/authentication/signup/screens/signup.dart';
import 'package:blog_app/utility/constants/constant_text.dart';
import 'package:blog_app/utility/constants/constant_value.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.offWhiteColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppText.appName,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: AppValue.superLargeSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ".",
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontSize: AppValue.superLargeSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Personal Blogging Partner",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppValue.smallTextSize,
                  ),
                ),
              ],
            ),

            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(
                      255,
                      254,
                      154,
                      129,
                    ).withValues(alpha: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          254,
                          154,
                          129,
                        ).withValues(alpha: 0.9), // core
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.85,
                      colors: [
                        const Color.fromARGB(
                          255,
                          255,
                          73,
                          27,
                        ).withValues(alpha: 0.9), // core
                        const Color.fromARGB(
                          255,
                          252,
                          84,
                          42,
                        ).withValues(alpha: 0.9), // core
                        const Color.fromARGB(
                          255,
                          252,
                          108,
                          72,
                        ).withValues(alpha: 0.9), // core
                        const Color.fromARGB(
                          255,
                          254,
                          154,
                          129,
                        ).withValues(alpha: 0.9), // core
                        const Color.fromARGB(
                          255,
                          253,
                          175,
                          156,
                        ).withValues(alpha: 0.9), // core
                        const Color.fromARGB(
                          255,
                          252,
                          198,
                          184,
                        ).withValues(alpha: 0.9), // core
                        Colors.transparent, // fade out
                      ],
                      // stops: const [0.0, 0.45, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          254,
                          154,
                          129,
                        ).withValues(alpha: 0.9), // core
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Tell your story with us.",
                  style: AppValue.largeTextStyle,
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>SignInScreen())),
              child: Container(
                height: 60,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.blackColor, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: AppValue.mediumTextStyle.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'New here?',
                    style: AppValue.smallTextStyle.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>SignUpScreen())),
                  child: Container(
                    height: 60,
                    width: 220,
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.blackColor, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        'Register',
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
      ),
    );
  }
}
