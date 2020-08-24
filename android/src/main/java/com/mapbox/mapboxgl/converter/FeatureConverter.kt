package com.mapbox.mapboxgl.converter

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.mapbox.geojson.Feature
import com.mapbox.geojson.Point
import org.json.JSONArray

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