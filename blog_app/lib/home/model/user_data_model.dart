// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void getUserFromDb(User user) {
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class User {
  String userid;
  String userName;
  String emailAddress;
  String? profileImageUrl;
  String role;

  User({
    required this.userid,
    required this.userName,
    required this.emailAddress,
    required this.profileImageUrl,
    required this.role,
  });
}
