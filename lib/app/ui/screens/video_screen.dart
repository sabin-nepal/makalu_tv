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
  int selectedIndex = 0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _fetchData();
      _scrollController
    ..addListener(() {
      var triggerFetchMoreSize =
          0.9 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels >
          triggerFetchMoreSize) {
        print("get more data");
      }
    });
  }

  void _fetchData() async {
    var _service = await VideoService.getVideo(0);
    url = _service.first.media['path'];
    _service.forEach((element) {
      video.add(element);
    });
    setState(() {});
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
    if (video.isEmpty)
      return Center(
        child: Text("No video to show"),
      );
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        controller: _scrollController,
        itemCount: video.length,
        itemBuilder: (context, i) {
          var _video = video[i];
          if (_video.type == 'banner') {
            return Container(
              child: CachedNetworkImage(imageUrl: _video.medium['path']),
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
                      width: 70,
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
