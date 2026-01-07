import 'dart:async';

import 'package:blog_app/authentication/option_screen.dart';
import 'package:blog_app/authentication/signin/screens/signin.dart';
import 'package:blog_app/feed/models/feed_model.dart';
import 'package:blog_app/feed/services/backend_services.dart';
import 'package:blog_app/home/screens/my_home_page_screen.dart';
import 'package:blog_app/services/local_storage.dart';
import 'package:blog_app/utility/constants/constant_text.dart';
import 'package:blog_app/utility/constants/constant_value.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    bool isUserLoggedIn = false;

    Future<void> getUserToken() async {
      dynamic token = await LocalStorage.getToken();
      if (token == null) {
        isUserLoggedIn = false;
        return;
      }
      isUserLoggedIn = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUserToken();
      var blogs = await BlogApiClient.getAllBlogsServices();
      if (blogs != null) {
        ref.read(blogsProvider.notifier).getBlogsFromDb(blogs);
      }
    });

    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => isUserLoggedIn
              ? MyHomePage(title: AppText.appName)
              : OptionScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: Row(
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
        ),
      ),
    );
  }
}
