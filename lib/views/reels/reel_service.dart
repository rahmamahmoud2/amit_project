import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:instagram_application/core/cloud_services.dart';

class ReelService {
  Future<void> pickAndUploadReel(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final file = File(pickedFile.path);
        final url = await CloudinaryService().uploadVideo(file);

        await FirebaseFirestore.instance.collection('reels').add({
          'videoUrl': url,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم رفع الريل بنجاح")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل رفع الريل: $e")),
        );
      }
    }
  }
}
