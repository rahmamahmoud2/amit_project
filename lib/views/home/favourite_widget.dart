import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedPostsScreen extends StatelessWidget {
  const LikedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Liked Posts")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('likes')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final likedPosts = snapshot.data!.docs;

          if (likedPosts.isEmpty) {
            return const Center(child: Text('No liked posts yet 💔'));
          }

          return ListView.builder(
            itemCount: likedPosts.length,
            itemBuilder: (context, index) {
              final post = likedPosts[index].data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post['images'] != null && post['images'] is List)
                    Image.network(
                      post['images'][0], // أول صورة فقط
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ListTile(
                    title: Text(post['username'] ?? 'User'),
                    subtitle: Text(post['caption'] ?? ''),
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
