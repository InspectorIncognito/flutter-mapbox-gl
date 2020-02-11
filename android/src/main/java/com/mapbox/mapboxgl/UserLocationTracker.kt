package com.mapbox.mapboxgl

import android.content.Context
import android.graphics.BitmapFactory
import android.location.Location
import android.util.Log
import com.google.gson.JsonObject
import com.mapbox.android.core.location.LocationEngine
import com.mapbox.android.core.location.LocationEngineCallback
import com.mapbox.android.core.location.LocationEngineRequest
import com.mapbox.android.core.location.LocationEngineResult
import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.camera.CameraUpdateFactory
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.maps.MapboxMap
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.style.expressions.Expression
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.layers.SymbolLayer
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource
import java.lang.Exception

class UserLocationTracker(private val mapboxMap: MapboxMap, private val controller: Controller, private val engine: LocationEngine, val style: Style, private val context: Context): LocationEngineCallback<LocationEngineResult> {
    override fun onSuccess(result: LocationEngineResult) {
        updateLocation(result.lastLocation)
    }

    override fun onFailure(exception: Exception) {

    }

    private var lastLocation: Location? = null
    private var moveWithUser = false
    private var moveWithOutsideLocation = false
    private var feature: Feature? = null

    private val source = GeoJsonSource("user-source", FeatureCollection.fromFeatures(listOf()))

    init {
        Log.d("UserTracker", "init")
        val symbolLayer = SymbolLayer("user-layer-id", "user-source")
        symbolLayer.withProperties(
                PropertyFactory.iconImage(Expression.get("image")),
                PropertyFactory.iconSize(1.0f),
                PropertyFactory.iconOffset(arrayOf(0f, -20f)),
                PropertyFactory.iconAllowOverlap(true)
        )

        style.addSource(source)
        style.addImage("user-image", BitmapFactory.decodeResource(context.resources, R.drawable.usuario))
        style.addLayer(symbolLayer)

        startLocationUpdates()
    }

    private fun startLocationUpdates() {
        Log.d("UserTracker", "startLocationUpdates")
        val request = LocationEngineRequest.Builder(3000L)
                .setPriority(LocationEngineRequest.PRIORITY_HIGH_ACCURACY)
                .setMaxWaitTime(9000L)
                .build()

        engine.requestLocationUpdates(request, this, context.mainLooper)
        engine.getLastLocation(this)
    }

    fun moveWithOutsideLocation(move: Boolean) {
        moveWithOutsideLocation = move
        if (moveWithOutsideLocation) {
            engine.removeLocationUpdates(this)
        } else {
            startLocationUpdates()
        }
    }

    fun moveWithUser(move: Boolean) {
        Log.d("UserTracker", "moveWithUser $move")
        moveWithUser = move
        if (move) {
            _forceUpdate(lastLocation)
        }
    }

    fun setFeature(feature: Feature) {
        Log.d("UserTracker", "setFeature")
        this.feature = feature
        _forceUpdate(lastLocation)
    }

    fun onStart() {
        Log.d("UserTracker", "onStart")
        if (!moveWithOutsideLocation) {
            startLocationUpdates()
        }
    }

    fun onStop() {
        Log.d("UserTracker", "onStop")
        if (!moveWithOutsideLocation) {
            engine.removeLocationUpdates(this)
        }
    }

    open fun updateLocation(nullableLocation: Location?) {
        Log.d("UserTracker", "updateLocation")
        nullableLocation?.let {location ->
            if (lastLocation == null) {
                forceUpdate(location)
            } else {
                lastLocation?.distanceTo(location)?.let {
                    if (it > 5) {
                        forceUpdate(location)
                    }
                }
            }
        }
    }

    private fun _forceUpdate(location: Location?) {
       location?.let {
           forceUpdate(it)
       }
    }

    private fun forceUpdate(location: Location) {
        Log.d("UserTracker", "forceUpdate")
        feature?.let {
            val feature = Feature.fromGeometry(Point.fromLngLat(location.longitude, location.latitude), it.properties(), "user-location")

            source.setGeoJson(FeatureCollection.fromFeatures(listOf(feature)))

            this.feature = feature

            if (moveWithUser) {
                Log.d("UserTracker", "onUserMovement")
                controller.onUserMovement()
                mapboxMap.animateCamera(CameraUpdateFactory.newLatLng(LatLng(location.latitude, location.longitude)))
            }
        }
        lastLocation = location
    }

    interface Controller {
        fun onUserMovement()
    }
}