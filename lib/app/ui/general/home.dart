import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/adv_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/screens/home_tab.dart';
import 'package:makalu_tv/app/ui/screens/news_tab.dart';
import 'package:makalu_tv/app/ui/screens/video_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _tabPages = [];
  int _selectedIndex = 1;
  List _adv = [];
  @override
  void initState() {
    super.initState();
    _fetchAdv();
    _tabPages = [
      HomeTab(),
      NewsTab(adv: _adv),
      VideoScreen(adv: _adv),
    ];
  }

  _fetchAdv() async {
    var adv = await AdvService.getAdv();
    adv.forEach((element) {
      _adv.add(element);
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(context),
        body: IndexedStack(
          children: _tabPages,
          index: _selectedIndex,
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white,
        selectedItemColor: AppColors.iconColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection), label: 'Video'),
        ],
      ),
    );
  }
}
