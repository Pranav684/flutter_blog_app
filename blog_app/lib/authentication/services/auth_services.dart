import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "http://localhost:8000";

  static Future<dynamic> userSignUpCall(
    String imgUrl,
    String fullName,
    String email,
    String password,
  ) async {
    try {
      Map<String, dynamic> payload = {
        "profileImageUrl": imgUrl,
        "fullName": fullName,
        "email": email,
        "password": password,
      };

      final response = await http.post(
        Uri.parse("$baseUrl/user/signup"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded", // ✅ important
        },
        body: payload,
      );
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        print(body);
        return body;
      }
    } catch (e) {
      return HttpException("Sign up failed!");
    }
  }

  static Future<dynamic> userSignInCall(String email, String password) async {
    try {
      Map<String, dynamic> payload = {"email": email, "password": password};
      final response = await http.post(
        Uri.parse("$baseUrl/user/signin"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded", // ✅ important
        },
        body: payload,
      );
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        print(body);
        return body;
      }
    } catch (e) {
      print("Error");
      return HttpException("Sign in failed!");
    }
  }
}
