import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/screens/home_screen.dart';
import 'package:makalu_tv/app/ui/screens/news_screen.dart';
import 'package:makalu_tv/app/ui/screens/video_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _tabPages = [];
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _tabPages = [
      HomeTab(),
      NewsScreen(),
      VideoScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        bottomNavigationBar: _bottomNavigationBar(context),
        body: IndexedStack(
          children: _tabPages,
          index: _selectedIndex,
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _buildAppBar(BuildContext context) {
    String _title;
    if (_selectedIndex == 0) {
      _title = 'Discover';
    }
    if (_selectedIndex == 1) {
      _title = 'News';
    }
    if (_selectedIndex == 2) {
      _title = 'Video';
    }
    return AppBar(
      flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
      centerTitle: true,
      title: Text(
        _title,
      ),
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
