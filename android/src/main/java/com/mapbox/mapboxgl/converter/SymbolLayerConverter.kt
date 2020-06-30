package com.mapbox.mapboxgl.converter

import com.mapbox.mapboxsdk.style.expressions.Expression
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.layers.SymbolLayer
import io.flutter.plugin.common.MethodCall

class SymbolLayerConverter {
    companion object {

        fun convert(call: MethodCall): SymbolLayer {
            val symbolLayer = SymbolLayer(call.argument("id"), call.argument("source"))

            val properties = (call.argument<Any>("properties") as? List<String>)
            properties?.forEach { raw ->
                LayerPropertyConverter.convert(raw)?.let {
                    symbolLayer.setProperties(it)
                }
            }
            val filters = call.argument<Any>("filters") as? List<String>
            filters?.forEach { raw ->
                LayerFilterConverter.convert(raw)?.let {
                    symbolLayer.withFilter(it)
                }
            }
            call.argument<Double>("minZoom")?.toFloat()?.let {
                symbolLayer.minZoom = it
            }
            call.argument<Double>("maxZoom")?.toFloat()?.let {
                symbolLayer.maxZoom = it
            }
            return symbolLayer
        }
    }
}