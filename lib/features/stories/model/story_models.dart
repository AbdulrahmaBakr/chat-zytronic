import 'package:cloud_firestore/cloud_firestore.dart';

class StoryItem {
  final String imageUrl;
  final String? caption;
  final Timestamp createdAt;

  StoryItem({required this.imageUrl, this.caption, required this.createdAt});

  factory StoryItem.fromMap(Map<String, dynamic> m) => StoryItem(
        imageUrl: m['imageUrl'] ?? '',
        caption: m['caption'],
        createdAt: m['createdAt'] ?? Timestamp.now(),
      );
}

class Story {
  final String id;
  final String userId;
  final String userName;
  final String avatar;
  final List<StoryItem> items;

  Story({
    required this.id,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.items,
  });

  factory Story.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Story(
      id: doc.id,
      userId: d['userId'] ?? '',
      userName: d['userName'] ?? 'Contact',
      avatar: d['avatar'] ?? '',
      items: ((d['items'] ?? []) as List).map((e) => StoryItem.fromMap((e as Map).cast<String, dynamic>())).toList(),
    );
  }
}
