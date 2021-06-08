import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class PollCardView extends StatefulWidget {
  final News news;
  PollCardView({this.news});

  @override
  _PollCardViewState createState() => _PollCardViewState();
}

class _PollCardViewState extends State<PollCardView> {
  var _userPreference = UserSharePreferences();
  bool voted = false;
  String yesPercent;
  String noPercent;
  @override
  void initState() {
    super.initState();
    _checkVote();
    _calculateVote();
  }

  _checkVote() async {
    final _checkVote = await _userPreference.checkIfVote(widget.news.id);
    if (_checkVote) {
      voted = true;
      setState(() {});
    }
  }

  _calculateVote({int value = 0}) {
    var _yesPercent;
    var _noPercent;
    int yesVote = widget.news.pollResult['yesCount'] + value;
    int noVote = widget.news.pollResult['noCount'] + value;
    int total = yesVote + noVote;
    if (widget.news.pollResult.isNotEmpty) {
      _yesPercent = ((yesVote / total) * 100).floor();
      _noPercent = ((noVote / total) * 100).floor();
    }
    yesPercent = '${_yesPercent.toStringAsFixed(2)}%';
    noPercent = '${_noPercent.toStringAsFixed(2)}%';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSizes.padding),
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Card(
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: widget.news.media.first['path'],
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          child: AutoSizeText(
            widget.news.title,
            style: boldText,
            maxLines: 2,
          ),
        ),
        Row(
          children: [
            Container(
              width: 100,
              child: OutlinedButton(
                onPressed: () async {
                  if (voted) {
                    return null;
                  }
                  await NewsService().setVote(widget.news.id, 1);
                  await _userPreference.vote(widget.news.id);
                  voted = true;
                  _calculateVote(value: 1);
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                ),
                child: Text(voted ? yesPercent : "Yes"),
              ),
            ),
            Container(
              width: 100,
              child: OutlinedButton(
                onPressed: () async {
                  if (voted) {
                    return null;
                  }
                  await NewsService().setVote(widget.news.id, 1);
                  await _userPreference.vote(widget.news.id);
                  voted = true;
                  _calculateVote(value: 1);
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                ),
                child: Text(voted ? noPercent : "No"),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
