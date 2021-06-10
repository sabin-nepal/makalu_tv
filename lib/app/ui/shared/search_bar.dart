import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class CustomSearch extends SearchDelegate<String> {
  List<String> _oldFilters = const [];
  var _userPreference = UserSharePreferences();
  OnSearchChanged onSearchChanged;
  CustomSearch({String searchFieldLabel, this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);
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
              return Center(child: Text("Search Not Found.."));
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
                    title: Text(news.title),
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
          print(snapshot.data);
          return Center(
            child: Text("No Data"),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data;
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text("${_oldFilters[index]}"),
              onTap: () => query = _oldFilters[index],
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _userPreference
                      .deleteRecentSearches(_oldFilters[index]);
                  query = _oldFilters[index];
                },
              ),
            );
          },
        );
      },
    );
  }
}
