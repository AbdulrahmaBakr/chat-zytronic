import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class Story {
  final String userName;
  final String avatar;
  final List<StoryItem> items;
  Story({required this.userName, required this.avatar, required this.items});
}

class StoryItem {
  final String imageUrl;
  final String? caption;
  StoryItem({required this.imageUrl, this.caption});
}

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  // fake random stories

  @override
  Widget build(BuildContext context) {
    final stories = _fakeStories();
    if (stories.isEmpty) return const Center(child: Text('No updates'));
    return ListView.separated(
      itemCount: stories.length,
      separatorBuilder: (_, __) => const Divider(indent: 88, height: 0),
      itemBuilder: (context, i) {
        final s = stories[i];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(s.avatar), radius: 28),
          title: Text(s.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: const Text('Tap to view'),
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 320),
              pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: StoryViewer(story: s)),
            ),
          ),
        );
      },
    );
  }
}

class StoryViewer extends StatefulWidget {
  const StoryViewer({super.key, required this.story});
  final Story story;

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  int index = 0;
  Timer? _timer;
  bool _paused = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!_paused) {
        if (!mounted) return;
        setState(() {
          _progress = (_progress + 0.02).clamp(0.0, 1.0);
          if (_progress >= 1.0) {
            _next();
          }
        });
      }
    });
  }

  void _next() {
    if (index < widget.story.items.length - 1) {
      if (!mounted) return;
      setState(() {
        index++;
        _progress = 0;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _prev() {
    if (index > 0) {
      setState(() {
        index--;
        _progress = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.story.items[index];
    return GestureDetector(
      onLongPressStart: (_) => setState(() => _paused = true),
      onLongPressEnd: (_) => setState(() => _paused = false),
      onTapUp: (d) {
        final w = MediaQuery.of(context).size.width;
        if (d.localPosition.dx > w / 2) {
          _next();
        } else {
          _prev();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl, fit: BoxFit.cover)
                  : Container(color: Colors.black54),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(widget.story.avatar)),
                        const SizedBox(width: 8),
                        Text(widget.story.userName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // progress bars
                    Row(
                      children: List.generate(widget.story.items.length, (i) {
                        final active = i == index;
                        final done = i < index;
                        final v = done
                            ? 1.0
                            : active
                                ? _progress
                                : 0.0;
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i == widget.story.items.length - 1 ? 0 : 4),
                            height: 2.8,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: v,
                                child: Container(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            if (item.caption?.isNotEmpty == true)
              Positioned(
                left: 16,
                right: 16,
                bottom: 32,
                child: Text(item.caption!,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, shadows: [Shadow(blurRadius: 6, color: Colors.black54)])),
              ),
          ],
        ),
      ),
    );
  }
}

List<Story> _fakeStories() {
  final rnd = Random();
  final avatars = [
    "https://i.pravatar.cc/150?img=1",
    "https://i.pravatar.cc/150?img=2",
    "https://i.pravatar.cc/150?img=3",
    "https://i.pravatar.cc/150?img=4",
  ];
  final images = [
    "https://picsum.photos/400/700?random=1",
    "https://picsum.photos/400/700?random=2",
    "https://picsum.photos/400/700?random=3",
    "https://picsum.photos/400/700?random=4",
  ];
  return List.generate(5, (i) {
    return Story(
      userName: "User $i",
      avatar: avatars[i % avatars.length],
      items: List.generate(
        rnd.nextInt(3) + 1,
        (j) => StoryItem(
          imageUrl: images[rnd.nextInt(images.length)],
          caption: "Story ${j + 1} of User $i",
        ),
      ),
    );
  });
}
