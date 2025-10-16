import 'package:blog_app/authentication/signin/screens/signin.dart';
import 'package:blog_app/profile/models/profile_model.dart';
import 'package:blog_app/services/local_db.dart';
import 'package:blog_app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    var userData = ref.read(userProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            // padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF141417),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: height * 0.04, // circle size
                        backgroundImage: NetworkImage(
                          userData!.profileImageUrl,
                        ),
                        backgroundColor: Colors.grey[800], // fallback background
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData.emailAddress,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF141417),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('Role', style: TextStyle(color: Colors.white70)),
                    subtitle: Text(userData.role, style: const TextStyle(color: Colors.white)),
                  ),
                  const Divider(color: Colors.white24, height: 1),
                  ListTile(
                    title: const Text('User ID', style: TextStyle(color: Colors.white70)),
                    subtitle: Text(userData.userid, style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              LocalDb.deleteUser();
              LocalStorage.clearStorage();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => SignInScreen()),
              );
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              height: height * 0.05,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Center(
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
