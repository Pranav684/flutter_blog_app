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

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startFluctuation();

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
      Duration(seconds: 3),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startFluctuation() async {
    for (int i = 0; i < 3; i++) {
      await _controller.forward();
      await _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppText.appName,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppValue.superLargeSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FadeTransition(
                  opacity: _controller,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.redColor,
                    ),
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
