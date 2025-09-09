
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:nytimes_top_stories/data/models/top_story.dart';

class TopStoriesRepository {
  Future<List<TopStory>> fetchTopStories(String section) async {
    final _dio = Dio();
    final api = dotenv.env['NYT_API_KEY'];

    final response = await _dio.get(
      'https://api.nytimes.com/svc/topstories/v2/$section.json?api-key=$api',
    );

    if (response.statusCode == 200 && response.data['results'] != null) {
      Logger().i(response.data.toString());
      final List results = response.data['results'];
      return results.map((item) => TopStory.fromJson(item)).toList();
    }
    return [];
  }
}
