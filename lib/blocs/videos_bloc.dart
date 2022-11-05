import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc implements BlocBase {

  Api? api;
  List<Video>? videos;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final StreamController<String?> _searchController = StreamController<String?>();
  Sink get inSearch => _searchController.sink;

  VideosBloc(){
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(dynamic search) async {
    if(api != null) {
      if (search != null) {
        _videosController.sink.add([]);
        videos = await api!.search(search);
      } else {
        videos!.addAll(await api!.nextPage());
      }
      _videosController.sink.add(videos!);
    }
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}

}