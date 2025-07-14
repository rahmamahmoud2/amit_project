import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> postData;

  const PostDetailsScreen({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(postData['username'] ?? 'User')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (postData['images'] != null)
              Image.network(postData['images'][0], fit: BoxFit.cover),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                postData['caption'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
