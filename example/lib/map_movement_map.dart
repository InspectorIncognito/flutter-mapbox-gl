import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

import 'main.dart';
import 'page.dart';

class MapMovementPage extends ExamplePage {
  MapMovementPage()
      : super(const Icon(Icons.directions_run), 'Map movement & tracking');

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
  String text = "Start State";
  Color color = Colors.red;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void onMapCameraMove(CameraPosition newPosition) {

  }

  void onMapCameraMoveBegin(CameraPosition newPosition) {
    print("onMapCameraMoveBegin");
  }

  void onMapCameraMoveEnd(CameraPosition newPosition) {
    print("onMapCameraMoveEnd");
  }

  void onCameraTrackingDismissed() {
    print("onCameraTrackingDismissed");
    setState(() {
      color = Colors.red;
    });
  }

  void onStyleLoaded() async {
    var source = GeoJsonSource("source-id");
    var layer = SymbolLayer("layer-id", source.id)..addProperty(LayerProperty.iconImageExpression("image"));
    Feature userFeature = Feature("user-location", 0, 0)..addStringProperty("image", "user-icon");

    await mapController.addSvgImage("http://192.168.0.2/svg/bus_test.svg", "user-icon", 58, 33);
    await mapController.addSource(source);
    await mapController.addLayer(layer);
    await mapController.updateUserFeature(userFeature, source.id);
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
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  onMapCameraMove: onMapCameraMove,
                  onMapCameraMoveStart: onMapCameraMoveBegin,
                  onMapCameraMoveEnd: onMapCameraMoveEnd,
                  onStyleLoadedCallback: onStyleLoaded,
                  onCameraTrackingDismissed: onCameraTrackingDismissed,
                  initialCameraPosition:
                  const CameraPosition(target: LatLng(-33.453478, -70.570861), zoom: 16),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  mapController?.startTracking();
                  setState(() {
                    color = Colors.green;
                  });
                },
                child: Container(
                  height: 50,
                  color: color,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Start Tracking",
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
