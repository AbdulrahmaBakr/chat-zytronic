import 'package:flutter/material.dart';

class StoryRing extends StatelessWidget {
  const StoryRing({super.key, required this.avatar, required this.label});
  final String avatar;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: [Color(0xFF25D366), Color(0xFF34B7F1), Color(0xFF25D366)]),
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).scaffoldBackgroundColor),
        ),
        CircleAvatar(
          radius: 20,
          backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
          child: avatar.isEmpty ? Text(label.isNotEmpty ? label[0] : '?') : null,
        ),
      ],
    );
  }
}
