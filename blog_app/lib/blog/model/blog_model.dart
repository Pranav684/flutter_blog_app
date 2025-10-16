// To parse this JSON data, do
//
//     final BlogData = BlogDataFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';


class BlogDataNotifier extends StateNotifier<BlogData?> {
  BlogDataNotifier() : super(null);

  void setBlogData(BlogData blogData) {
    state = blogData;
  }
}

final blogDataProvider = StateNotifierProvider<BlogDataNotifier, BlogData?>((ref) {
  return BlogDataNotifier();
});



BlogData blogDataFromJson(String str) => BlogData.fromJson(json.decode(str));

String blogDataToJson(BlogData data) => json.encode(data.toJson());

class BlogData {
    bool success;
    Blog blog;
    List<Comment> comments;

    BlogData({
        required this.success,
        required this.blog,
        required this.comments,
    });

    factory BlogData.fromJson(Map<String, dynamic> json) => BlogData(
        success: json["success"],
        blog: Blog.fromJson(json["blog"]),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "blog": blog.toJson(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
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

class Comment {
    String id;
    String content;
    String blogId;
    CreatedBy createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Comment({
        required this.id,
        required this.content,
        required this.blogId,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        content: json["content"],
        blogId: json["blogId"],
        createdBy: CreatedBy.fromJson(json["createdBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "blogId": blogId,
        "createdBy": createdBy.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
