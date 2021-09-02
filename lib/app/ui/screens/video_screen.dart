import 'dart:async';
import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/models/advertisment.dart';
import 'package:makalu_tv/app/services/adv_service.dart';
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
  BetterPlayerController _betterPlayerController;
  List video = [];
  int selectedIndex = 0;
  bool isLoading = false;
  bool _showAdv = true;
  int currentPage = 1;
  bool noData = false;
  Advertisement advertisement;
  List _adv;

  Random random = Random();
  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9, fit: BoxFit.contain, handleLifecycle: true);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    super.initState();
    _adv = widget.adv;
    _fetchData();
    _setAdv();
  }

  _setUrl(var _url, fullAdv, {bool play = true}) async {
    BetterPlayerDataSource dataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, _url,
            cacheConfiguration: BetterPlayerCacheConfiguration(
              useCache: true,
              preCacheSize: 10 * 1024 * 1024,
              maxCacheSize: 10 * 1024 * 1024,
              maxCacheFileSize: 10 * 1024 * 1024,
            ));
    _betterPlayerController.setupDataSource(dataSource);
    if (play) _betterPlayerController.play();
    _showAdv = true;
    advertisement = fullAdv;
    setState(() {});
  }

  _setAdv() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      if (_betterPlayerController.isPlaying()) {
        int rand = random.nextInt(_adv.length);
        _showAdv = true;
        advertisement = _adv[rand];
        setState(() {});
      }
    });
  }

  void _fetchData() async {
    var _service = await VideoService.getVideo(0);
    var firstAdv = _adv.isEmpty ? null : _adv.first;
    _setUrl(_service.first.media['path'], firstAdv, play: false);
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
          Stack(
            children: [
              if (video.isNotEmpty)
                Container(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(
                      controller: _betterPlayerController,
                    ),
                  ),
                ),
              if (_showAdv && advertisement != null) _displayAdv(),
            ],
          ),
          Expanded(
            child: listVideo(context),
          )
        ],
      ),
    );
  }

  Widget _displayAdv() {
    var position = advertisement.position;
    double top;
    double bottom;
    double left;
    double right;
    if (position == 'tleft') {
      top = 0.0;
      left = 0.0;
    } else if (position == 'tright') {
      top = 0.0;
      right = 0.0;
    } else if (position == 'bleft') {
      bottom = 0.0;
      left = 0.0;
    } else if (position == 'bright') {
      bottom = 0.0;
      right = 0.0;
    } else {
      top = 0;
      right = 0.0;
      left = 100.0;
      bottom = 0.0;
    }
    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      child: Container(
        child: Row(
          children: [
            if (position == 'bright' ||
                position == 'tright' ||
                position == 'centre')
              IconButton(
                  onPressed: () {
                    setState(() {
                      _showAdv = false;
                    });
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: AppColors.accentColor,
                  )),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.fullMedia,
                  arguments: {
                    'url': advertisement.media['path'],
                    'type': advertisement.type
                  },
                );
              },
              child: advertisement.type == 'video'
                  ? Container(
                      height: 100,
                      width: 100,
                      child: Flexible(
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: BetterPlayer.network(
                            advertisement?.media['path'],
                            betterPlayerConfiguration:
                                BetterPlayerConfiguration(
                                    autoPlay: true,
                                    controlsConfiguration:
                                        BetterPlayerControlsConfiguration(
                                      showControls: false,
                                      showControlsOnInitialize: false,
                                    )),
                          ),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      height: 100,
                      width: 100,
                      imageUrl: advertisement?.media['path'],
                    ),
            ),
            if (position == 'bleft' || position == 'tleft')
              IconButton(
                  onPressed: () {
                    setState(() {
                      _showAdv = false;
                    });
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: AppColors.accentColor,
                  )),
          ],
        ),
      ),
    );
  }

  Widget listVideo(context) {
    if (video.isEmpty)
      return Center(
        child: Text(
          "No video to show",
          style: boldText,
        ),
      );
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: video.length + 1,
        itemBuilder: (context, i) {
          if (i == video.length) {
            return Container(
              height: 50,
              child: Center(
                  child: noData
                      ? Text(
                          "No More Video",
                          style: titleText,
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(Duration(seconds: 3), () {
                              VideoService.getVideo(currentPage).then((value) {
                                currentPage++;
                                if (value.isEmpty) {
                                  noData = true;
                                }
                                value.forEach((element) {
                                  video.add(element);
                                });
                                AdvService.getAdv(
                                        type: "full", page: currentPage - 1)
                                    .then((fetchadv) {
                                  fetchadv.forEach((getadv) {
                                    _adv.add(getadv);
                                  });
                                });
                                isLoading = false;
                                setState(() {});
                              });
                            });
                          },
                          child: Text(
                            isLoading ? "Loading.." : "Load More",
                            style: boldText,
                          ),
                        )),
            );
          }
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
                int rand = _adv.isEmpty ? 0 : random.nextInt(_adv.length);
                var index = _adv.length <= i ? rand : i;
                _setUrl(
                    _video.media['path'], _adv.isEmpty ? null : _adv[index]);
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
