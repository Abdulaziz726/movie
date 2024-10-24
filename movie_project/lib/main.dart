import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/movie_provider.dart';
import './screens/movie_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'Movie Booking App',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: MovieListScreen(),
      ),
    );
  }
}
