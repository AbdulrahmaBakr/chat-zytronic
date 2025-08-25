import 'package:chat/features/chat/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'id': 'chat1',
        'title': 'Ahmed',
        'avatar': 'https://i.pravatar.cc/150?img=1',
      },
      {
        'id': 'chat2',
        'title': 'Mona',
        'avatar': 'https://i.pravatar.cc/150?img=2',
      },
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final c = chats[index];
        return ListTile(
          leading: Hero(
            tag: c['id']!,
            child: CircleAvatar(backgroundImage: NetworkImage(c['avatar']!)),
          ),
          title: Text(c['title']!),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ChatScreen(
                  chatId: c['id']!,
                  title: c['title']!,
                  avatar: c['avatar']!,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final offsetTween = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeOut));

                  return SlideTransition(
                    position: animation.drive(offsetTween),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
