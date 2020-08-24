import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

class PaddingChangePage extends ExamplePage {
  PaddingChangePage()
      : super(const Icon(Icons.transform), 'Padding change');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController mapController;
  double bottomPadding = 0;
  double minPadding = 50;
  Color color = Colors.blueAccent;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onMapCameraMoveEnd(CameraPosition newPosition) {
    print("onMapCameraMoveEnd ${newPosition.target.latitude}, ${newPosition.target.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = (MediaQuery.of(context).size.height - 56 - 20);
    var minHeight = minPadding / screenSize;

    return new Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: minPadding),
              child: MapboxMap(
                trackCameraPosition: true,
                accessToken: MapsDemo.ACCESS_TOKEN,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                onMapCameraMoveEnd: _onMapCameraMoveEnd,
                initialCameraPosition:
                const CameraPosition(target: LatLng(-33.453478, -70.570861), zoom: 16),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox.expand(
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (DraggableScrollableNotification notification) {
                    var padding = (notification.extent - minHeight) * screenSize;
                    mapController.movePadding(padding);
                    return false;
                  },
                  child: DraggableScrollableSheet(
                    minChildSize: minHeight,
                    maxChildSize: 1,
                    initialChildSize: minHeight,
                    builder: (BuildContext context, ScrollController controller) {
                      return CustomScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: controller,
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              color: color,
                              height: 10000,
                              child: GestureDetector(
                                onTap: () {
                                  mapController.moveCamera(CameraUpdate.newLatLng(LatLng(-33.453478, -70.570861)));
                                },
                                child: Text(
                                  "Center map",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}