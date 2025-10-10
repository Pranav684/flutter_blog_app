import 'package:blog_app/blog/model/blog_model.dart';
import 'package:blog_app/blog/screens/blog_view.dart';
import 'package:blog_app/blog/services/blog_service.dart';
import 'package:blog_app/feed/models/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {


    void _getBlogData(blogId) async {
    BlogData response = await BlogDataApiClient.getBlogById(blogId);
    if (!mounted) return;

    if (response.success) {
    ref.read(blogDataProvider.notifier).setBlogData(response);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => BlogView()),
      );
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
    return Container(
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.secondary
      ),
      child: ListView.builder(
        itemCount: blogController == null ? 0 : blogController.blogs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async{
              _getBlogData(blogController.blogs[index].id);
            },
            child: Container(
              // height: height*0.25,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onPrimary,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentGeometry.topLeft,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          blogController!.blogs[index].coverImageUrl,
                          width: double.infinity,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 214, 214, 214).withValues(
                            alpha: 0.2,
                          ), // transparent color
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color.fromARGB(255, 206, 206, 206).withValues(
                              alpha: 0.3,
                            ), // subtle border
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                    blogController
                                        .blogs[index]
                                        .createdBy
                                        .profileImageUrl,
                                  ),
                                  backgroundColor:
                                      Colors.grey[200], // fallback background
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                blogController.blogs[index].createdBy.fullName,
                                style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogController.blogs[index].title,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(blogController.blogs[index].body),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
