import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/video.dart';

class VideoTile extends StatelessWidget {
  const VideoTile(this.video, {Key? key}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launchUrl(Uri.parse('https://www.youtube.com/watch?v='+video.id!));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                video.thumb!,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text(
                          video.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          video.channel!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return IconButton(
                        onPressed: () {
                          BlocProvider.getBloc<FavoriteBloc>().toggleFavorite(video);
                        },
                        icon: Icon(snapshot.data!.containsKey(video.id) ? Icons.star : Icons.star_border),
                        color: Colors.white,
                        iconSize: 30,
                      );
                    }else{
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
