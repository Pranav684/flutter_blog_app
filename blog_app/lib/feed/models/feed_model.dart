// To parse this JSON data, do
//
//     final Blogs = BlogsFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';

class BlogsNotifier extends StateNotifier<Blogs?> {
  BlogsNotifier() : super(null);

  void getBlogsFromDb(Blogs blogs) {
    state = blogs;
  }
}

final blogsProvider = StateNotifierProvider<BlogsNotifier, Blogs?>((ref) {
  return BlogsNotifier();
});


// To parse this JSON data, do
//
//     final Blogs = BlogsFromJson(jsonString);

Blogs blogsFromJson(String str) => Blogs.fromJson(json.decode(str));

String blogsToJson(Blogs data) => json.encode(data.toJson());

class Blogs {
    bool success;
    List<Blog> blogs;

    Blogs({
        required this.success,
        required this.blogs,
    });

    factory Blogs.fromJson(Map<String, dynamic> json) => Blogs(
        success: json["success"],
        blogs: List<Blog>.from(json["blogs"].map((x) => Blog.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "blogs": List<dynamic>.from(blogs.map((x) => x.toJson())),
    };
}

class Blog {
    String id;
    String title;
    String body;
    String? coverImageUrl;
    CreatedBy createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Blog({
        required this.id,
        required this.title,
        required this.body,
        required this.coverImageUrl,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["_id"],
        title: json["title"],
        body: json["body"],
        coverImageUrl: json["coverImageURL"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "coverImageURL": coverImageUrl,
        "createdBy": createdBy.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class CreatedBy {
    String id;
    String fullName;
    String email;
    String profileImageUrl;
    String role;

    CreatedBy({
        required this.id,
        required this.fullName,
        required this.email,
        required this.profileImageUrl,
        required this.role,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        fullName: json["fullName"],
        email: json["email"],
        profileImageUrl: json["profileImageUrl"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "email": email,
        "profileImageUrl": profileImageUrl,
        "role": role,
    };
}
