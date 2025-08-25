import 'package:chat/features/chat/model/message_model.dart';
import 'package:chat/core/widgets/animated_send_button.dart';
import 'package:chat/core/widgets/message_bubble.dart';
import 'package:chat/features/auth/controller/auth_provider.dart';
import 'package:chat/features/chat/controller/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId, required this.title, required this.avatar});
  final String chatId;
  final String title;
  final String avatar;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final uid = context.read<AuthProvider>().user!.uid;
    await context.read<ChatProvider>().sendMessage(chatId: widget.chatId, senderId: uid, text: text);
    _controller.clear();
    await Future.delayed(const Duration(milliseconds: 220));
    if (mounted) setState(() => _sending = false);
    // auto-scroll to bottom
    await Future.delayed(const Duration(milliseconds: 50));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final uid = context.watch<AuthProvider>().user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Hero(
              tag: widget.chatId,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: widget.avatar.isNotEmpty ? NetworkImage(widget.avatar) : null,
                child: widget.avatar.isEmpty ? Text(widget.title[0]) : null,
              ),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('online', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
            ])
          ],
        ),
        actions: const [
          Icon(Icons.videocam_outlined),
          SizedBox(width: 16),
          Icon(Icons.call_outlined),
          SizedBox(width: 8),
          Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatProvider.messages(widget.chatId),
              builder: (context, snapshot) {
                final msgs = snapshot.data ?? [];
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[index];
                    final isMe = m.senderId == uid;
                    final time = DateFormat('HH:mm').format(m.sentAt.toDate());
                    return MessageBubble(
                      text: m.text,
                      isMe: isMe,
                      time: time,
                      status: m.status,
                    );
                  },
                );
              },
            ),
          ),
          _Composer(onSend: _send, controller: _controller, sending: _sending),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.onSend, required this.controller, required this.sending});
  final VoidCallback onSend;
  final TextEditingController controller;
  final bool sending;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.emoji_emotions_outlined)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSendButton(sending: sending, onPressed: onSend),
          ],
        ),
      ),
    );
  }
}
