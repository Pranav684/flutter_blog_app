import 'package:blog_app/blog/model/blog_model.dart';
import 'package:blog_app/blog/services/blog_service.dart';
import 'package:blog_app/utility/functions/parse_json.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogView extends ConsumerStatefulWidget {
  const BlogView({super.key});

  @override
  ConsumerState<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends ConsumerState<BlogView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isLiked = false;
  bool _isSaved = false;

  double _scale = 1.0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    var blogDataController = ref.read(blogDataProvider);
    _isLiked = blogDataController!.blog.likedByMe;
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  void _onLikeTap(String blogId) async {
    setState(() {
      _isLiked = !_isLiked;
    });
    var result = await BlogDataApiClient.postLikeAction(blogId);
    print(result);
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCommentTap() async {
    setState(() {
      _isAnimating = true;
    });
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _scale = 1.6;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _scale = 1.0;
    });

    if (mounted) {
      var blogDataController = ref.read(blogDataProvider);
      List<Comment> reversedComments = blogDataController!.comments.reversed
          .toList();
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CommentBottomSheet(comments: reversedComments),
      );
      setState(() {});
    }

    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var blogDataController = ref.watch(blogDataProvider);
    var height = MediaQuery.of(context).size.height;
    final parsedContent = parseRichText(blogDataController!.blog.body);

    final FleatherController? contentController = parsedContent != null
        ? FleatherController(
            document: ParchmentDocument.fromJson(parsedContent),
          )
        : null;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.blackColor),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isSaved = !_isSaved;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: !_isSaved
                  ? Image.asset("assets/icons/save_outlined.png")
                  : Image.asset("assets/icons/saved_red.png"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.whiteColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      blogDataController.blog.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                            child:
                                blogDataController
                                        .blog
                                        .createdBy
                                        .profileImageUrl ==
                                    null
                                ? Icon(
                                    Icons.person,
                                    color: AppColors.darkGreyColor,
                                  )
                                : CircleAvatar(
                                    radius: height * 0.022,
                                    backgroundImage: NetworkImage(
                                      blogDataController
                                          .blog
                                          .createdBy
                                          .profileImageUrl!,
                                    ),
                                    backgroundColor: Colors.grey[800],
                                    onBackgroundImageError:
                                        (exception, stackTrace) {
                                          print(exception.toString());
                                        },
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.darkGreyColor,
                                    ),
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
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: Text(
                            blogDataController.blog.createdBy.fullName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 0.7),
                  // if (blogDataController.blog.coverImageUrl!=null)
                  //   ClipRRect(
                  //     borderRadius: const BorderRadius.vertical(
                  //       top: Radius.circular(0),
                  //     ),
                  //     child: Image.network(
                  //       blogDataController.blog.coverImageUrl!,
                  //       width: double.infinity,
                  //       errorBuilder: (context, error, stackTrace) {
                  //         return  Icon(Icons.person, color: AppColors.darkGreyColor,);
                  //       },
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: contentController != null
                        ? FleatherEditor(
                            controller: contentController,
                            readOnly: true,
                          )
                        : Text(
                            blogDataController.blog.body,
                            style: TextStyle(color: AppColors.blackColor),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: GestureDetector(
              onTap: () async {
                _onLikeTap(blogDataController.blog.id);
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.favorite,
                  color: _isLiked ? AppColors.redColor : AppColors.greyColor,
                  size: 30,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () async {
              _onCommentTap();
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isAnimating
                      ? Image.asset("assets/gifs/comments.gif", height: 24)
                      : Image.asset(
                          "assets/icons/comments_static.png",
                          height: 24,
                        ),
                  const SizedBox(width: 8),
                  Text(
                    "${blogDataController.comments.length}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                      leading: comments[index].createdBy.profileImageUrl == null
                          ? Icon(Icons.person, color: AppColors.darkGreyColor)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                comments[index].createdBy.profileImageUrl!,
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                print(exception.toString());
                              },
                              child: Icon(
                                Icons.person,
                                color: AppColors.darkGreyColor,
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
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/icons/comments_static.png",
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
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.white54,
                              ),
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
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
