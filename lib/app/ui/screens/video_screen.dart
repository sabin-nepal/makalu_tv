import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/video_helper.dart';
import 'package:makalu_tv/app/models/news/video.dart';
import 'package:makalu_tv/app/services/news/video_service.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final _videoHelper = VideoHelper();
  String url;
  List video = [];
  int selectedIndex;
  @override
  void initState() {
    super.initState();
    _fetchData();
    selectedIndex = 0;
  }

  void _fetchData() async {
    final _service = await VideoService.getVideo();
    _service.forEach((element) {
      video.add(element);
      url = element.media['path'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer.network(
              url,
              betterPlayerConfiguration: BetterPlayerConfiguration(
                aspectRatio: 16 / 9,
              ),
            ),
          ),
        ),
        Expanded(
          child: listVideo(context),
        )
      ],
    );
  }

  Widget listVideo(context) {
    return ListView.separated(
      itemCount: video.length,
      itemBuilder: (context, i) {
        Video _video = video[i];
        return Ink(
          color: selectedIndex == i ? Colors.grey : null,
          child: ListTile(
            onTap: () {
              url = _video.media['path'];
              setState(() {
                selectedIndex = i;
              });
            },
            leading: _video.thumbnail != null
                ? CachedNetworkImage(
                    imageUrl: _video.thumbnail['path'],
                  )
                : null,
            title: Text(_video.title,style: labelText,),
            subtitle: Text(_video.category.first['title'],style: subTitleText,),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }
}
