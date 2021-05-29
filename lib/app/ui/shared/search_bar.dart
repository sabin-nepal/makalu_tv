import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
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
      onPressed: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    // return StreamBuilder(
    //   stream: news,
    //   builder: (context, AsyncSnapshot<List<News>> snapshot) {
    //     if (!snapshot.hasData) {
    //       return Center(child: Text("No Data"));
    //     }
    //     final results = snapshot.data.where((e) => e.title.contains(query));
    //     return ListView(
    //         children: results.map((e) {
    //       return ListTile(
    //         title: Text(e.title,style: boldText,),
    //         );
    //     }).toList());
    //   },
    // );
  }
}
