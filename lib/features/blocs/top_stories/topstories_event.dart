abstract class TopStoriesEvent {}

class FetchTopStories extends TopStoriesEvent {
  final String section;

  FetchTopStories(this.section);
}
