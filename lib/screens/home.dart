import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widgets/videotile.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset("images/youtube.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                initialData: const {},
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('${snapshot.data!.length}');
                  } else {
                    return Container();
                  }
                }),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Favorites(),
                ),
              );
            },
            icon: const Icon(Icons.star),
          ),
          IconButton(
            onPressed: () async {
              String? result = await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<List<Video>>(
        stream: BlocProvider.getBloc<VideosBloc>().outVideos as Stream<List<Video>>,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data!.length) {
                    return VideoTile(snapshot.data![index]);
                  } else if (index > 1) {
                    BlocProvider.getBloc<VideosBloc>().inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: snapshot.data!.length + 1);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
