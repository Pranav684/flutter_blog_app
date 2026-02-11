import 'dart:convert';
import 'dart:io';
import 'package:blog_app/blog/model/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:blog_app/services/local_storage.dart';

class BlogDataApiClient {
  static const String baseUrl = "http://localhost:8000";

  static Future<dynamic> getBlogById(blogId) async {
    try {
      var token = await LocalStorage.getToken();
      print(token);
      print(blogId);
      var response = await http.get(
        Uri.parse("$baseUrl/blog/$blogId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 👈 Add token here
        },
      );
      // print(response.body);
      if (response.statusCode == 200) {
        var blogData = BlogData.fromJson(jsonDecode(response.body));

        return blogData;
      }
    } catch (e) {
      print(e);
      return HttpException("Blog Not Uploaded!");
    }
  }

  static Future<bool> postComment(blogId, content)async{
    Map<String,dynamic> payload={
      "content":content
    };
    try{
      var token=await LocalStorage.getToken();
      var response=await http.post(
        Uri.parse("$baseUrl/blog/comment/$blogId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 👈 Add token here
        },
        body: jsonEncode(payload)
      );
      var decodedResponse=jsonDecode(response.body);
      if(decodedResponse["success"]==true){
        return true;
      }
    }catch(e){
      return false;
    }
    return false;
  }

  static Future<bool> postLikeAction(blogId)async{
    try{
      var token=await LocalStorage.getToken();
      var response=await http.post(
        Uri.parse("$baseUrl/blog/like/$blogId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 👈 Add token here
        },
      );
      var decodedResponse=jsonDecode(response.body);
      return decodedResponse["success"];
    }catch(e){
      return false;
    }
  }
}
