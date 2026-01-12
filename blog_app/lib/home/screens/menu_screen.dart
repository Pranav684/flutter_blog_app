import 'package:blog_app/home/model/user_data_model.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    dynamic userData = ref.read(userProvider);
    return Container(
      padding: const EdgeInsets.all(32.0),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.blackColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50, // circle size
            backgroundImage: NetworkImage(userData!.profileImageUrl),
            backgroundColor: Colors.grey[800], // fallback background
          ),
          Icon(Icons.article_outlined, color: AppColors.whiteColor),
          Icon(Icons.grading_sharp, color: AppColors.whiteColor),
          Icon(Icons.subscriptions_outlined, color: AppColors.whiteColor),
        ],
      ),
    );
  }
}
