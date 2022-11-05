import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';
import 'package:url_launcher/url_launcher.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final bloc = BlocProvider.getBloc<FavoriteBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        initialData: const {},
        stream: bloc.outFav,
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data != null && snapshot.data!.isNotEmpty ?
            snapshot.data!.values.map((v) {
              return InkWell(
                onTap: () async {
                  await launchUrl(Uri.parse('https://www.youtube.com/watch?v='+v.id!));
                },
                onLongPress: () {
                  bloc.toggleFavorite(v);
                },
                child: Row(children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.network(v.thumb!),
                  ),
                  Expanded(
                    child: Text(
                      v.title!,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 2,
                    ),
                  ),
                ]),
              );
            }).toList() : [],
          );
        },
      ),
    );
  }
}
