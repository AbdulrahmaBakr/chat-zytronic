import 'package:chat/core/theme/app_theme.dart';
import 'package:chat/core/theme/theme_provider.dart';
import 'package:chat/features/auth/controller/auth_provider.dart';
import 'package:chat/features/auth/screen/login_screen.dart';
import 'package:chat/features/chat/controller/chat_provider.dart';
import 'package:chat/features/home/screen/home_screen.dart' show HomeScreen;
import 'package:chat/features/stories/controller/story_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WhatsAppStyleApp());
}

class WhatsAppStyleApp extends StatelessWidget {
  const WhatsAppStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => ChatProvider(FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => StoryProvider(FirebaseFirestore.instance)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WhatsApp',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
