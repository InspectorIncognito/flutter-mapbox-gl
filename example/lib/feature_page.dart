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
  GeoJsonSource busSource;
  SymbolLayer busLayer;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    stopSource = GeoJsonSource("stop-source-id");
    stopLayer = SymbolLayer("stop-layer-id", stopSource.id)..addProperty(LayerProperty.iconImageExpression("image"));
    busSource = GeoJsonSource("bus-source-id");
    busLayer = SymbolLayer("bus-layer-id", busSource.id)..addProperty(LayerProperty.iconImage("bus"));
  }

  Future<void> _onStyleLoading() async {
    try {

      var busFeature = Feature("bus",  -33.453478, -70.570861);

      await mapController.addSvgImage("http://192.168.0.2/svg/bus_test.svg", "bus", 58, 33);
      await mapController.addSource(busSource);
      await mapController.addLayer(busLayer);
      await mapController.updateSource(busSource, [busFeature]);

      await mapController.addSvgImage("assets/svg/icon_stop_bus.svg", "stop", 24, 24);
      await mapController.addSource(stopSource);
      await mapController.addLayer(stopLayer);

    } catch (e) {
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
                margin: EdgeInsets.only(top : 100),
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
            Align(
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
            )
          ],
        )
    );
  }
}
