import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_sate.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';
import 'package:nytimes_top_stories/features/screens/detail_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedSection = 'home';
  final List<String> sections = ['home', 'world', 'politics', 'business', 'technology', 'science', 'health', 'sports', 'entertainment'];
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    context.read<TopStoriesBloc>().add(FetchTopStories('home'));
  }

  void _onSearchChanged() {
    context.read<TopStoriesBloc>().add(SearchTopStories(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    void _showSectionFilter() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: sections.map((section) {
              return ListTile(
                title: Text(section, style: TextStyle(fontWeight: selectedSection == section ? FontWeight.bold : FontWeight.normal)),
                trailing: selectedSection == section ? Icon(Icons.check, color: colorScheme.primary) : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedSection = section;
                    _searchController.clear();
                  });
                  context.read<TopStoriesBloc>().add(FetchTopStories(selectedSection));
                },
              );
            }).toList(),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          'Top Stories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: colorScheme.onPrimary,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by title or author',
                      prefixIcon: Icon(Icons.search, color: colorScheme.onBackground),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: _showSectionFilter,
                  icon: Icon(Icons.filter_alt, color: colorScheme.onBackground),
                  label: const Text('Filter'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: CustomScrollView(
              slivers: [
                BlocConsumer<TopStoriesBloc, TopStoriesState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is TopStoriesLoading) {
                      return SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                      );
                    } else if (state is TopStoriesError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64, color: colorScheme.onBackground.withOpacity(0.6)),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${state.message}',
                                style: TextStyle(color: colorScheme.onBackground),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is TopStoriesLoaded) {
                      final stories = state.stories as List<TopStory>;
                      if (stories.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.article_outlined, size: 64, color: colorScheme.onBackground.withOpacity(0.6)),
                                const SizedBox(height: 16),
                                Text('No stories found.', style: TextStyle(color: colorScheme.onBackground)),
                              ],
                            ),
                          ),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final story = stories[index];
                              String? thumbnailUrl;
                              if (story.multimedia != null && story.multimedia!.isNotEmpty) {
                                final thumb = story.multimedia!.firstWhere(
                                  (m) => m['format'] == 'Standard Thumbnail',
                                  orElse: () {
                                    story.multimedia!.sort((a, b) => (a['width'] ?? 9999).compareTo(b['width'] ?? 9999));
                                    return story.multimedia!.first;
                                  },
                                );
                                thumbnailUrl = thumb['url'] as String?;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
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
                                                    thumbnailUrl,
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
                                ),
                              );
                            },
                            childCount: stories.length,
                          ),
                        ),
                      );
                    }
                    return SliverFillRemaining(
                      child: Center(
                        child: Text('Welcome to NYTimes Top Stories App!', style: TextStyle(color: colorScheme.onBackground)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}