import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/notifiers/search_notifier.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:provider/provider.dart';

class CustomSearch extends SearchDelegate<String> {
  List<String> _oldFilters = const [];
  var _userPreference = UserSharePreferences();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') return buildSuggestions(context);
    return FutureBuilder(
        future: NewsService.getSearchResult(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data.length < 1)
              return Center(
                  child: Text(
                "Search Not Found..",
                style: boldText,
              ));
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  News news = snapshot.data[index];
                  return ListTile(
                    leading: Container(
                      width: 100,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: news.media.first['path'],
                      ),
                    ),
                    title: Text(
                      news.title,
                      style: titleText,
                    ),
                    onTap: () async {
                      await _userPreference.saveToRecentSearches(query);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.newsDetails,
                        arguments: {'news': news},
                      );
                    },
                  );
                });
          }
          return Center(
            child: Text(
              "No Data",
              style: boldText,
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(builder: (context, SearchNotifier notifier, _) {
      notifier.fetchSuggestions(query);
      _oldFilters = notifier.suggestions ?? [];
      return ListView.builder(
        itemCount: _oldFilters.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.restore),
            title: Text(
              "${_oldFilters[index]}",
              style: titleText,
            ),
            onTap: () => query = _oldFilters[index],
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _userPreference.deleteRecentSearches(_oldFilters[index]);
              },
            ),
          );
        },
      );
    });
  }
}
