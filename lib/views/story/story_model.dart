import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String id;
  final String uid;
  final String imageUrl;
  final DateTime timestamp;

  StoryModel({
    required this.id,
    required this.uid,
    required this.imageUrl,
    required this.timestamp,
  });

  factory StoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      imageUrl: data['storyUrl'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
