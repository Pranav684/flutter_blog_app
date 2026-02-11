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

// To parse this JSON data, do
//
//     final blog = blogFromJson(jsonString);

Blogs blogsFromJson(String str) => Blogs.fromJson(json.decode(str));

String blogsToJson(Blogs data) => json.encode(data.toJson());

class Blogs {
    bool success;
    List<BlogElement> blogs;

    Blogs({
        required this.success,
        required this.blogs,
    });

    factory Blogs.fromJson(Map<String, dynamic> json) => Blogs(
        success: json["success"],
        blogs: List<BlogElement>.from(json["blogs"].map((x) => BlogElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "blogs": List<dynamic>.from(blogs.map((x) => x.toJson())),
    };
}

class BlogElement {
    String id;
    String title;
    String body;
    int likesCount;
    CreatedBy createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    bool likedByMe;

    BlogElement({
        required this.id,
        required this.title,
        required this.body,
        required this.likesCount,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.likedByMe,
    });

    factory BlogElement.fromJson(Map<String, dynamic> json) => BlogElement(
        id: json["_id"],
        title: json["title"],
        body: json["body"],
        likesCount: json["likesCount"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        likedByMe: json["likedByMe"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "likesCount": likesCount,
        "createdBy": createdBy.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "likedByMe": likedByMe,
    };
}


class CreatedBy {
    String id;
    String fullName;
    String email;
    String? profileImageUrl;
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
