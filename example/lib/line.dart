// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'page.dart';

class LinePage extends Page {
  LinePage() : super(const Icon(Icons.share), 'Line');

  @override
  Widget build(BuildContext context) {
    return const LineBody();
  }
}

class LineBody extends StatefulWidget {
  const LineBody();

  @override
  State<StatefulWidget> createState() => LineBodyState();
}

class LineBodyState extends State<LineBody> {
  LineBodyState();

  static final LatLng center = const LatLng(-33.457760, -70.664343);

  MapboxMapController controller;
  int _lineCount = 0;
  Line _selectedLine;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onLineTapped.add(_onLineTapped);
  }

  @override
  void dispose() {
    controller?.onLineTapped?.remove(_onLineTapped);
    super.dispose();
  }

  void _onLineTapped(Line line) {
    if (_selectedLine != null) {
      _updateSelectedLine(
        const LineOptions(
          lineWidth: 28.0,
        ),
      );
    }
    setState(() {
      _selectedLine = line;
    });
    _updateSelectedLine(
      LineOptions(
          // linecolor: ,
          ),
    );
  }

  void _updateSelectedLine(LineOptions changes) {
    controller.updateLine(_selectedLine, changes);
  }

  var started = false;

  void _add() {
    if (started) {
      return;
    }
    started = true;
    controller.addLine(
      LineOptions(
        geometry: [
          LatLng(-33.458493, -70.671982),
          LatLng(-33.457240, -70.664965),
          LatLng(-33.457026, -70.663013),
          LatLng(-33.456775, -70.660459),
        ],
        lineColor: "#ff0000",
        lineWidth: 4.0,
        lineOpacity: 1.0,
      ),
    ).then((_) {
      controller.addTexts([
        TextOptions(
            target: LatLng(-33.457026, -70.663013),
            color: "#ff0000",
            description: "<506/507>",
            bearing: 350
        ),
        TextOptions(
            target: LatLng(-33.458493, -70.671982),
            color: "#ff0000",
            description: "507>",
            bearing: 345
        )
      ]);
    });
  }

  void onStyleLoadedCallback() {
    _add();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapboxMap(
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: onStyleLoadedCallback,
        initialCameraPosition: const CameraPosition(
          target: LatLng(-33.457760, -70.664343),
          zoom: 14.0,
        ),
      ),
    );
  }
}
