import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/general/home.dart';
import 'package:makalu_tv/app/ui/screens/details/news_details.dart';

class AppRoutes {
  static const String mainScreen = 'main_screen';
  static const String newsDetails = 'news_details';

  static final Map<String, Widget Function(BuildContext)> routes = {
    mainScreen: (_) => HomePage(),
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
