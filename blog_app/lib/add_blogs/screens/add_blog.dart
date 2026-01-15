import 'dart:convert';
import 'dart:io';

import 'package:blog_app/add_blogs/screens/description_area.dart';
import 'package:blog_app/add_blogs/services/backend_services.dart';
import 'package:blog_app/home/model/user_data_model.dart';

import 'package:blog_app/services/image_upload.dart';
import 'package:blog_app/utility/theme/colors.dart';
import 'package:fleather/fleather.dart';
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
  late FleatherController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FleatherController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool triedSubmittingOnce = false;
  bool isUploading = false;

  Future<void> uploadBlog(String userId) async {
    var resopnse = await BlogApiClient.uploadBlogService(
      _titleController.text,
      _descriptionController.text,
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
      _descriptionController.text=jsonEncode(_controller.document.toDelta().toJson());
      setState(() {});
      if (_titleController.text.trim().isEmpty ||
          _descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a title and body')),
        );
        return;
      }

      if (userData == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not found')));
        return;
      }
      setState(() {
        isUploading = true;
      });
      try {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidth / paddingSizeHorizontal,
            right: screenWidth / paddingSizeHorizontal,
            top: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.blackColor,
                    ),
                  ),

                  if (isUploading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: handleSubmit,
                      child: Icon(
                        Icons.send_rounded,
                        color: AppColors.blackColor,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
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
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.60,
                child: TextField(
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a descriptive title',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Divider(height: 16, color: Colors.grey[800]),
              const SizedBox(height: 8),
              Container(
                height: 500,
                color: AppColors.whiteColor,
                child: Column(
                  children: [
                    FleatherToolbar.basic(controller: _controller),
                    Expanded(
                      child: FleatherEditor(
                        controller: _controller,
                        focusNode: FocusNode(),
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              // TextField(
              //   controller: _descriptionController,
              //   keyboardType: TextInputType.multiline,
              //   maxLines: null,
              //   style: const TextStyle(color: Colors.white,fontSize: 15),
              //   decoration: InputDecoration(
              //     hintText: 'Share your thoughts...'
              //         ,
              //     hintStyle: TextStyle(color: Colors.grey[500]),
              //     filled: true,
              //     fillColor: const Color(0xFF1A1A1D),
              //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              if ((_titleController.text.trim().isEmpty ||
                      _descriptionController.text.trim().isEmpty) &&
                  triedSubmittingOnce)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please complete all fields',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
