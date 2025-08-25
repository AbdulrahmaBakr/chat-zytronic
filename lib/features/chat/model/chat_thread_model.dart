import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThread {
  final String id;
  final String title;
  final String avatar;
  final String lastMessage;
  final Timestamp updatedAt;
  final List<String> participants;

  ChatThread({
    required this.id,
    required this.title,
    required this.avatar,
    required this.lastMessage,
    required this.updatedAt,
    required this.participants,
  });

  factory ChatThread.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ChatThread(
      id: doc.id,
      title: d['title'] ?? 'Unknown',
      avatar: d['avatar'] ?? '',
      lastMessage: d['lastMessage'] ?? '',
      updatedAt: d['updatedAt'] ?? Timestamp.now(),
      participants: (d['participants'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
