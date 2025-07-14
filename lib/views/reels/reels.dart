import 'package:flutter/material.dart';
import 'package:instagram_application/views/reels/reel_service.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reels')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final reels = snapshot.data!.docs;

              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reels.length,
                itemBuilder: (context, index) {
                  final reelData = reels[index].data() as Map<String, dynamic>;
                  return ReelPlayer(
                    videoUrl: reelData['videoUrl'],
                    shopName: reelData['shopName'] ?? "@zoya.st0re",
                    description: reelData['description'] ??
                        "Dress Available - Discount 30%",
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.video_call, color: Colors.white),
              onPressed: () async {
                await ReelService().pickAndUploadReel(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReelPlayer extends StatefulWidget {
  final String videoUrl;
  final String shopName;
  final String description;

  const ReelPlayer({
    super.key,
    required this.videoUrl,
    required this.shopName,
    required this.description,
  });

  @override
  State<ReelPlayer> createState() => _ReelPlayerState();
}

class _ReelPlayerState extends State<ReelPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: () {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            },
            child: Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shopName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: const [
                      Icon(Icons.favorite_border,
                          color: Colors.white, size: 32),
                      SizedBox(height: 16),
                      Icon(Icons.comment, color: Colors.white, size: 32),
                      SizedBox(height: 16),
                      Icon(Icons.share, color: Colors.white, size: 32),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
