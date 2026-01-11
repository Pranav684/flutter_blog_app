import 'dart:io';

import 'package:blog_app/add_blogs/services/backend_services.dart';
import 'package:blog_app/profile/models/profile_model.dart';
import 'package:blog_app/services/image_upload.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBlogScreen extends ConsumerStatefulWidget {
  const AddBlogScreen({super.key});

  @override
  ConsumerState<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends ConsumerState<AddBlogScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  File? coverImageFile;
  String? coverImageUrl;
  bool triedSubmittingOnce = false;
  bool isUploading = false;

  Future<void> uploadBlog(String userId) async {
    var resopnse = await BlogApiClient.uploadBlogService(
      _titleController.text,
      _descriptionController.text,
      coverImageUrl,
      userId,
    );
    if (!mounted) return;
    if (resopnse["success"]) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Form Submitted Successfully!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    int paddingSizeHorizontal = 14;
    var userData = ref.read(userProvider);

    Future<void> handleSubmit() async {
      triedSubmittingOnce = true;
      setState(() {});
      if (_titleController.text.trim().isEmpty ||
          _descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a title and body')),
        );
        return;
      }
      if (coverImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add an image')),
        );
        return;
      }
      if (userData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        return;
      }
      setState(() {
        isUploading = true;
      });
      try {
        if (coverImageFile != null) {
          coverImageUrl = await uploadImage(coverImageFile!);
        }
        await uploadBlog(userData.userid);
      } finally {
        if (mounted) {
          setState(() {
            isUploading = false;
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.offWhiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isUploading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: handleSubmit,
              icon:  Icon(Icons.send_rounded, size: 18, color: Colors.grey[500]),
              label:  Text(
                'Post',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey[500]),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white10,
                side: const BorderSide(color: Colors.white24, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: const StadiumBorder(),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / paddingSizeHorizontal,
            vertical: 12,
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF1A1A1D),
                        child: Text(
                          ((userData?.userName.isNotEmpty == true
                                      ? userData!.userName[0]
                                      : 'U')
                                  .toUpperCase()),
                          style:  TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Expanded(
                      //   child: OutlinedButton.icon(
                      //     onPressed: () {
                      //       // Placeholder for selecting a community like Reddit
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text('Community picker not implemented'),
                      //         ),
                      //       );
                      //     },
                      //     icon: const Icon(Icons.group_outlined),
                      //     label: Align(
                      //       alignment: Alignment.centerLeft,
                      //       child: Text(
                      //         'Choose a community',
                      //         style: TextStyle(
                      //           color: Theme.of(context).colorScheme.onSurface,
                      //         ),
                      //       ),
                      //     ),
                      //     style: OutlinedButton.styleFrom(
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 12,
                      //         vertical: 10,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.05),
                  SizedBox(
                    width: screenWidth*0.60,
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a descriptive title',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1D),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 16, color: Colors.grey[800]),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white,fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...'
                          ,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1D),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if ((_titleController.text.trim().isEmpty ||
                          _descriptionController.text.trim().isEmpty ||
                          coverImageFile == null) &&
                      triedSubmittingOnce)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please complete all fields and add an image',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  var imgFile = await pickImage();
                  setState(() {
                    coverImageFile = imgFile;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[700]!,
                    ),
                    color: const Color(0xFF1A1A1D),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: coverImageFile == null
                        ?  Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.add_photo_alternate, color: Colors.grey[500]),
                          )
                        : ClipOval(
                            child: Image.file(
                              coverImageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
