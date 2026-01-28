import 'dart:convert';

import 'package:blog_app/blog/model/blog_model.dart';
import 'package:blog_app/blog/screens/blog_view.dart';
import 'package:blog_app/blog/services/blog_service.dart';
import 'package:blog_app/feed/models/feed_model.dart';
import 'package:blog_app/feed/services/backend_services.dart' as feed_api;
import 'package:blog_app/utility/constants/constant_value.dart';
import 'package:blog_app/utility/functions/parse_json.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerStatefulWidget {
  final Function toggleMenu;
  const FeedScreen({super.key, required this.toggleMenu});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(vsync: this);
  late FleatherController _contentController;
  bool isflipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
  }

  void flip() {
    if (isflipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    isflipped = !isflipped;
  }

  Future<void> _refreshBlogs() async {
    final blogs = await feed_api.BlogApiClient.getAllBlogsServices();
    if (!mounted) return;
    if (blogs is Blogs) {
      ref.read(blogsProvider.notifier).getBlogsFromDb(blogs);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to refresh feed')));
    }
  }

  void _getBlogData(blogId) async {
    BlogData response = await BlogDataApiClient.getBlogById(blogId);
    if (!mounted) return;

    if (response.success) {
      ref.read(blogDataProvider.notifier).setBlogData(response);
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => BlogView()));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong!')));
    }
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var blogController = ref.watch(blogsProvider);
    return RefreshIndicator(
      onRefresh: _refreshBlogs,
      child: Container(
        padding: EdgeInsets.only(top: 100, left: 25, right: 25),
        decoration: BoxDecoration(color: AppColors.offWhiteColor),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    flip();
                    widget.toggleMenu();
                  },
                  child: SizedBox(
                    height: 30,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        final angle = _controller.value * 3.1416;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          child: child,
                        );
                      },
                      child: Image.asset("assets/icons/menu_icon.png"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 30,
                    child: Image.asset(
                      "assets/icons/notification_bell_icon.png",
                    ),
                  ),
                ),
              ],
            ),
            Row(children: []),

            SizedBox(
              height: height * 0.70,
              child: ListView.builder(
                itemCount: blogController == null
                    ? 0
                    : blogController.blogs.length,
                itemBuilder: (context, index) {
                  String body = blogController!.blogs[index].body;
                  final parsedContent = parseRichText(body);

                  final FleatherController? contentController =
                      parsedContent != null
                      ? FleatherController(
                          document: ParchmentDocument.fromJson(parsedContent),
                        )
                      : null;

                  return Container(
                    // height: height*0.25,
                    width: double.infinity,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogController.blogs[index].title,
                          style: AppValue.mediumTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              // height: height * 0.04,
                              // width: height * 0.04,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 12, // circle size
                                  backgroundImage: NetworkImage(
                                    blogController
                                        .blogs[index]
                                        .createdBy
                                        .profileImageUrl,
                                  ),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                        print(exception.toString());
                                      },
                                  backgroundColor:
                                      Colors.grey[200], // fallback background
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.darkGreyColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              blogController.blogs[index].createdBy.fullName,
                              style: AppValue.smallTextStyle,
                            ),
                          ],
                        ),
                        Divider(color: AppColors.darkGreyColor),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: 200,
                          ),
                          // height: 200,
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: contentController != null
                                ? FleatherEditor(
                                    controller: contentController,
                                    readOnly: true,
                                  )
                                : Text(
                                    body,
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _getBlogData(blogController.blogs[index].id),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.blackColor,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Read More',
                                style: AppValue.mediumTextStyle.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: AppValue.smallTextSize
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
