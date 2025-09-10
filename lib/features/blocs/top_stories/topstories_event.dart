abstract class TopStoriesEvent {}

class FetchTopStories extends TopStoriesEvent {
  final String section;

  FetchTopStories(this.section);
}

class SearchTopStories extends TopStoriesEvent {
  final String query;

  SearchTopStories(this.query);
}

class ToggleLayoutEvent extends TopStoriesEvent {}

class RefreshTopStories extends TopStoriesEvent {
  final String section;

  RefreshTopStories(this.section);
}
