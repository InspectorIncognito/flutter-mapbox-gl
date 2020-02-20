// This file is generated.

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.mapbox.mapboxgl.line;

import com.mapbox.mapboxgl.LineOptionsSink;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.Style;
import com.mapbox.mapboxsdk.plugins.annotation.LineOptions;

import java.util.List;

public class TransappLineBuilder implements LineOptionsSink {
  private final LineOptions lineOptions;
  private String belowId;

  private static int idCounter = 0;

  public TransappLineBuilder() {
    this.lineOptions = new LineOptions();
  }

  public TransappLine build(Style style) {
    idCounter+=1;
    return new TransappLine(""+idCounter, style, lineOptions, belowId);
  }

  public void setBelowId(String belowId) {
    this.belowId = belowId;
  }

  @Override
  public void setLineJoin(String lineJoin) {
    lineOptions.withLineJoin(lineJoin);
  }
  
  @Override
  public void setLineOpacity(float lineOpacity) {
    lineOptions.withLineOpacity(lineOpacity);
  }
  
  @Override
  public void setLineColor(String lineColor) {
    lineOptions.withLineColor(lineColor);
  }

  @Override
  public void setLineWidth(float lineWidth) {
    lineOptions.withLineWidth(lineWidth);
  }

  @Override
  public void setLineGapWidth(float lineGapWidth) {
    lineOptions.withLineGapWidth(lineGapWidth);
  }

  @Override
  public void setLineOffset(float lineOffset) {
    lineOptions.withLineOffset(lineOffset);
  }

  @Override
  public void setLineBlur(float lineBlur) {
    lineOptions.withLineBlur(lineBlur);
  }

  @Override
  public void setLinePattern(String linePattern) {
    lineOptions.withLinePattern(linePattern);
  }
  
  @Override
  public void setGeometry(List<LatLng> geometry) {
    lineOptions.withLatLngs(geometry);
  }

  @Override
  public void setDraggable(boolean draggable) {
    lineOptions.withDraggable(draggable);
  }
}