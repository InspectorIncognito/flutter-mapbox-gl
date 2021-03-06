// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'page.dart';

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-33.552667, -70.789661),
  northeast: const LatLng(-33.366989, -70.540913),
);

class MapUiPage extends Page {
  MapUiPage() : super(const Icon(Icons.map), 'User interface 2');

  @override
  Widget build(BuildContext context) {
    return const MapUiBody();
  }
}

class MapUiBody extends StatefulWidget {
  const MapUiBody();

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.457172, -70.664256),
    zoom: 12.0,
  );

  MapboxMapController mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  bool _compassEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  String _styleString = MapboxStyles.MAPBOX_STREETS;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _myLocationTrackingMode = true;
  bool _telemetryEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  Widget _myLocationTrackingModeCycler() {
    return FlatButton(
      child: _myLocationTrackingMode ? Text('now tracking') : Text('start tracking'),
      onPressed: () {
        setState(() {
          mapController.startTracking();
          _myLocationTrackingMode = true;
        });
      },
    );
  }

  Widget _compassToggler() {
    return FlatButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compasss'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  Widget _latLngBoundsToggler() {
    return FlatButton(
      child: Text(
        _cameraTargetBounds.bounds == null
            ? 'bound camera target'
            : 'release camera target',
      ),
      onPressed: () {
        setState(() {
          _cameraTargetBounds = _cameraTargetBounds.bounds == null
              ? CameraTargetBounds(sydneyBounds)
              : CameraTargetBounds.unbounded;
        });
      },
    );
  }

  Widget _zoomBoundsToggler() {
    return FlatButton(
      child: Text(_minMaxZoomPreference.minZoom == null
          ? 'bound zoom'
          : 'release zoom'),
      onPressed: () {
        setState(() {
          _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
              ? const MinMaxZoomPreference(12.0, 16.0)
              : MinMaxZoomPreference.unbounded;
        });
      },
    );
  }

  Widget _setStyleToSatellite() {
    return FlatButton(
      child: Text('change map style to Satellite'),
      onPressed: () {
        setState(() {
          _styleString = MapboxStyles.SATELLITE;
        });
      },
    );
  }

  Widget _rotateToggler() {
    return FlatButton(
      child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
      onPressed: () {
        setState(() {
          _rotateGesturesEnabled = !_rotateGesturesEnabled;
        });
      },
    );
  }

  Widget _scrollToggler() {
    return FlatButton(
      child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
      onPressed: () {
        setState(() {
          _scrollGesturesEnabled = !_scrollGesturesEnabled;
        });
      },
    );
  }

  Widget _tiltToggler() {
    return FlatButton(
      child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
      onPressed: () {
        setState(() {
          _tiltGesturesEnabled = !_tiltGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return FlatButton(
      child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return FlatButton(
      child: Text('${_myLocationEnabled ? 'disable' : 'enable'} my location'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _telemetryToggler() {
    return FlatButton(
      child: Text('${_telemetryEnabled ? 'disable' : 'enable'} telemetry'),
      onPressed: () {
        setState(() {
          _telemetryEnabled = !_telemetryEnabled;
        });
        mapController?.setTelemetryEnabled(_telemetryEnabled);
      },
    );
  }

  Widget _visibleRegionGetter(){
    return FlatButton(
      child: Text('get currently visible region'),
      onPressed: () async{
        var result = await mapController.getVisibleRegion();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("SW: ${result.southwest.toString()} NE: ${result.northeast.toString()}"),));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      onStyleLoadedCallback: onMapStyleLoaded,
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: _compassEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleString,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {
        print("${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        List features = await mapController.queryRenderedFeatures(point, [],null);
        if (features.length>0) {
          print(features[0]);
        }
      },
      onCameraTrackingDismissed: () {
        this.setState(() {
          _myLocationTrackingMode = false;
        });
      }
    );

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: mapboxMap,
          ),
        ),
      ),
    ];

    if (mapController != null) {
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              Text('camera bearing: ${_position.bearing}'),
              Text(
                  'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                  '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text('camera tilt: ${_position.tilt}'),
              Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              _compassToggler(),
              _myLocationTrackingModeCycler(),
              _latLngBoundsToggler(),
              _setStyleToSatellite(),
              _zoomBoundsToggler(),
              _rotateToggler(),
              _scrollToggler(),
              _tiltToggler(),
              _zoomToggler(),
              _myLocationToggler(),
              _telemetryToggler(),
              _visibleRegionGetter(),
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

  void onMapStyleLoaded() {
    print("onMapStyleLoaded!");
    _styleReady = true;
    initOnlyIfReady();
  }

  void initOnlyIfReady() {
    if (_styleReady && _mapReady) {
      init();
    }
  }

  void init() async {
    if (_started) {
      return;
    }
    _started = true;

    SymbolLayer layer = SymbolLayer("stop-layer", "stop-source");
    layer.addProperty(Property.iconAllowOverlap(true));
    layer.addProperty(Property.iconOffset(0, -20));
    layer.addProperty(Property.iconSize(1.0));
    layer.addFilter(Filter.equal("selected", false));

    GeoJsonSource source = GeoJsonSource("stop-source");

    Feature userFeature = Feature("", -33.457172, -70.664256, UserImageBuilder().id);

    Feature feature = Feature("new id", -33.457172, -70.664256, StopImageBuilder().id);
    Feature feature2 = Feature("new id2", -33.457182, -70.664286, StopImageBuilder().id);
    feature.addBooleanProperty("selected", false);
    feature2.addBooleanProperty("selected", false);

    bool value = await mapController.addSource(source);
    print("source: $value");
    value = await mapController.addLayer(layer);
    print("layer: $value");
    value = await mapController.addImage(StopImageBuilder());
    print("addImage: $value");
    value = await mapController.updateSource(source, [feature, feature2]);
    print("update: $value");
    value = await mapController.updateUserFeature(userFeature);
    print("updateUserFeature: $value");
    return;
  }

  bool _started = false;
  bool _mapReady = false;
  bool _styleReady = false;

  void onMapCreated(MapboxMapController controller) {
    print("created");
    _mapReady = true;
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();
    initOnlyIfReady();

    mapController.getTelemetryEnabled().then((isEnabled) =>
        setState(() {
          _telemetryEnabled = isEnabled;
        }));
  }
}
