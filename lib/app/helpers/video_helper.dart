import 'dart:async';

import 'package:makalu_tv/app/models/news/video.dart';
import 'package:makalu_tv/app/services/news/video_service.dart';


class VideoHelper {
  final StreamController<int> _videoCount = StreamController<int>();
  Stream<int> get videoCount => _videoCount.stream;

  Stream<List<Video>> get videoListView async* {
    yield await VideoService.getVideo();
  }

  VideoHelper() {
    videoListView.listen((event) => _videoCount.add(event.length));
  }
}
