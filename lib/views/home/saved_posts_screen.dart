import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('saved')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final savedPosts = snapshot.data!.docs;

          if (savedPosts.isEmpty) {
            return const Center(child: Text('No saved posts yet 💾'));
          }

          return ListView.builder(
            itemCount: savedPosts.length,
            itemBuilder: (context, index) {
              final post = savedPosts[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(post['userImage'] ?? ''),
                      ),
                      title: Text(post['username'] ?? ''),
                    ),
                    if (post['images'] != null && post['images'] is List)
                      Image.network(
                        post['images'][0],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    if (post['caption'] != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(post['caption']),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
