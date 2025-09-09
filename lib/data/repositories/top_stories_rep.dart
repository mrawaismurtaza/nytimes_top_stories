import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TopStoriesRepository {
  Future<List> fetchTopStories(String section) async {
    final _dio = Dio();
    final api = dotenv.env['NYT_API_KEY'];

    final response = await _dio.get(
      'https://api.nytimes.com/svc/topstories/v2/$section.json?api-key=$api',
    );

    
    if (response.statusCode == 200) {
      debugPrint(response.data.toString());
    }
    return [];
  }
}
