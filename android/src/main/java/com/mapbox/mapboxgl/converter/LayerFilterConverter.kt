package com.mapbox.mapboxgl.converter

import com.mapbox.mapboxsdk.style.expressions.Expression

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