import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';
import 'package:nytimes_top_stories/data/repositories/top_stories_rep.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_sate.dart';

class TopStoriesBloc extends Bloc<TopStoriesEvent, TopStoriesState> {
  final TopStoriesRepository repository;
  List<TopStory> _allStories = [];

  TopStoriesBloc(this.repository) : super(TopStoriesInitial()) {
    on<FetchTopStories>((event, emit) async {
      emit(TopStoriesLoading());
      try {
        final stories = await repository.fetchTopStories(event.section);
        _allStories = stories;
        emit(TopStoriesLoaded(stories));
      } catch (e) {
        emit(TopStoriesError(e.toString()));
      }
    });
    on<SearchTopStories>((event, emit) async {
      if (state is TopStoriesLoaded) {
        if (event.query.trim().isEmpty) {
          emit(TopStoriesLoaded(_allStories));
        } else {
          final filteredStories = _allStories.where((story) {
            final title = story.title.toLowerCase();
            final byline = story.byline.toLowerCase();
            return title.contains(event.query.toLowerCase()) ||
                   byline.contains(event.query.toLowerCase());
          }).toList();
          emit(TopStoriesLoaded(filteredStories));
        }
      }
    });
  }
}
