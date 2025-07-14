import 'package:flutter/material.dart';
import 'package:instagram_application/views/story/story_model.dart';
import 'package:story_view/story_view.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> storyItems;

  const StoryViewerScreen({Key? key, required this.storyItems})
      : super(key: key);

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  final StoryController _storyController = StoryController();

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyList = widget.storyItems
        .map(
          (story) => StoryItem.pageImage(
            url: story.imageUrl,
            controller: _storyController,
            duration: const Duration(seconds: 5),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StoryView(
            storyItems: storyList,
            controller: _storyController,
            onComplete: () => Navigator.pop(context),
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            },
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
