import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String selectedSection;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.selectedSection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TopStoriesBloc>().add(RefreshTopStories(selectedSection));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: colorScheme.onBackground.withOpacity(0.6)),
                const SizedBox(height: 16),
                Text(
                  'Error: $message',
                  style: TextStyle(color: colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TopStoriesBloc>().add(RefreshTopStories(selectedSection));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String selectedSection;

  const EmptyStateWidget({
    super.key,
    required this.selectedSection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TopStoriesBloc>().add(RefreshTopStories(selectedSection));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
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
        ),
      ),
    );
  }
}

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: CircularProgressIndicator(color: colorScheme.primary),
    );
  }
}

class WelcomeStateWidget extends StatelessWidget {
  final String selectedSection;

  const WelcomeStateWidget({
    super.key,
    required this.selectedSection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TopStoriesBloc>().add(RefreshTopStories(selectedSection));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Text(
              'Welcome to NYTimes Top Stories App!',
              style: TextStyle(color: colorScheme.onBackground),
            ),
          ),
        ),
      ),
    );
  }
}