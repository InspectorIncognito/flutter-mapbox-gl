package com.mapbox.mapboxgl

import android.content.Context
import android.location.Location
import android.util.Log
import com.mapbox.android.core.location.LocationEngine
import com.mapbox.android.core.location.LocationEngineCallback
import com.mapbox.android.core.location.LocationEngineRequest
import com.mapbox.android.core.location.LocationEngineResult
import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource
import org.jetbrains.annotations.NotNull

class UserLocationTracker(private val controller: Controller, private val engine: LocationEngine, val style: Style, private val context: Context): LocationEngineCallback<LocationEngineResult> {
    override fun onSuccess(result: LocationEngineResult) {
        updateLocation(result.lastLocation)
    }

    override fun onFailure(exception: Exception) {

    }

    private var lastLocation: Location? = null
    private var movingWithUser = false
    private var isUserMovement = false
    private var moveWithOutsideLocation = false
    private var feature: Feature? = null

    private var source: GeoJsonSource? = null

    init {
        Log.d("UserTracker", "init")

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

    fun onCameraMoved(): Boolean {
        Log.d("ANDROID", "${isUserMovement}, $movingWithUser")
        //Log.d("UserTracker", "onCameraMoved")
        if (isUserMovement) {
            isUserMovement = false
        } else if (movingWithUser) {
            movingWithUser = false
            return true
        }
        return false
    }

    fun startTracking() {
        movingWithUser = true
        _forceUpdate(lastLocation)
    }

    fun setFeature(feature: @NotNull Feature, source: GeoJsonSource) {
        Log.d("UserTracker", "setFeature")
        this.source = source
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
        nullableLocation?.let {location ->
            if (lastLocation == null) {
                forceUpdate(location)
            } else {
                lastLocation?.distanceTo(location)?.let {
                    if (it > 0) {
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
        feature?.let {
            val feature = Feature.fromGeometry(Point.fromLngLat(location.longitude, location.latitude), it.properties(), it.id())

            source?.setGeoJson(FeatureCollection.fromFeatures(listOf(feature)))

            this.feature = feature
        }
        if (movingWithUser) {
            Log.d("UserTracker", "move to user at ${location.latitude}, ${location.longitude}")
            isUserMovement = true
            controller.moveCamera(LatLng(location.latitude, location.longitude))
        }
        lastLocation = location
    }

    interface Controller {
        fun moveCamera(latLng: LatLng)
    }
}