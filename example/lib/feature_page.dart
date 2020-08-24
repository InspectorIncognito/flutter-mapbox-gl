import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

import 'main.dart';
import 'page.dart';

class FeaturePage extends ExamplePage {
  FeaturePage()
      : super(const Icon(Icons.layers), 'Feature, Source & Layer');

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

  GeoJsonSource stopSource;
  SymbolLayer stopLayer;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    stopSource = GeoJsonSource("source-id");
    stopLayer = SymbolLayer("layer-id", stopSource.id)..addProperty(LayerProperty.iconImage("image-name"));
  }

  Future<void> _onStyleLoading() async {
    try {
      var featureA = Feature("pd451", -33.453478, -70.570861);
      var featureB = Feature("pd187", -33.453359, -70.571442);

      await mapController.addSvgImage("assets/svg/icon_stop_bus.svg", "image-name", 24, 24);
      await mapController.addSource(stopSource);
      await mapController.addLayer(stopLayer);
      await mapController.updateSource(stopSource, [featureA, featureB]);
    } catch (e) {
      print("ERROR!");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: MapboxMap(
                  trackCameraPosition: true,
                  accessToken: MapsDemo.ACCESS_TOKEN,
                  onStyleLoadedCallback: _onStyleLoading,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                  const CameraPosition(target: LatLng(-33.453478, -70.570861), zoom: 16),
                ),
              ),
            ),
            /*Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      var stop1Feature = Feature("stop1", -33.453397, -70.571448)..addStringProperty("image", "stop");
                      var stop2Feature = Feature("stop2", -33.452935, -70.570992)..addStringProperty("image", "stop");
                      try {
                        await mapController.updateSource(stopSource, [stop1Feature, stop2Feature]);
                      } catch (e) {
                        final snackBar = SnackBar(
                          content: Text('Feature cant be added, source was removed!'),
                          action: SnackBarAction(
                            label: 'Add Source & Layer',
                            onPressed: () async {
                              await mapController.addSource(stopSource);
                              await mapController.addLayer(stopLayer);
                            },
                          ),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      height: 50,
                      color: Colors.blueAccent,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add Feature",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await mapController.removeLayer(busLayer);
                      await mapController.removeLayer(stopLayer);
                      await mapController.removeSource(stopSource);
                      await mapController.removeSource(busSource);
                    },
                    child: Container(
                      height: 50,
                      color: Colors.blueAccent,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Remove Everything",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )*/
          ],
        )
    );
  }
}