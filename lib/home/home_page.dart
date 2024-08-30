import 'package:example_custom_url_shortener/handle_app_links/handle_app_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () async {
              final shortLink =
                  await HandleAppLinks.generateShortLink('/profile');

              await Share.share(
                shortLink,
                subject: 'Check out my profile',
              );
            },
            child: const Text('Share Profile Link'),
          ),
          ElevatedButton(
            onPressed: () async {
              final shortLink =
                  await HandleAppLinks.generateShortLink('/notification');

              await Share.share(
                shortLink,
                subject: 'Check out my notification',
              );
            },
            child: const Text('Share Notification Link'),
          ),
        ],
      )),
    );
  }
}
