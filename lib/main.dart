import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:nytimes_top_stories/core/app_theme.dart';
import 'package:nytimes_top_stories/data/repositories/top_stories_rep.dart';
import 'package:nytimes_top_stories/features/blocs/top_stories/tostories_bloc.dart';
import 'package:nytimes_top_stories/features/screens/home.dart';

final getIt = GetIt.instance;

void main() async {
  setUpDependencies();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

void setUpDependencies() {
  // Singletons
  getIt.registerSingleton<TopStoriesRepository>(TopStoriesRepository());

  // Factories
  getIt.registerFactory<TopStoriesBloc>(() => TopStoriesBloc(getIt<TopStoriesRepository>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopStoriesBloc>(
          create: (context) => getIt<TopStoriesBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Home(),
      ),
    );
  }
}
