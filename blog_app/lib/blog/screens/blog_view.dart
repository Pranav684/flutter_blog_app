import 'package:blog_app/blog/model/blog_model.dart';
import 'package:blog_app/blog/services/blog_service.dart';
import 'package:blog_app/feed/models/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogView extends ConsumerStatefulWidget {
  const BlogView({super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView> {
  @override
  Widget build(BuildContext context) {
    var blogDataController = ref.watch(blogDataProvider);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: height * 0.04,
                      width: height * 0.04,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: height * 0.02, // circle size
                          backgroundImage: NetworkImage(
                            blogDataController!.blog.createdBy.profileImageUrl,
                          ),
                          backgroundColor:
                              Colors.grey[200], // fallback background
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        blogDataController.blog.createdBy.fullName,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(blogDataController.blog.coverImageUrl),
              SelectableText.rich(
                TextSpan(
                  
                  children: [
                    TextSpan(
                      text: "${blogDataController.blog.title}\n",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: blogDataController.blog.body,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () async {
            List<Comment> reversedComments=blogDataController.comments.reversed.toList();
            await showModalBottomSheet(
              context: context,
              isScrollControlled:
                  true, // 👈 allows full height when keyboard opens
              backgroundColor:
                  Colors.transparent, // 👈 for rounded corners effect
              builder: (context) =>
                  CommentBottomSheet(comments: reversedComments),
            );
            setState(() {});
          },
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(2),
            width: width * 0.20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 152, 152, 152),
                  offset: Offset.zero,
                  blurRadius: 1,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/comment_icon.png",
                    height: height * 0.04,
                  ),
                ),
                Text(
                  "${blogDataController.comments.length}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentBottomSheet extends ConsumerWidget {
  final List<Comment> comments;
  static TextEditingController commentController = TextEditingController();
  const CommentBottomSheet({super.key, required this.comments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var blogDataController = ref.read(blogDataProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.6, // how much of screen it takes initially
      minChildSize: 0.4,
      maxChildSize: 0.95, // can drag up almost full screen
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // small grey drag handle
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // comments list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        comments[index].createdBy.profileImageUrl,
                      ),
                    ),
                    title: Text(comments[index].createdBy.fullName),
                    subtitle: Text(comments[index].content),
                  ),
                ),
              ),

              // comment input bar (like Instagram)
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/comment_icon.png",
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        var result = await BlogDataApiClient.postComment(
                          blogDataController!.blog.id,
                          commentController.text,
                        );
                        if (result) {
                          var response = await BlogDataApiClient.getBlogById(
                            blogDataController.blog.id,
                          );
                          ref
                              .read(blogDataProvider.notifier)
                              .setBlogData(response);
                        }
                        commentController.clear();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
