import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main/favoritePage.dart';
import 'main/settingPage.dart';
import 'main/mapPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? controller;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = '';
  String? id;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as String?; // 로그인할 때 전달받은 id값
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          MapPage(), // 관광 정보 표시
          FavoritePage(), // 즐겨찾기 페이지
          SettingPage() // 설정 페이지
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.map),
          ),
          Tab(
            icon: Icon(Icons.star),
          ),
          Tab(
            icon: Icon(Icons.settings),
          )
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: controller,
      )
    );
  }
}