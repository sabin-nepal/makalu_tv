import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/general/home.dart';
import 'package:makalu_tv/app/ui/general/settings.dart';
import 'package:makalu_tv/app/ui/screens/bookmark_screen.dart';
import 'package:makalu_tv/app/ui/screens/details/full_image_view.dart';
import 'package:makalu_tv/app/ui/screens/details/news_details.dart';
import 'package:makalu_tv/app/ui/screens/insight_screen.dart';
import 'package:makalu_tv/app/ui/screens/news_screen.dart';
import 'package:makalu_tv/app/ui/screens/poll_screen.dart';

class AppRoutes {
  static const String mainScreen = 'main_screen';
  static const String newsDetails = 'news_details';
  static const String fullImage = 'full_image';
  static const String newsScreen = 'news_screen';
  static const String pollScreen = 'poll_screen';
  static const String insightScreen = 'insight_screen';
  static const String settingScreen = 'setting_screen';
  static const String bookMarkScreen = 'bookmark_screen';

  static final Map<String, Widget Function(BuildContext)> routes = {
    mainScreen: (_) => HomePage(),
    settingScreen: (_) => Settings(), 
    bookMarkScreen: (_) => BookMakrkScreen(),
  };

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case newsDetails:
        Map _data = settings.arguments as Map;
        News _news = _data['news'];
        return MaterialPageRoute(
            builder: (_) => NewsDetails(
                  news: _news,
                ));
      case fullImage:
        Map _data = settings.arguments as Map;
        String _imageUrl = _data['imageUrl'];
        return MaterialPageRoute(
            builder: (_) => FullImageView(
                  imageUrl: _imageUrl,
                ));
      case newsScreen:
        Map _data = settings.arguments as Map;
        String _title = _data['title'];
        List _news = _data['news'];
        String _type = _data['type'];
        return MaterialPageRoute(
            builder: (_) => NewsScreen(
                  title: _title,
                  news: _news,
                  type: _type,
                ));
      case pollScreen:
        Map _data = settings.arguments as Map;
        int _position = _data['position'];
        return MaterialPageRoute(
            builder: (_) => PollScreen(
                  position: _position,
                ));
      case insightScreen:
        Map _data = settings.arguments as Map;
        int _position = _data['position'];
        return MaterialPageRoute(
            builder: (_) => InsightScreen(
                  position: _position,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(
          child: Text("Eroor"),
        ),
      );
    });
  }
}
