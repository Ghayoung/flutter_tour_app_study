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
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 150,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            '${widget.tourData!.title}',
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          centerTitle: true,
          titlePadding: EdgeInsets.only(top: 10),
        ),
        pinned: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      SliverList(
          delegate: SliverChildListDelegate([
        SizedBox(
          height: 20,
        ),
        Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Hero(
                    tag: 'tourinfo${widget.index}',
                    child: Container(
                        width: 300.0,
                        height: 300.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: getImage(widget.tourData!.imagePath),
                            )))),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    widget.tourData!.address!,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                getGoogleMap(),
                _disableWidget == false
                    ? setDisableWidget()
                    : showDisableWidget(),
              ],
            ),
          ),
        ),
      ])),
      SliverPersistentHeader(
        delegate: _HeaderDelegate(
            minHeight: 50,
            maxHeight: 100,
            child: Container(
              color: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      '후기',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            )),
        pinned: true,
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Card(
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Text(
                '${reviews[index].id} : ${reviews[index].review}',
                style: TextStyle(fontSize: 15),
              ),
            ),
            onDoubleTap: () {
              if (reviews[index].id == widget.id) {
                widget.databaseReference!
                    .child('tour')
                    .child(widget.tourData!.id.toString())
                    .child('review')
                    .child(widget.id!)
                    .remove();
                setState(() {
                  reviews.removeAt(index);
                });
              }
            },
          ),
        );
      }, childCount: reviews.length)),
    ]));
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

  ImageProvider getImage(String? imagePath) {
    if (imagePath != null) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage('repo/images/map_location.png');
    }
  }

  Widget setDisableWidget() {
    return Container();
  }

  getGoogleMap() {}

  showDisableWidget() {}
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  _HeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => throw UnimplementedError();

  @override
  // TODO: implement minExtent
  double get minExtent => throw UnimplementedError();

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    throw UnimplementedError();
  }
}
