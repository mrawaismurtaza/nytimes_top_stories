import 'package:flutter/material.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailView extends StatelessWidget {
  final TopStory story;
  const DetailView({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    String? largeImageUrl;
    if (story.multimedia != null && story.multimedia!.isNotEmpty) {
      // Try to get the largest image (by width)
      final sorted = List<Map<String, dynamic>>.from(story.multimedia!);
      sorted.sort((a, b) => (b['width'] ?? 0).compareTo(a['width'] ?? 0));
      largeImageUrl = sorted.first['url'] as String?;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Story Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (largeImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                largeImageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.black12,
                  child: const Icon(Icons.image, color: Colors.black38, size: 48),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            story.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            story.abstractText,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            story.byline,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      title: const Text('See More'),
                    ),
                    body: WebView(
                      initialUrl: story.url,
                    ),
                  ),
                ),
              );
            },
            child: const Text('See more'),
          ),
        ],
      ),
    );
  }
}
