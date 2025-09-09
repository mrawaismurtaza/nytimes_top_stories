import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_sate.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<TopStoriesBloc>().add(FetchTopStories('home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NYTimes Top Stories'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<TopStoriesBloc, TopStoriesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TopStoriesLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (state is TopStoriesError) {
            return Center(child: Text('Error: \\${state.message}', style: const TextStyle(color: Colors.black)));
          } else if (state is TopStoriesLoaded) {
            final stories = state.stories as List<TopStory>;
            if (stories.isEmpty) {
              return const Center(child: Text('No stories found.', style: TextStyle(color: Colors.black)));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: stories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final story = stories[index];
                String? thumbnailUrl;
                if (story.multimedia != null && story.multimedia!.isNotEmpty) {
                  // Try to find the smallest image (e.g., format 'Standard Thumbnail' or smallest width)
                  final thumb = story.multimedia!.firstWhere(
                    (m) => m['format'] == 'Standard Thumbnail',
                    orElse: () {
                      // If not found, pick the image with the smallest width
                      story.multimedia!.sort((a, b) => (a['width'] ?? 9999).compareTo(b['width'] ?? 9999));
                      return story.multimedia!.first;
                    },
                  );
                  thumbnailUrl = thumb['url'] as String?;
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: thumbnailUrl != null
                              ? Image.network(
                                  thumbnailUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.black12,
                                  child: const Icon(Icons.image, color: Colors.black38, size: 32),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                story.byline,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Welcome to NYTimes Top Stories App!', style: TextStyle(color: Colors.black)));
        },
      ),
    );
  }
}