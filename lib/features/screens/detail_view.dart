import 'package:flutter/material.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:nytimes_top_stories/features/shared_widgets/detailed_view_card.dart';

class DetailView extends StatelessWidget {
  final TopStory story;
  final String? thumbnailUrl;
  const DetailView({super.key, required this.story, this.thumbnailUrl});

  void _openWebView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewScreen(url: story.url),
      ),
    );
  }

  Widget _buildImage(String? thumbnailUrl, ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: thumbnailUrl != null
          ? Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: colorScheme.onBackground.withOpacity(0.1),
                child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 64),
              ),
            )
          : Container(
              color: colorScheme.onBackground.withOpacity(0.1),
              child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 64),
            ),
    );
  }

  Widget _buildText(String text, TextStyle style, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: style),
    );
  }

  Widget _buildBylineContainer(String byline, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.onBackground.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        byline,
        style: TextStyle(
          color: colorScheme.onBackground.withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          'Story Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      backgroundColor: colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildImage(thumbnailUrl, colorScheme),
          const SizedBox(height: 24),
          _buildText(
            story.title,
            TextStyle(
              color: colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          _buildText(
            story.abstractText,
            TextStyle(
              color: colorScheme.onBackground.withOpacity(0.8),
              fontSize: 18,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          _buildBylineContainer(story.byline, colorScheme),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          onPressed: () => _openWebView(context),
          child: Text('See More', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onPrimary)),
        ),
      ),
    );
  }
}