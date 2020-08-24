import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

class StyleChangePage extends ExamplePage {
  StyleChangePage()
      : super(const Icon(Icons.photo_size_select_actual), 'Style change');

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
  String lightStyle = "mapbox://styles/mapbox/light-v10";
  String streetsStyle = "assets/dark_style.json";
  bool styleToggle = true;

  Color color = Colors.blueAccent;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: MapboxMap(
                  trackCameraPosition: true,
                  accessToken: MapsDemo.ACCESS_TOKEN,
                  styleString: lightStyle,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                  const CameraPosition(target: LatLng(-33.453478, -70.570861), zoom: 16),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    styleToggle = !styleToggle;
                    var style = styleToggle ? lightStyle : streetsStyle;
                    mapController?.changeStyle(style);
                  });
                },
                child: Container(
                  height: 50,
                  color: color,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Toggle Style",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}