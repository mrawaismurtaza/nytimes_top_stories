import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';
import 'package:nytimes_top_stories/features/shared_widgets/detailed_view_card.dart';

class MasterDetailLayout extends StatelessWidget {
  final List<TopStory> stories;
  final TopStory? selectedStory;
  final String? selectedThumbnailUrl;
  final String selectedSection;
  final Function(TopStory story, String? thumbnailUrl) onStorySelected;

  const MasterDetailLayout({
    super.key,
    required this.stories,
    required this.selectedStory,
    required this.selectedThumbnailUrl,
    required this.selectedSection,
    required this.onStorySelected,
  });

  String? _getThumbnailUrl(TopStory story) {
    if (story.multimedia != null && story.multimedia!.isNotEmpty) {
      final thumb = story.multimedia!.firstWhere(
        (m) => m['format'] == 'Standard Thumbnail',
        orElse: () {
          story.multimedia!.sort((a, b) => (a['width'] ?? 9999).compareTo(b['width'] ?? 9999));
          return story.multimedia!.first;
        },
      );
      return thumb['url'] as String?;
    }
    return null;
  }

  void _openWebView(BuildContext context, TopStory story) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewScreen(url: story.url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // Master panel (List of stories)
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: colorScheme.onSurface.withOpacity(0.12),
                width: 1,
              ),
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<TopStoriesBloc>().add(RefreshTopStories(selectedSection));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final thumbnailUrl = _getThumbnailUrl(story);
                final isSelected = selectedStory?.url == story.url;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Material(
                    color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onStorySelected(story, thumbnailUrl),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: thumbnailUrl != null
                                  ? Image.network(
                                      thumbnailUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 60,
                                        height: 60,
                                        color: colorScheme.onBackground.withOpacity(0.1),
                                        child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 24),
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: colorScheme.onBackground.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 24),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    story.byline,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    story.abstractText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 12,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Detail panel
        Expanded(
          child: selectedStory != null
              ? DetailPanel(
                  story: selectedStory!,
                  thumbnailUrl: selectedThumbnailUrl,
                  onOpenWebView: () => _openWebView(context, selectedStory!),
                )
              : const EmptyDetailPanel(),
        ),
      ],
    );
  }
}

class DetailPanel extends StatelessWidget {
  final TopStory story;
  final String? thumbnailUrl;
  final VoidCallback onOpenWebView;

  const DetailPanel({
    super.key,
    required this.story,
    required this.thumbnailUrl,
    required this.onOpenWebView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          // Detail panel header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.12),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Article Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onOpenWebView,
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('See More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          // Detail content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large image
                  if (thumbnailUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        thumbnailUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 250,
                          color: colorScheme.onBackground.withOpacity(0.1),
                          child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 64),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Title
                  Text(
                    story.title,
                    style: TextStyle(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Byline
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.onBackground.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      story.byline,
                      style: TextStyle(
                        color: colorScheme.onBackground.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    story.abstractText,
                    style: TextStyle(
                      color: colorScheme.onBackground.withOpacity(0.8),
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyDetailPanel extends StatelessWidget {
  const EmptyDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80,
              color: colorScheme.onBackground.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Select an article to view details',
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}