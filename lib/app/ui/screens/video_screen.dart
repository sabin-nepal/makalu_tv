import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/video.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List _video = [];
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _video.add(Video(id: "qwe1233",title: "First Video",category: [{
      'title': 'Category'
    }],media: [{
      'path': 'https://www.youtube.com/watch?v=zWh3CShX_do'
    }]));
    _video.add(Video(id: "qwe1234",title: "Second Video",category: [{
      'title': 'Category'
    }],media: [{
      'path': 'https://www.youtube.com/watch?v=70GPkTYVwkw'
    }]));
    _video.add(Video(id: "qwe1233",title: "Third Video",category: [{
      'title': 'Category'
    }],media: [{
      'path': 'https://www.youtube.com/watch?v=zWh3CShX_do'
    }]));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Container()
        ),
      Expanded(child: ListView.separated(
          itemCount: _video.length,
          itemBuilder: (context,i){
            Video video = _video[i]; 
            return ListTile(
              title: Text(video.title),
              subtitle: Text(video.category.first['title']),
            );
          },
          separatorBuilder: (context,index) => Divider(),
      ))  
      ],
    );
  }
}