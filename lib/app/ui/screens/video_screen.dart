import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/news/video_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class VideoScreen extends StatefulWidget {
  final List adv;
  VideoScreen({this.adv});
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String url;
  List video = [];
  int selectedIndex;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final _service = await VideoService.getVideo();
    _service.forEach((element) {
      video.add(element);
      url = element.media['path'];
      setState(() {});
    });
  }

  _mergeList() {
    var j = 0;
    if (widget.adv.isNotEmpty)
      for (var i = 0; i < video.length; i++) {
        if (i % 2 == 1 && widget.adv.length > j) {
          video.insert(i, widget.adv[j]);
          j++;
        }
      }
    return video;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          'Video',
        ),
      ),
      body: Column(
        children: [
          if (video.isNotEmpty)
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
      ),
    );
  }

  Widget listVideo(context) {
    List videoList = _mergeList();
    if (videoList.isEmpty)
      return Center(
        child: Text("No video to show"),
      );
    return ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, i) {
          var _video = videoList[i];
          print(_video.type);
          if (i.isOdd && _video.type == 'banner') {
            return Container(
              child: CachedNetworkImage(imageUrl: _video.media['path']),
            );
          }
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
              title: Text(
                _video.title,
                style: labelText,
              ),
              subtitle: Text(
                _video.category.first['title'],
                style: subTitleText,
              ),
            ),
          );
        });
  }
}
