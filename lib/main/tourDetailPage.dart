import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import 'package:tour_app_practice/data/tour.dart';
import 'package:tour_app_practice/data/disableInfo.dart';
import 'package:tour_app_practice/data/reviews.dart';

class TourDetailPage extends StatefulWidget {
  final TourData? tourData;
  final int? index;
  final DatabaseReference? databaseReference;
  final String? id;

  TourDetailPage({this.tourData, this.index, this.databaseReference, this.id});

  @override
  State<StatefulWidget> createState() => _TourDetailPage();
}

class _TourDetailPage extends State<TourDetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition? _googleMapCamera;
  TextEditingController? _reviewTextController;
  Marker? marker;
  List<Review> reviews = List.empty(growable: true);
  bool _disableWidget = false;
  DisableInfo? _disableInfo;
  double disableCheck1 = 0;
  double disableCheck2 = 0;

  @override
  void initState() {
    super.initState();
    widget.databaseReference!
        .child('tour')
        .child(widget.tourData!.id.toStirng())
        .child('review')
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          reviews.add(Review.fromSnapshot(event.snapshot));
        });
      }
    });

    _reviewTextController = TextEditingController();
    // 지도에서 관광지 위치를 표시하기 위한 변수
    _googleMapCamera = CameraPosition(
      target: LatLng(double.parse(widget.tourData!.mapy.toString()),
          double.parse(widget.tourData!.mapx.toString())),
      zoom: 16,
    );
    MarkerId markerId = MarkerId(widget.tourData!.mapy.toString());
    marker = Marker(
        position: LatLng(double.parse(widget.tourData!.mapy.toString()),
            double.parse(widget.tourData!.mapx.toString())),
        flat: true,
        markerId: markerId);
    markers[markerId] = marker!;
    getDisableInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  getDisableInfo() {
    widget.databaseReference!
        .child('tour')
        .child(widget.tourData!.id.toString())
        .onValue
        .listen((event) {
      _disableInfo = DisableInfo.fromSnapshot(event.snapshot);
      if (_disableInfo!.id == null) {
        setState(() {
          _disableWidget = false;
        });
      } else {
        setState(() {
          _disableWidget = true;
        });
      }
    });
  }
}
