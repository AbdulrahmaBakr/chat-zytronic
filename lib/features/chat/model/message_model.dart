import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final Timestamp sentAt;
  final String status; // sent | delivered | seen

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    required this.status,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      chatId: d['chatId'] ?? '',
      senderId: d['senderId'] ?? '',
      text: d['text'] ?? '',
      sentAt: d['sentAt'] ?? Timestamp.now(),
      status: d['status'] ?? 'sent',
    );
  }

  Map<String, dynamic> toMap() => {
        'chatId': chatId,
        'senderId': senderId,
        'text': text,
        'sentAt': sentAt,
        'status': status,
      };
}
