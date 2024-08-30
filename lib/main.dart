import 'package:example_custom_url_shortener/handle_app_links/handle_app_links.dart';
import 'package:example_custom_url_shortener/home/home_page.dart';
import 'package:example_custom_url_shortener/notification/notification_page.dart';
import 'package:example_custom_url_shortener/profile/profile_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    HandleAppLinks.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/notification': (context) => const NotificationPage(),
      },
    );
  }
}
