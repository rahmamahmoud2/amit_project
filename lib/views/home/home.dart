import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/views/addPost/add_post.dart';
import 'package:instagram_application/views/chats/chat_screen.dart';
import 'package:instagram_application/views/home/favourite_widget.dart';
import 'package:instagram_application/views/story/story_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> toggleLike(String postId, Map<String, dynamic> postData) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('likes')
        .doc(postId);

    final exists = (await docRef.get()).exists;

    if (exists) {
      await docRef.delete();
    } else {
      await docRef.set(postData);
    }

    setState(() {});
  }

  Future<bool> isPostLiked(String postId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('likes')
        .doc(postId)
        .get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Instagram',
          style: TextStyle(
            fontFamily: 'silvana',
            fontSize: 32,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LikedPostsScreen()),
              );
            },
            icon: Icon(Icons.favorite_border, color: theme.iconTheme.color),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    otherUserImage: 'https://example.com/image.jpg',
                    otherUserId: 'uid_123',
                    otherUserName: 'Ahmed',
                  ),
                ),
              );
            },
            icon: Icon(Icons.send_outlined, color: theme.iconTheme.color),
          ),
          const AddPost(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return const StoryBar();

              final post = posts[index - 1];
              final data = post.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: (data['userImage'] != null &&
                              data['userImage'].toString().isNotEmpty)
                          ? NetworkImage(data['userImage'])
                          : null,
                      child: (data['userImage'] == null ||
                              data['userImage'].toString().isEmpty)
                          ? Icon(Icons.person,
                              color: theme.iconTheme.color?.withOpacity(0.5))
                          : null,
                    ),
                    title: Text(
                      data['username'] ?? 'User',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (data['uid'] ==
                            FirebaseAuth.instance.currentUser!.uid)
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'delete') {
                                await FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(post.id)
                                    .delete();
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text('delete'.tr()),
                                  ],
                                ),
                              ),
                            ],
                            icon: Icon(Icons.more_horiz,
                                color: theme.iconTheme.color),
                          ),
                      ],
                    ),
                  ),
                  if (data['images'] != null && data['images'] is List)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: PageView.builder(
                        itemCount: (data['images'] as List).length,
                        itemBuilder: (context, imageIndex) {
                          final imageUrl = data['images'][imageIndex];
                          return Image.network(
                            imageUrl,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 5),
                  if (data['caption'] != null &&
                      data['caption'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${data['username']} ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge!.color,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text: data['caption'],
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge!.color,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      FutureBuilder<bool>(
                        future: isPostLiked(post.id),
                        builder: (context, snapshot) {
                          final isLiked = snapshot.data ?? false;
                          return IconButton(
                            onPressed: () {
                              toggleLike(post.id, data);
                            },
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color:
                                  isLiked ? Colors.red : theme.iconTheme.color,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.comment_outlined,
                            color: theme.iconTheme.color),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send_outlined,
                            color: theme.iconTheme.color),
                      ),
                      const Spacer(),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('saved')
                            .doc(post.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final isSaved = snapshot.data?.exists ?? false;
                          return IconButton(
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved
                                  ? Colors.amber
                                  : theme.iconTheme.color,
                            ),
                            onPressed: () async {
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final docRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .collection('saved')
                                  .doc(post.id);

                              if (isSaved) {
                                await docRef.delete();
                              } else {
                                await docRef.set(data);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
