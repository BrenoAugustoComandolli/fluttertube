import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      dependencies: const [],
      blocs: [
        Bloc((i) => VideosBloc()),
        Bloc((i) => FavoriteBloc()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlutterTube',
        home: Home(),
      ),
    );
  }
}