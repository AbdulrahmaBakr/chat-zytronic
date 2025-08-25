import 'package:chat/features/chat/model/chat_thread_model.dart';
import 'package:chat/features/chat/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:animations/animations.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.thread});
  final ChatThread thread;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Theme.of(context).scaffoldBackgroundColor,
      transitionType: ContainerTransitionType.fadeThrough,
      middleColor: Theme.of(context).scaffoldBackgroundColor,
      openBuilder: (context, _) => ChatScreen(chatId: thread.id, title: thread.title, avatar: thread.avatar),
      closedBuilder: (context, open) => ListTile(
        onTap: open,
        leading: CircleAvatar(
            radius: 24,
            backgroundImage: thread.avatar.isNotEmpty ? NetworkImage(thread.avatar) : null,
            child: thread.avatar.isEmpty ? Text(thread.title[0]) : null),
        title: Text(thread.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(thread.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing:
            Text(DateFormat('HH:mm').format(thread.updatedAt.toDate()), style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
