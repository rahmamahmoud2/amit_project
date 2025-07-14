import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_application/core/sizes.dart';
import 'package:instagram_application/core/theme/cubit/theme_cubit.dart';
import 'package:instagram_application/views/home/favourite_widget.dart';
import 'package:instagram_application/views/home/saved_posts_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    userFuture =
        FirebaseFirestore.instance.collection('users').doc(currentUid).get();
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("settings".tr(),
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: Text("toggleTheme".tr()),
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: Text("liked_posts".tr()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LikedPostsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: Text("saved_posts".tr()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SavedPostsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text("change_language".tr()),
                onTap: () {
                  final currentLocale = context.locale.languageCode;
                  final newLocale = currentLocale == 'ar'
                      ? const Locale('en')
                      : const Locale('ar');
                  context.setLocale(newLocale);
                  print("تم تغيير اللغة إلى: ${newLocale.languageCode}");
                  setState(() {}); // عشان يعيد بناء الواجهة
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    appsize().int(context);
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: appsize.screenWidth * 0.02),
            child: FutureBuilder<DocumentSnapshot>(
              future: userFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final username = userData['username'] ?? 'Unknown';
                final bio = userData['bio'] ?? '';
                final imageUrl = userData['imageUrl'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "10+",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.add_box_outlined, size: 28),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.menu, size: 28),
                              onPressed: _showSettingsSheet,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: appsize.screenWidth * 0.12,
                          backgroundImage:
                              imageUrl != null && imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : null,
                          child: imageUrl == null || imageUrl.isEmpty
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _StatWidget(count: "1,234", label: "Posts"),
                              _StatWidget(count: "5,678", label: "Followers"),
                              _StatWidget(count: "9,101", label: "Following"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(username,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(bio),
                    const Text("www.link.com",
                        style: TextStyle(color: Colors.blue)),
                    const SizedBox(height: 6),
                    const Text("Followed by username, username and 100 others"),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'editProfile').then((_) {
                            setState(() {
                              userFuture = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUid)
                                  .get();
                            });
                          });
                        },
                        child: Center(
                          child: Text("edit_profile".tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (_, index) => Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  imageUrl != null && imageUrl.isNotEmpty
                                      ? NetworkImage(imageUrl)
                                      : null,
                              child: imageUrl == null || imageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 24)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text("story_label".tr(),
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.grid_on),
                        Icon(Icons.video_library_outlined),
                        Icon(Icons.person_pin_outlined),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("yourPosts".tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: currentUid)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final posts = snapshot.data!.docs;
                        if (posts.isEmpty) {
                          return Center(child: Text("noPosts".tr()));
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final data =
                                posts[index].data() as Map<String, dynamic>;
                            final imageUrl = data['images'][0];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  'postDetails',
                                  arguments: data,
                                );
                              },
                              child: Image.network(imageUrl, fit: BoxFit.cover),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatWidget extends StatelessWidget {
  final String count;
  final String label;

  const _StatWidget({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
