import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:photo_view/photo_view.dart';

class FullMediaView extends StatelessWidget {
  final String url;
  final String type;
  FullMediaView({this.url, this.type});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.topLeft,
            color: Colors.black,
            height: 50,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel,
                color: AppColors.bgColor.withOpacity(0.5),
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: type == 'video'
                ? AspectRatio(
                    aspectRatio: 1,
                    child: BetterPlayer.network(
                      url,
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                          autoPlay: true,
                          controlsConfiguration:
                              BetterPlayerControlsConfiguration(
                            showControls: false,
                            showControlsOnInitialize: false,
                          )),
                    ),
                  )
                : PhotoView(
                    imageProvider: NetworkImage(url),
                  ),
          ),
        ],
      ),
    );
  }
}
