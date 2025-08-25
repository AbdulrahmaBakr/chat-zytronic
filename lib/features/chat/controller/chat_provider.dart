import 'package:chat/features/chat/model/chat_thread_model.dart';
import 'package:chat/features/chat/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(this._db);
  final FirebaseFirestore _db;

  Stream<List<ChatThread>> threadsFor(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ChatThread.fromDoc).toList());
  }

  Stream<List<Message>> messages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map((s) => s.docs.map(Message.fromDoc).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final msgRef = _db.collection('chats').doc(chatId).collection('messages').doc();
    final now = Timestamp.now();
    await msgRef.set({
      'id': msgRef.id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text.trim(),
      'sentAt': now,
      'status': 'sent',
    });

    final chatDoc = _db.collection('chats').doc(chatId);
    final snapshot = await chatDoc.get();

    if (snapshot.exists) {
      await chatDoc.update({
        'lastMessage': text.trim(),
        'updatedAt': now,
      });
    } else {
      await chatDoc.set({
        'id': chatId,
        'participants': [senderId],
        'lastMessage': text.trim(),
        'updatedAt': now,
      });
    }
  }
}
