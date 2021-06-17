import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/notifiers/news_notifier.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:provider/provider.dart';

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
  bool _isSet = false;
  int yesVote;
  int noVote;
  String yesPercent;
  String noPercent;
  @override
  void initState() {
    super.initState();
    _checkVote();
    yesVote = widget.yesCount ?? 0;
    noVote = widget.noCount ?? 0;
    _calculateVote();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isSet) {
      await context.read<NewsNotifier>().fetchPolls(widget.id);
    }
    if (mounted) setState(() => _isSet = true);
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
    int _yesVote = yesVote + positive;
    int _noVote = noVote + negative;
    int total = _yesVote + _noVote;
    if (total > 0) {
      _yesPercent = ((_yesVote / total) * 100).floor();
      _noPercent = ((_noVote / total) * 100).floor();
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
            style: titleText,
            maxLines: 2,
          ),
        ),
        Consumer<NewsNotifier>(builder: (context, notify, _) {
          if (notify.getPolls == null)
            return Center(child: CircularProgressIndicator());
          yesVote = notify.getPolls['yesCount'];
          noVote = notify.getPolls['noCount'];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () async {
                    if (voted) {
                      return null;
                    }
                    await NewsService().setVote(widget.id, 1);
                    await _userPreference.vote(widget.id);
                    _calculateVote(positive: 1);
                    voted = true;
                    setState(() {});
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.8,
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: Text(
                    voted ? yesPercent : "Yes",
                    style: smallBoldText,
                  ),
                ),
                Spacer(),
                OutlinedButton(
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
                    side: MaterialStateProperty.all(BorderSide(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.8,
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: Text(voted ? noPercent : "No", style: smallBoldText),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
