import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/core/cloud_services.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );

        if (result == null) return;

        String caption = '';
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('أكتب الكابشن'),
              content: TextField(
                onChanged: (value) => caption = value,
                decoration: InputDecoration(hintText: 'اكتب وصف الصور...'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('تم'),
                )
              ],
            );
          },
        );
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final userData = userDoc.data();
        final username = userData?['username'] ?? 'Unknown';
        final userImage = userData?['imageUrl'] ?? '';

        final cloudinary = CloudinaryService();
        List<String> imageUrls = [];

        for (var file in result.files) {
          final filePath = file.path!;
          final url = await cloudinary.uploadImage(File(filePath));
          imageUrls.add(url);
        }

        await FirebaseFirestore.instance.collection('posts').add({
          'username': username,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'userImage': userImage,
          'caption': caption,
          'images': imageUrls,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {});
      },
      icon: Icon(Icons.add_box_outlined, color: theme.iconTheme.color),
    );
  }
}
