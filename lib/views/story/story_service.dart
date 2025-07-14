import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_application/views/story/story_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../core/cloud_services.dart';

class StoryService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final cloudinary = CloudinaryService();

  Future<void> uploadStory(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    final uid = _auth.currentUser!.uid;
    final storyId = const Uuid().v1();
    final imageUrl = await cloudinary.uploadImage(File(file.path));

    await _firestore.collection('stories').doc(storyId).set({
      'uid': uid,
      'storyUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ تم رفع الستوري بنجاح")),
    );
  }

  Stream<List<StoryModel>> getStories() {
    return _firestore
        .collection('stories')
        .where('timestamp',
            isGreaterThan:
                Timestamp.now().toDate().subtract(const Duration(hours: 24)))
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => StoryModel.fromDoc(doc)).toList());
  }
}
