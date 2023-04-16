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
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(itemBuilder: (context, index) {
                      List<TourData> tourList = snapshot.data as List<TourData>;
                      TourData info = tourList[index];
                      return Card(
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Hero(
                                tag: 'tourinfo$index',
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black, width: 1
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: getImage(info.imagePath!)
                                    )
                                  )
                                )
                              )
                            ]
                          )
                        )
                      );
                    });
                  } else {
                    return Text('No data');
                  }
              }
              return CircularProgressIndicator();
            },
            future: _tourList,
          ),
        ),
      ),
    );
  }

  ImageProvider getImage(String imagePath) {
    if (imagePath != 'null') {
      return NetworkImage(imagePath);
    } else {
      return AssetImage('repo/images/map_location.png');
    }
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
