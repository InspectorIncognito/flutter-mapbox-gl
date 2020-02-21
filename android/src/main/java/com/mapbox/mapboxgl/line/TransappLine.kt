package com.mapbox.mapboxgl.line

import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.plugins.annotation.LineOptions
import com.mapbox.mapboxsdk.style.layers.LineLayer
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource

class TransappLine(layerId: String, val style: Style, private val line: LineOptions, private val belowId: String?) {
    private val id = getLayerId(layerId)
    val innerId = layerId
    private val source: GeoJsonSource = GeoJsonSource(getSourceId(id), FeatureCollection.fromFeatures(listOf()))
    //private val markersSource: GeoJsonSource = GeoJsonSource("transapp-line-source-markers-${line.id}", FeatureCollection.fromFeatures(listOf()))
    
    fun initLine() {
        style.addSource(source)
        
        val lineLayer = LineLayer(id, source.id)
        lineLayer.withProperties(
                PropertyFactory.lineWidth(line.lineWidth),
                PropertyFactory.lineColor(line.lineColor)
        )
        
        if (belowId != null && style.getLayer(belowId) != null) {
            style.addLayerBelow(lineLayer, belowId)
        } else {
            style.addLayer(lineLayer)
        }
        
        val shape = Feature.fromGeometry(line.geometry)
        source.setGeoJson(shape)
        
        
        
        
    }

    companion object {
        private fun getLayerId(id: String): String {
            return "line-layer-${id}"
        }

        private fun getSourceId(id: String): String {
            return "line-source-${id}"
        }
        
        fun remove(style: Style, id: String) {
            style.removeLayer(getLayerId(id))
            style.removeSource(getSourceId(id))
        }
    }
}