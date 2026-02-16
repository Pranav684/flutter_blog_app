import 'package:blog_app/add_blogs/screens/add_blog.dart';
import 'package:blog_app/feed/screens/feed_screen.dart';
import 'package:blog_app/home/screens/menu_screen.dart';
import 'package:blog_app/profile/screens/profile_screen.dart';
import 'package:blog_app/search_blog/screen/search_screen.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller=AnimationController(vsync: this);
  bool isOpen = false;

  int bottomNavigationBarCurrentIndex = 0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    super.initState();
  }

  void toggleMenu() {
    if (isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    isOpen = !isOpen;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.offWhiteColor,
      body: Stack(
        children: [
          MenuScreen(),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              double slide = screenWidth * 0.65 * _controller.value;
              double scale = 1 - (_controller.value * 0.15);
              return Transform(
                transform: Matrix4.identity()
                  ..translateByVector3(Vector3(slide, 0, 0))
                  ..scaleByDouble(scale, scale, 1, 1),
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25 * _controller.value),
                  child: Stack(
                    alignment: AlignmentGeometry.bottomCenter,
                    children: [
                      bottomNavigationBarCurrentIndex == 1
                          ? SearchScreen()
                          : bottomNavigationBarCurrentIndex == 2
                          ? ProfileScreen()
                          : FeedScreen(toggleMenu: toggleMenu,),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 50,
                          left: 16,
                          right: 16,
                        ),
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 218, 218, 218),
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
                                onTap: () => setState(
                                  () => bottomNavigationBarCurrentIndex = 0,
                                ),
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
                                onTap: () => setState(
                                  () => bottomNavigationBarCurrentIndex = 1,
                                ),
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
                                onTap: () => setState(
                                  () => bottomNavigationBarCurrentIndex = 2,
                                ),
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
                                onTap: () => setState(
                                  () => bottomNavigationBarCurrentIndex = 3,
                                ),
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
                ),
              );
            },
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
      //     BottomNavigationBarItem(label: "User", icon: Icon(Icons.person, color: AppColors.darkGreyColor,)),
      //   ],
      // ),
    );
  }
}
