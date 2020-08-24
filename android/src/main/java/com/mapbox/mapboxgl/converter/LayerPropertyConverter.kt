package com.mapbox.mapboxgl.converter

import com.mapbox.mapboxsdk.style.expressions.Expression
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.layers.PropertyValue

class LayerPropertyConverter {
    companion object {
        fun convert(raw: String): PropertyValue<*>? {

            val data = raw.split(";")

            return when(data[0]) {
                "iconSize" -> PropertyFactory.iconSize(data[1].toDouble().toFloat())
                "iconImageExpression" -> PropertyFactory.iconImage(Expression.get(data[1]))
                "iconImage" -> PropertyFactory.iconImage(data[1])
                "iconAllowOverlap" -> PropertyFactory.iconAllowOverlap(data[1].toBoolean())
                "iconOffset" -> PropertyFactory.iconOffset(arrayOf(data[1].toFloat(), data[2].toFloat()))
                else -> null
            }
        }
    }
}