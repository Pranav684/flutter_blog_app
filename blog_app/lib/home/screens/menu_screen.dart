import 'package:blog_app/add_blogs/screens/add_blog.dart';
import 'package:blog_app/authentication/signin/screens/signin.dart';
import 'package:blog_app/home/model/user_data_model.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/services/local_storage.dart';
import 'package:blog_app/utility/constants/constant_value.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic userData = ref.read(userProvider);
    return Container(
      padding: const EdgeInsets.only(top: 100.0, left: 50),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.darkShadeColor),
      child: SizedBox(
        width: screenWidth * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.greyColor,
                  ),
                  child: Center(
                    child: ClipOval(
                      child: userData.profileImageUrl == null
                          ? Icon(Icons.person, color: AppColors.darkGreyColor)
                          : Image.network(
                              height: 100,
                              width: 100,
                              userData.profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: AppColors.darkGreyColor,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0),
              child: Text(
                userData.userName,
                style: AppValue.mediumTextStyle.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(
                color: AppColors.whiteColor,
                thickness: 1,
                endIndent: screenWidth * 0.4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (ctx) => AddBlogScreen()));
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/add_article.png",
                      color: AppColors.whiteColor,
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Add new article",
                      style: AppValue.smallTextStyle.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/your_article.png",
                    color: AppColors.whiteColor,
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Your articles",
                    style: AppValue.smallTextStyle.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  LocalDb.deleteUser();
                  LocalStorage.clearStorage();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => SignInScreen()),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/logout.png",
                      color: AppColors.whiteColor,
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Logout",
                      style: AppValue.smallTextStyle.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
