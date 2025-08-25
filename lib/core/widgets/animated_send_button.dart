import 'package:flutter/material.dart';

class AnimatedSendButton extends StatefulWidget {
  const AnimatedSendButton({super.key, required this.sending, required this.onPressed});
  final bool sending;
  final VoidCallback onPressed;

  @override
  State<AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<AnimatedSendButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));

  @override
  void didUpdateWidget(covariant AnimatedSendButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.sending && widget.sending) {
      _c.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ripple
          AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              final v = Curves.easeOut.transform(_c.value);
              return Container(
                width: 44 + 16 * v,
                height: 44 + 16 * v,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.12 * (1 - v)),
                ),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), padding: EdgeInsets.zero, minimumSize: const Size(44, 44)),
            onPressed: widget.sending ? null : widget.onPressed,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: widget.sending
                  ? const Icon(Icons.check, key: ValueKey('check'))
                  : const Icon(Icons.send_rounded, key: ValueKey('send')),
            ),
          ),
        ],
      ),
    );
  }
}
