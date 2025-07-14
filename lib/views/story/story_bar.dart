import 'package:flutter/material.dart';
import 'package:instagram_application/views/story/story_viewer.dart';
import 'story_service.dart';
import 'story_model.dart';

class StoryBar extends StatelessWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final storyService = StoryService();

    return SizedBox(
      height: 110,
      child: StreamBuilder<List<StoryModel>>(
        stream: storyService.getStories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stories = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length + 1,
            itemBuilder: (context, index) {
              // ✅ عنصر إضافة ستوري
              if (index == 0) {
                return GestureDetector(
                  onTap: () async => await storyService.uploadStory(context),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.blueAccent, width: 3),
                              color: Colors.grey[300],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: const Icon(Icons.add,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Your Story",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              final story = stories[index - 1];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoryViewerScreen(
                      storyItems: [story],
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.orange, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(story.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Story",
                      style: TextStyle(fontSize: 12),
                    )
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
