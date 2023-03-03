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
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}