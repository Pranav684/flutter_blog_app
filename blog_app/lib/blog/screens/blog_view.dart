import 'package:blog_app/blog/model/blog_model.dart';
import 'package:blog_app/blog/services/blog_service.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0E0E10),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E0E10),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Blog', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF141417),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: height * 0.045,
                            width: height * 0.045,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white24,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: height * 0.022,
                                backgroundImage: NetworkImage(
                                  blogDataController!
                                      .blog
                                      .createdBy
                                      .profileImageUrl,
                                ),
                                backgroundColor: Colors.grey[800],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              blogDataController.blog.createdBy.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (blogDataController.blog.coverImageUrl!=null)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                        child: Image.network(
                          blogDataController.blog.coverImageUrl!,
                          width: double.infinity,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blogDataController.blog.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            blogDataController.blog.body,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () async {
            List<Comment> reversedComments = blogDataController
                .comments
                .reversed
                .toList();
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  CommentBottomSheet(comments: reversedComments),
            );
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1D),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white24, width: 1),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 6),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icons/comment_icon.png",
                  color: Colors.white,
                  height: 35,
                ),
                const SizedBox(width: 8),
                Text(
                  "${blogDataController.comments.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: bottomInset),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF141417),
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
                  color: Colors.white24,
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
                    title: Text(
                      comments[index].createdBy.fullName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      comments[index].content,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),

              // comment input bar (like Instagram)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/comment_icon.png",
                        color: Colors.white,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: const Color(0xFF1A1A1D),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
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
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
