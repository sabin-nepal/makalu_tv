import 'dart:async';

import 'package:makalu_tv/app/models/news/insight.dart';
import 'package:makalu_tv/app/services/news/insight_service.dart';

class InsightHelper {
  final StreamController<int> _insightCount = StreamController<int>();
  Stream<int> get insightCount => _insightCount.stream;

  Stream<List<Insight>> get insightListView async* {
    yield await InsightService.getInsight();
  }

  InsightHelper() {
    insightListView.listen((event) => _insightCount.add(event.length));
  }
}
