import 'package:blog_app/add_blogs/screens/add_blog.dart';
import 'package:blog_app/feed/screens/feed_screen.dart';
import 'package:blog_app/profile/models/profile_model.dart';
import 'package:blog_app/profile/screens/profile_screen.dart';
import 'package:blog_app/services/local_db.dart';
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic userData;
    WidgetsBinding.instance.addPostFrameCallback((_)async{
    userData=await LocalDb.getUserData();
    print("user Data:$userData");
    User user=User(userid: userData!["_id"], userName: userData!["fullName"], emailAddress: userData["email"], profileImageUrl: userData["profileImageUrl"],role: userData["role"]);
    var userController=ref.read(userProvider.notifier);
    userController.getUserFromDb(user);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(244, 0, 0, 0),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.grey[500],),
        ),
      ),
      body: bottomNavigationBarCurrentIndex==1?AddBlogScreen():bottomNavigationBarCurrentIndex==2? ProfileScreen():FeedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavigationBarCurrentIndex,
        backgroundColor: const Color.fromARGB(244, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 58, 58, 58),
        selectedItemColor: Colors.grey[500],
        onTap:
            (value) => setState(() {
              bottomNavigationBarCurrentIndex = value;
            }),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: "Add Blog",
            icon: Icon(Icons.add_to_photos),
          ),
          BottomNavigationBarItem(label: "User", icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
