import 'package:blog_app/utility/constants/constant_value.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: Color(0xFF242424),
        child: Center(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              Image.asset("assets/gifs/post_success_animation.gif"),
              SizedBox(
                height: screenHeight * 0.80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset("assets/gifs/is_live_now.gif",height: 150,),
                          Padding(
                            padding: const EdgeInsets.only(top:32.0),
                            child: Text(
                              "Your story...",
                              style: AppValue.largeTextStyle.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 60,
                          width: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.whiteColor,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: AppValue.mediumTextStyle.copyWith(
                                fontWeight: FontWeight.w300,
                                color: AppColors.whiteColor,
                              ),
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
      ),
    );
  }
}
