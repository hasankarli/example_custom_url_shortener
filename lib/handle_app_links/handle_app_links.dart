import 'dart:convert';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
const vercelBackendUrl =
    'https://examplecustomurlshortener-hasankarlis-projects.vercel.app';

class HandleAppLinks {
  HandleAppLinks._();

  static final instance = HandleAppLinks._();

  final _appLinks = AppLinks();

  bool isRedirecting = false;

  Future<void> init() async {
    log('HandleAppLinks init');
    await _initAppLinks();
    await _streamAppLinks();
  }

  Future<void> _initAppLinks() async {
    log('HandleAppLinks _initAppLinks');
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      log('HandleAppLinks _initAppLinks appLink: $appLink');
      await _handleAppLink(appLink);
    }
  }

  Future<void> _streamAppLinks() async {
    log('HandleAppLinks _streamAppLinks');
    _appLinks.uriLinkStream.listen((Uri uri) async {
      log('HandleAppLinks _streamAppLinks uri: $uri');
      await _handleAppLink(uri);
    });
  }

  Future<void> _handleAppLink(Uri uri) async {
    if (isRedirecting) return;
    log('HandleAppLinks _handleAppLink uri: $uri');
    isRedirecting = true;
    final deepLink = await _getOriginalLink(uri);
    final path = deepLink.split('/').last;
    switch (path) {
      case 'profile':
        await navigatorKey.currentState!.pushNamed('/profile');
      case 'notification':
        await navigatorKey.currentState!.pushNamed('/notification');
      default:
        await navigatorKey.currentState!.pushNamed('/');
    }
    isRedirecting = false;
  }

  Future<String> _getOriginalLink(Uri uri) async {
    final dio = Dio();
    String deepLink = '';
    try {
      final response = await dio.head<void>(uri.toString());
      final headers = response.headers.map;
      for (final key in headers.keys) {
        if (key == 'location' && headers[key] != null) {
          final decodedBase64 = base64.decode(headers[key]!.first);
          deepLink = utf8.decode(decodedBase64);
        }
      }
    } catch (e) {
      log('_getOriginalLink error: $e');
    }
    return deepLink;
  }

  static Future<String> generateShortLink(String link) async {
    final dio = Dio();

    final title = 'My Link $link';
    const description = 'My Link Description';
    final imageUrl =
        'https://picsum.photos/250/250?random=${DateTime.now().millisecondsSinceEpoch}';
    const androidPackageName = 'com.hasankarli.exampleCustomUrlShortener';
    const iosBundleId = 'com.hasankarli.exampleCustomUrlShortener';

    final response = await dio.post<String>(
      '$vercelBackendUrl/api/generate_short_link',
      data: {
        'originalLink': vercelBackendUrl + link,
        'androidPackageName': androidPackageName,
        'iosBundleId': iosBundleId,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
      },
    );

    final decoded = jsonDecode(response.data!) as Map<String, dynamic>;

    return decoded['shortLink'] as String;
  }
}
