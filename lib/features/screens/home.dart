import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/topstories_event.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TopStoriesBloc>().add(FetchTopStories('home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NYTimes Top Stories'),
      ),
      body: const Center(
        child: Text('Welcome to NYTimes Top Stories App!'),
      ),
    );
  }
}