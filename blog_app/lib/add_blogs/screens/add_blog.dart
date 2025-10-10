import 'dart:io';

import 'package:blog_app/add_blogs/services/backend_services.dart';
import 'package:blog_app/profile/models/profile_model.dart';
import 'package:blog_app/services/image_upload.dart';
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

  void uploadBlog(String userId) async {
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    int paddingSizeHorizontal = 10;
    int labelFontSize = 60;
    var userData = ref.read(userProvider);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          children: [
            Stack(
              alignment: AlignmentGeometry.topRight,
              children: [
                Container(
                  height: screenHeight * 0.40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 229, 237),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        var imgFile = await pickImage();
                        setState(() {
                          coverImageFile = imgFile;
                        });
                      },
                      child: coverImageFile != null
                          ? Image.file(coverImageFile!, fit: BoxFit.contain)
                          : Icon(
                              Icons.add_photo_alternate_rounded,
                              size: screenHeight * 0.20,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
                coverImageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              coverImageFile = null;
                            });
                          },
                          child: Icon(Icons.cancel),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            if (coverImageFile == null && triedSubmittingOnce)
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Please attach and image to be uploaded!",
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth / paddingSizeHorizontal,
                            right: screenWidth / paddingSizeHorizontal,
                          ),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              label: Text(
                                "Title",
                                style: TextStyle(
                                  fontSize: screenHeight / labelFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth / paddingSizeHorizontal,
                            right: screenWidth / paddingSizeHorizontal,
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null, // ✅ allows automatic line wrapping
                            expands:
                                false, // keep it growing only when text exceeds one line
                            decoration: InputDecoration(
                                label: Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: screenHeight / labelFontSize,
                                  ),
                                ),
                              ),
                          ),
                        ),
                              
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     left: screenWidth / paddingSizeHorizontal,
                        //     right: screenWidth / paddingSizeHorizontal,
                        //   ),
                        //   child: TextFormField(
                        //     // controller: _descriptionController,
                        //     decoration: InputDecoration(
                        //       label: Text(
                        //         "Description",
                        //         style: TextStyle(
                        //           fontSize: screenHeight / labelFontSize,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        if ((_titleController.text.isEmpty ||
                                _descriptionController.text.isEmpty) &&
                            triedSubmittingOnce)
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Please attach and image to be uploaded!",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  triedSubmittingOnce = true;
                  if (_titleController.text.isEmpty ||
                      _descriptionController.text.isEmpty ||
                      coverImageFile == null) {
                    setState(() {});
                    return;
                  }
                  if (coverImageFile != null) {
                    coverImageUrl = (await uploadImage(coverImageFile!))!;
                  }
                  uploadBlog(userData!.userid);
                },
                child: Container(
                  height: screenHeight / 20,
                  width: screenWidth / 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: screenHeight / 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
