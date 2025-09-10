import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_sate.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';
import 'package:nytimes_top_stories/features/shared_widgets/search_filter_bar.dart';
import 'package:nytimes_top_stories/features/shared_widgets/master_detail_layout.dart';
import 'package:nytimes_top_stories/features/shared_widgets/story_list_layouts.dart';
import 'package:nytimes_top_stories/features/shared_widgets/state_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedSection = 'home';
  final List<String> sections = ['home', 'world', 'politics', 'business', 'technology', 'science', 'health', 'sports', 'entertainment'];
  late final TextEditingController _searchController;
  TopStory? selectedStory;
  String? selectedThumbnailUrl;

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

  void _onSectionChanged(String section) {
    setState(() {
      selectedSection = section;
      selectedStory = null;
      selectedThumbnailUrl = null;
      _searchController.clear();
    });
    context.read<TopStoriesBloc>().add(FetchTopStories(selectedSection));
  }

  void _onStorySelected(TopStory story, String? thumbnailUrl) {
    setState(() {
      selectedStory = story;
      selectedThumbnailUrl = thumbnailUrl;
    });
  }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        toolbarHeight: isWideScreen ? 48.0 : kToolbarHeight,
        title: Text(
          'Top Stories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isWideScreen ? 18 : 24,
            color: colorScheme.onPrimary,
          ),
        ),
        elevation: 0,
        actions: [
          BlocBuilder<TopStoriesBloc, TopStoriesState>(
            builder: (context, state) {
              // Only show layout toggle on small screens (mobile)
              if (state is TopStoriesLoaded && !isWideScreen) {
                return IconButton(
                  icon: Icon(
                    state.isGridLayout ? Icons.view_list : Icons.grid_view,
                    color: colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    context.read<TopStoriesBloc>().add(ToggleLayoutEvent());
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchAndFilterBar(
            searchController: _searchController,
            sections: sections,
            selectedSection: selectedSection,
            onSectionChanged: _onSectionChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocConsumer<TopStoriesBloc, TopStoriesState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is TopStoriesLoading) {
                  return const LoadingStateWidget();
                } else if (state is TopStoriesError) {
                  return ErrorStateWidget(
                    message: state.message,
                    selectedSection: selectedSection,
                  );
                } else if (state is TopStoriesLoaded) {
                  final stories = state.stories as List<TopStory>;
                  if (stories.isEmpty) {
                    return EmptyStateWidget(selectedSection: selectedSection);
                  }
                  
                  if (isWideScreen) {
                    // Auto-select first story if none selected
                    if (selectedStory == null && stories.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          selectedStory = stories.first;
                          selectedThumbnailUrl = _getThumbnailUrl(stories.first);
                        });
                      });
                    }
                    return MasterDetailLayout(
                      stories: stories,
                      selectedStory: selectedStory,
                      selectedThumbnailUrl: selectedThumbnailUrl,
                      selectedSection: selectedSection,
                      onStorySelected: _onStorySelected,
                    );
                  }
                  
                  return StoryListLayouts(
                    stories: stories,
                    isGridLayout: state.isGridLayout,
                    selectedSection: selectedSection,
                  );
                }
                return WelcomeStateWidget(selectedSection: selectedSection);
              },
            ),
          ),
        ],
      ),
    );
  }
}