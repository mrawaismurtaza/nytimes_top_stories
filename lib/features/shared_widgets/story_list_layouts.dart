import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';
import 'package:nytimes_top_stories/features/screens/detail_view.dart';

class StoryListLayouts extends StatelessWidget {
  final List<TopStory> stories;
  final bool isGridLayout;
  final String selectedSection;

  const StoryListLayouts({
    super.key,
    required this.stories,
    required this.isGridLayout,
    required this.selectedSection,
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TopStoriesBloc>().add(RefreshTopStories(selectedSection));
      },
      child: isGridLayout 
          ? StoryGridView(stories: stories, getThumbnailUrl: _getThumbnailUrl)
          : StoryListView(stories: stories, getThumbnailUrl: _getThumbnailUrl),
    );
  }
}

class StoryListView extends StatelessWidget {
  final List<TopStory> stories;
  final String? Function(TopStory) getThumbnailUrl;

  const StoryListView({
    super.key,
    required this.stories,
    required this.getThumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        final thumbnailUrl = getThumbnailUrl(story);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: StoryListCard(
            story: story,
            thumbnailUrl: thumbnailUrl,
            theme: theme,
            colorScheme: colorScheme,
          ),
        );
      },
    );
  }
}

class StoryGridView extends StatelessWidget {
  final List<TopStory> stories;
  final String? Function(TopStory) getThumbnailUrl;

  const StoryGridView({
    super.key,
    required this.stories,
    required this.getThumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        final thumbnailUrl = getThumbnailUrl(story);
        
        return StoryGridCard(
          story: story,
          thumbnailUrl: thumbnailUrl,
          theme: theme,
          colorScheme: colorScheme,
        );
      },
    );
  }
}

class StoryListCard extends StatelessWidget {
  final TopStory story;
  final String? thumbnailUrl;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const StoryListCard({
    super.key,
    required this.story,
    required this.thumbnailUrl,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailView(story: story, thumbnailUrl: thumbnailUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: thumbnailUrl != null
                    ? Image.network(
                        thumbnailUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: colorScheme.onBackground.withOpacity(0.1),
                          child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 32),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.onBackground.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 32),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            story.byline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryGridCard extends StatelessWidget {
  final TopStory story;
  final String? thumbnailUrl;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const StoryGridCard({
    super.key,
    required this.story,
    required this.thumbnailUrl,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailView(story: story, thumbnailUrl: thumbnailUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: thumbnailUrl != null
                    ? Image.network(
                        thumbnailUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colorScheme.onBackground.withOpacity(0.1),
                          child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 40),
                        ),
                      )
                    : Container(
                        color: colorScheme.onBackground.withOpacity(0.1),
                        child: Icon(Icons.image, color: colorScheme.onBackground.withOpacity(0.4), size: 40),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        story.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.byline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}