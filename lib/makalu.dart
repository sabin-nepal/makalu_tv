import 'package:flutter/material.dart';
import 'package:makalu_tv/app/notifiers/open_notifier.dart';
import 'package:makalu_tv/app/ui/general/home.dart';
import 'package:makalu_tv/app/ui/general/open_first.dart';
import 'package:provider/provider.dart';

import 'app/core/routes.dart';
import 'app/styles/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirstOpenNotifier>(
      create: (_) => FirstOpenNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Makalu Tv',
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
        theme: theme,
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _handleCurrentScreen();
  }

  Widget _handleCurrentScreen() {
    return Consumer<FirstOpenNotifier>(
        builder: (BuildContext context, FirstOpenNotifier notifier, _) {
      if (notifier.isOpened == null)
        return Center(child: CircularProgressIndicator());
      if (!notifier.isOpened)
        return FirstOpen(
          notifier: notifier,
        );
      return HomePage();
    });
  }
}
