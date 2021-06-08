import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
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

  _calculateVote({int positive = 0,int negative=0}) {
    var _yesPercent = 0;
    var _noPercent = 0;
    int yesVote = widget.news.pollResult['yesCount'] + positive;
    int noVote = widget.news.pollResult['noCount'] + negative;
    int total = yesVote + noVote;
    if (total > 0 ) {
      _yesPercent = ((yesVote / total) * 100).floor();
      _noPercent = ((noVote / total) * 100).floor();
    }
    yesPercent = '${_yesPercent.toStringAsFixed(2)}%';
    noPercent = '${_noPercent.toStringAsFixed(2)}%';
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              width: MediaQuery.of(context).size.width/2,
              child: OutlinedButton(
                onPressed: () async {
                  if (voted) {
                    return null;
                  }
                  await NewsService().setVote(widget.news.id, 1);
                  await _userPreference.vote(widget.news.id);
                  voted = true;
                  _calculateVote(positive: 1);
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
              width: MediaQuery.of(context).size.width/2,
              child: OutlinedButton(
                onPressed: () async {
                  if (voted) {
                    return null;
                  }
                  await NewsService().setVote(widget.news.id, 1);
                  await _userPreference.vote(widget.news.id);
                  voted = true;
                  _calculateVote(negative: 1);
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
      ],
      
    );
  }
}