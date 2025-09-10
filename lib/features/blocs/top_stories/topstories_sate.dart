abstract class TopStoriesState {}

class TopStoriesInitial extends TopStoriesState {}

class TopStoriesLoading extends TopStoriesState {}

class TopStoriesLoaded extends TopStoriesState {
  final List stories;
  final bool isGridLayout;

  TopStoriesLoaded(this.stories, {this.isGridLayout = false});
}

class TopStoriesError extends TopStoriesState {
  final String message;

  TopStoriesError(this.message);
}