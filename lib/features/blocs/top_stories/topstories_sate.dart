abstract class TopStoriesState {}

class TopStoriesInitial extends TopStoriesState {}

class TopStoriesLoading extends TopStoriesState {}

class TopStoriesLoaded extends TopStoriesState {
  final List stories;

  TopStoriesLoaded(this.stories);
}

class TopStoriesError extends TopStoriesState {
  final String message;

  TopStoriesError(this.message);
}