import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:tour_app_practice/data/tour.dart';
import 'package:tour_app_practice/data/listData.dart';
import 'package:sqflite/sqflite.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  MapPage({this.databaseReference, this.db, this.id});

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  List<DropdownMenuItem<Item>> list = List.empty(growable: true);
  List<DropdownMenuItem<Item>> sublist = List.empty(growable: true);
  List<TourData> tourData = List.empty(growable: true);
  ScrollController? _scrollController;

  String authKey = '';

  Item? area;
  Item? kind;
  int page = 1;

  @override
  void initState() {
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;

    area = list[0].value;
    kind = sublist[0].value;

    _scrollController = new ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        page++;
        getAreaList(area: area!.value, contentTypeId: kind!.value, page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void getAreaList(
      {required int area,
      required int contentTypeId,
      required int page}) async {
    var url = '';
    if (contentTypeId != 0) {
      url = url + '&contentTypeId=$contentTypeId';
    }
    var response = await http.get(Uri.parse(url));
    String body = utf8.decode(response.bodyBytes);
    print(body);
    var json = jsonDecode(body);
    if (json['response']['header']['resultCode'] == "0000") {
      if (json['response']['body']['items'] == '') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Last data'),
              );
            });
      } else {
        List jsonArray = json['response']['body']['items']['item'];
        for (var s in jsonArray) {
          setState(() {
            tourData.add(TourData.fromJson(s));
          });
        }
      }
    } else {
      print('error');
    }
  }
}
