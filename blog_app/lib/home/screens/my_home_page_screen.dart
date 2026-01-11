import 'package:blog_app/add_blogs/screens/add_blog.dart';
import 'package:blog_app/feed/screens/feed_screen.dart';
import 'package:blog_app/profile/models/profile_model.dart';
import 'package:blog_app/profile/screens/profile_screen.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int bottomNavigationBarCurrentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    dynamic userData;
      userData = await LocalDb.getUserData();
      User user = User(
        userid: userData!["_id"],
        userName: userData!["fullName"],
        emailAddress: userData["email"],
        profileImageUrl: userData["profileImageUrl"],
        role: userData["role"],
      );
      var userController = ref.read(userProvider.notifier);
      userController.getUserFromDb(user);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhiteColor,
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          bottomNavigationBarCurrentIndex == 1
              ? AddBlogScreen()
              : bottomNavigationBarCurrentIndex == 2
              ? ProfileScreen()
              : FeedScreen(),
          Container(
            margin: EdgeInsets.only(bottom: 50, left: 16, right: 16),
            // width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 205, 205, 205),
                  offset: Offset(0, 3),
                  blurRadius: 5,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => setState(()=>bottomNavigationBarCurrentIndex=0),
                    child: bottomNavigationBarCurrentIndex == 0
                        ? Image.asset(
                            "assets/icons/home_outlined.png",
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            "assets/icons/home_filled.png",
                            width: 20,
                            height: 20,
                          ),
                  ),
                  GestureDetector(
                    onTap: () => setState(()=>bottomNavigationBarCurrentIndex=1),
                    child: bottomNavigationBarCurrentIndex == 1
                        ? Image.asset(
                            "assets/icons/search_outlined.png",
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            "assets/icons/search_filled.png",
                            width: 20,
                            height: 20,
                          ),
                  ),
                  GestureDetector(
                    onTap: () => setState(()=>bottomNavigationBarCurrentIndex=2),
                    child: bottomNavigationBarCurrentIndex == 2
                        ? Image.asset(
                            "assets/icons/save_outlined.png",
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            "assets/icons/save_filled.png",
                            width: 20,
                            height: 20,
                          ),
                  ),
                  GestureDetector(
                    onTap: () => setState(()=>bottomNavigationBarCurrentIndex=3),
                    child: bottomNavigationBarCurrentIndex == 3
                        ? Image.asset(
                            "assets/icons/settings_outlined.png",
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            "assets/icons/settings_filled.png",
                            width: 20,
                            height: 20,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar:

      // BottomNavigationBar(
      //   currentIndex: bottomNavigationBarCurrentIndex,
      //   backgroundColor: const Color.fromARGB(244, 0, 0, 0),
      //   unselectedItemColor: const Color.fromARGB(255, 58, 58, 58),
      //   selectedItemColor: Colors.grey[500],
      //   onTap:
      //       (value) => setState(() {
      //         bottomNavigationBarCurrentIndex = value;
      //       }),
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
      //     BottomNavigationBarItem(
      //       label: "Add Blog",
      //       icon: Icon(Icons.add_to_photos),
      //     ),
      //     BottomNavigationBarItem(label: "User", icon: Icon(Icons.person)),
      //   ],
      // ),
    );
  }
}
