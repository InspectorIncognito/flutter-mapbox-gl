package com.mapbox.mapboxgl

import android.content.Context
import android.graphics.BitmapFactory
import android.util.Log
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.geojson.Point
import com.mapbox.mapboxgl.line.TransappLineBuilder
import com.mapbox.mapboxgl.text.TextOptions
import com.mapbox.mapboxsdk.log.Logger
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.style.expressions.Expression
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.layers.PropertyValue
import com.mapbox.mapboxsdk.style.layers.SymbolLayer
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource
import io.flutter.plugin.common.MethodCall
import org.json.JSONArray

class ImageConverter {
    companion object {
        fun convert(call: MethodCall, style: Style, context: Context): Boolean {
            val id = call.argument<String?>("id")
            val type = call.argument<String?>("type")
            val properties = call.argument<List<String>?>("properties")

            if (id == null || type == null || properties == null) {
                return false
            }

            return when(type) {
                "busstop-image" -> {
                    style.addImage(id, BitmapFactory.decodeResource(context.resources, R.drawable.paradero))
                    true
                }
                "user-image" -> {
                    style.addImage(id, BitmapFactory.decodeResource(context.resources, R.drawable.usuario))
                    true
                }
                else -> false
            }
        }
    }
}

class FeatureConverter {
    companion object {
        fun convert(raw: String): List<Feature> {

            val list = mutableListOf<Feature>()

            JSONArray(raw).let { 0.until(it.length()).map { i -> it.optJSONObject(i) } }.map { jsonObject ->
                val id = jsonObject.getString("id")
                val latitude = jsonObject.getDouble("latitude")
                val longitude = jsonObject.getDouble("longitude")
                val properties = jsonObject.getJSONObject("properties")

                val element = Gson().fromJson(properties.toString(), JsonObject::class.java)

                val feature = Feature.fromGeometry(Point.fromLngLat(longitude, latitude), element, id)

                list.add(feature)
            }

            return list
        }
    }
}

class GeoJsonSourceConverter {
    companion object {
        fun convert(call: MethodCall): GeoJsonSource {
            return GeoJsonSource(call.argument("id"), FeatureCollection.fromFeatures(listOf()))
        }
    }
}

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
            symbolLayer.setProperties(PropertyFactory.iconImage(Expression.get("image")))
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

class LayerPropertyConverter {
    companion object {
        fun convert(raw: String): PropertyValue<*>? {

            val data = raw.split(";")

            return when(data[0]) {
                "iconSize" -> PropertyFactory.iconSize(data[1].toDouble().toFloat())
                "iconAllowOverlap" -> PropertyFactory.iconAllowOverlap(data[1].toBoolean())
                "iconOffset" -> PropertyFactory.iconOffset(arrayOf(data[1].toFloat(), data[2].toFloat()))
                else -> null
            }
        }
    }
}

class LayerFilterConverter {
    companion object {
        fun convert(raw: String): Expression? {

            val data = raw.split(";")

            return when(data[0]) {
                "equal" -> Expression.eq((Expression.get(data[1])), Expression.literal(data[2].toBoolean()))
                else -> null
            }
        }
    }
}

class LineConverter {
    companion object {
        fun interpretLineOptions(o: Any, sink: TransappLineBuilder) {
            val data = Convert.toMap(o)
            val belowId = data["belowId"]
            if (belowId != null) {
                sink.setBelowId(belowId as String)
            }
        }
    }
}

class TextConverter {
    companion object {
        fun convert(o: Any): List<TextOptions> {
            val list = mutableListOf<TextOptions>()
            val data = Convert.toList(o)
            
            data.forEach { 
                val map = Convert.toMap(it)
                val description = map["description"] as? String
                val color = map["color"] as? String
                val bearing = map["bearing"] as? Double
                val latitude = map["latitude"] as? Double
                val longitude = map["longitude"] as? Double

                if (description != null && color != null && bearing != null && latitude != null && longitude != null) {
                    val options = TextOptions(description, color, bearing, latitude, longitude)
                    list.add(options)
                }
            }
            
            return list
        }
    }
}