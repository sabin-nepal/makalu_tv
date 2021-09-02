import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/general/home.dart';
import 'package:makalu_tv/app/ui/general/settings.dart';
import 'package:makalu_tv/app/ui/screens/bookmark_screen.dart';
import 'package:makalu_tv/app/ui/screens/category_filter.dart';
import 'package:makalu_tv/app/ui/screens/category_screen.dart';
import 'package:makalu_tv/app/ui/screens/details/cataegory_news_details.dart';
import 'package:makalu_tv/app/ui/screens/details/full_image_view.dart';
import 'package:makalu_tv/app/ui/screens/details/news_details.dart';
import 'package:makalu_tv/app/ui/screens/insight_screen.dart';
import 'package:makalu_tv/app/ui/screens/news_screen.dart';
import 'package:makalu_tv/app/ui/screens/poll_screen.dart';

class AppRoutes {
  static const String mainScreen = 'main_screen';
  static const String newsDetails = 'news_details';
  static const String categoryDetails = 'category_details';
  static const String fullImage = 'full_image';
  static const String categoryScreen = 'category_screen';
  static const String pollScreen = 'poll_screen';
  static const String newsScreen = 'news_screen';
  static const String insightScreen = 'insight_screen';
  static const String settingScreen = 'setting_screen';
  static const String bookMarkScreen = 'bookmark_screen';
  static const String filterScreen = 'filter_screen';

  static final Map<String, Widget Function(BuildContext)> routes = {
    mainScreen: (_) => HomePage(),
    settingScreen: (_) => Settings(),
    bookMarkScreen: (_) => BookMakrkScreen(),
    filterScreen: (_) => CategoryFilter(),
  };

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case newsDetails:
        Map _data = settings.arguments as Map;
        News _news = _data['news'];
        return CupertinoPageRoute(
            builder: (_) => NewsDetails(
                  news: _news,
                ));
      case fullImage:
        Map _data = settings.arguments as Map;
        String _imageUrl = _data['imageUrl'];
        String _type = _data['type'] ?? 'image';
        return MaterialPageRoute(
            builder: (_) => FullImageView(
                  imageUrl: _imageUrl,
                  type: _type,
                ));
      case categoryScreen:
        Map _data = settings.arguments as Map;
        String _title = _data['title'];
        String _catid = _data['catid'];
        int _position = _data['position'] ?? 0;
        return MaterialPageRoute(
            builder: (_) => CategoryScreen(
                  title: _title,
                  catid: _catid,
                  position: _position,
                ));
      case pollScreen:
        Map _data = settings.arguments as Map;
        int _position = _data['position'];
        return MaterialPageRoute(
            builder: (_) => PollScreen(
                  position: _position,
                ));
      case newsScreen:
        Map _data = settings.arguments as Map;
        String _title = _data['title'];
        String _type = _data['type'];
        return MaterialPageRoute(
            builder: (_) => NewsScreen(
                  title: _title,
                  type: _type,
                ));
      case insightScreen:
        Map _data = settings.arguments as Map;
        int _position = _data['position'];
        return MaterialPageRoute(
            builder: (_) => InsightScreen(
                  position: _position,
                ));
      case categoryDetails:
        Map _data = settings.arguments as Map;
        Map _news = _data['news'];
        String _catid = _data['catid'];
        return MaterialPageRoute(
            builder: (_) => CategoryNewsDetails(
                  news: _news,
                  id: _catid,
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
