import 'package:chat/core/theme/theme_provider.dart';
import 'package:chat/features/chat/screen/chat_screen.dart';
import 'package:chat/features/home/screen/chat_tap_screen.dart';
import 'package:chat/features/stories/screen/stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDark ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            itemBuilder: (c) => const [
              PopupMenuItem(value: 'new_group', child: Text('New group')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
            onSelected: (value) {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'CHATS'),
            Tab(text: 'STATUS'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatsTab(),
          const StoriesScreen(),
          const Placeholder(),
        ],
      ),
    );
  }
}

class AuthProvider {
  final dynamic user;
  AuthProvider(this.user);
}
