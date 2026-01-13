import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:blog_app/services/local_storage.dart';

class BlogApiClient {
  static const String baseUrl = "http://localhost:8000";

  static Future<dynamic> uploadBlogService(
    title,
    description,
    createdByUserId,
  ) async {
    try {
      var token = await LocalStorage.getToken();
      print(token);
      Map<String, dynamic> payload = {
        "title": title,
        "body": description,
      };
      print(payload);
      var response = await http.post(
        Uri.parse("$baseUrl/blog/upload"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 👈 Add token here
        },
        body: jsonEncode(payload),
      );
      // print(response.body);
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        print(body);
        return body;
      }
    } catch (e) {
      return HttpException("Blog Not Uploaded!");
    }
  }
}
