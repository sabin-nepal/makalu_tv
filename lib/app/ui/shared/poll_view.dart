import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class PollView extends StatefulWidget {
  final String id;
  final String title;
  final int yesCount;
  final int noCount;
  PollView({this.id, this.title, this.noCount, this.yesCount});

  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
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
    final _checkVote = await _userPreference.checkIfVote(widget.id);
    if (_checkVote) {
      voted = true;
      setState(() {});
    }
  }

  _calculateVote({int positive = 0, int negative = 0}) {
    var _yesPercent = 0;
    var _noPercent = 0;
    int yesVote = widget.yesCount + positive;
    int noVote = widget.noCount + negative;
    int total = yesVote + noVote;
    if (total > 0) {
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
            widget.title,
            style: boldText,
            maxLines: 2,
          ),
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: OutlinedButton(
                onPressed: () async {
                  if (voted) {
                    return null;
                  }
                  await NewsService().setVote(widget.id, 1);
                  await _userPreference.vote(widget.id);
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
              width: MediaQuery.of(context).size.width / 2,
              child: OutlinedButton(
                onPressed: () async {
                  if (voted) {
                    return null;
                  }
                  await NewsService().setVote(widget.id, 0);
                  await _userPreference.vote(widget.id);
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