import 'dart:convert';
import 'dart:io';
import 'package:blog_app/feed/models/feed_model.dart';
import 'package:http/http.dart' as http;
import 'package:blog_app/services/local_storage.dart';




class BlogApiClient {
  static const String baseUrl = "http://localhost:8000";

  static Future<dynamic> getAllBlogsServices(
  ) async {
   
      var token = await LocalStorage.getToken();
      print(token);
      var response = await http.get(
        Uri.parse("$baseUrl/blog/get_all_blogs"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 👈 Add token here
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        var allBlogs=Blogs.fromJson(jsonDecode(response.body));
     
        return allBlogs;
      }
       try {
    } catch (e) {
      return HttpException("Blog Not Uploaded!");
    }
  }
}
