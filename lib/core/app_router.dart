import 'package:flutter/material.dart';
import 'package:nytimes_top_stories/features/screens/home.dart';
import 'package:nytimes_top_stories/features/screens/detail_view.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';

class AppRouter {
  static const String home = '/';
  static const String detail = '/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const Home(),
          settings: settings,
        );
      case detail:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          final story = args['story'] as TopStory;
          final thumbnailUrl = args['thumbnailUrl'] as String?;
          return MaterialPageRoute<void>(
            builder: (_) => DetailView(story: story, thumbnailUrl: thumbnailUrl),
            settings: settings,
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}