import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/data/repositories/top_stories_rep.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_sate.dart';

class TopStoriesBloc extends Bloc<TopStoriesEvent, TopStoriesState> {
  final TopStoriesRepository repository;

  TopStoriesBloc(this.repository) : super(TopStoriesInitial()) {
    on<FetchTopStories>((event, emit) async {
      emit(TopStoriesLoading());
      try {
        final stories = await repository.fetchTopStories(event.section);
        emit(TopStoriesLoaded(stories));
      } catch (e) {
        emit(TopStoriesError(e.toString()));
      }
    });
  }
}
