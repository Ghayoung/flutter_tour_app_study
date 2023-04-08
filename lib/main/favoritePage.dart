import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tour_app_practice/data/tour.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritePage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  FavoritePage({this.databaseReference, this.db, this.id});

  @override
  State<StatefulWidget> createState() {
    return _FavoritePage();
  }
}

class _FavoritePage extends State<FavoritePage> {
  Future<List<TourData>>? _tourList;

  @override
  void initState() {
    super.initState();
    _tourList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<List<TourData>> getTodos() async {
    final Database database = await widget.db!;
    final List<Map<String, dynamic>> maps = await database.query('place');

    return List.generate(maps.length, (i) {
      return TourData(
          title: maps[i]['title'].toString(),
          tel: maps[i]['tel'].toString(),
          address: maps[i]['address'].toString(),
          zipcode: maps[i]['zipcode'].toString(),
          mapy: maps[i]['mapy'].toString(),
          mapx: maps[i]['mapx'].toString(),
          imagePath: maps[i]['imagePath'].toString());
    });
  }
}
