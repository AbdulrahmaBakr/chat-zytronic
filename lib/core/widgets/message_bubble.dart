import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.isMe, required this.time, required this.status});
  final String text;
  final bool isMe;
  final String time;
  final String status; // sent/delivered/seen

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? const Color(0xFFE7FFDB) : Theme.of(context).cardColor; // WhatsApp-ish
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMe ? 16 : 2),
      bottomRight: Radius.circular(isMe ? 2 : 16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Column(
        crossAxisAlignment: align,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            child: DecoratedBox(
              decoration: BoxDecoration(color: bg, borderRadius: radius),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 66.0),
                      child: Text(text, style: const TextStyle(height: 1.25, color: Colors.black)),
                    ),
                    Positioned(
                      right: 6,
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(time,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54, fontSize: 11)),
                          const SizedBox(width: 4),
                          Icon(
                            status == 'seen'
                                ? Icons.done_all
                                : status == 'delivered'
                                    ? Icons.done_all
                                    : Icons.check,
                            size: 16,
                            color: status == 'seen' ? Colors.lightBlue : Colors.black45,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
