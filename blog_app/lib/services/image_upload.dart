import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery); 
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<String?> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child("uploads/$fileName.jpg");
    print(FirebaseStorage.instance.bucket);

    // Upload file
    await ref.putFile(imageFile);

    // Get download URL
    final downloadUrl = await ref.getDownloadURL();
    print(downloadUrl);
  try {
    return downloadUrl;
  } catch (e) {
    print("Upload failed: $e");
    return null;
  }
}

