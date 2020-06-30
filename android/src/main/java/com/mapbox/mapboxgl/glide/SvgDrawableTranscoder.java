package com.mapbox.mapboxgl.glide;

import android.graphics.Picture;
import android.graphics.drawable.PictureDrawable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.load.Option;
import com.bumptech.glide.load.Options;
import com.bumptech.glide.load.engine.Resource;
import com.bumptech.glide.load.resource.SimpleResource;
import com.bumptech.glide.load.resource.transcode.ResourceTranscoder;
import com.caverock.androidsvg.SVG;

/**
 * Convert the {@link SVG}'s internal representation to an Android-compatible one ({@link Picture}).
 */
public class SvgDrawableTranscoder implements ResourceTranscoder<SVG, PictureDrawable> {
    @Nullable
    @Override
    public Resource<PictureDrawable> transcode(
            @NonNull Resource<SVG> toTranscode, @NonNull Options options) {
        SVG svg = toTranscode.get();

        Integer width = options.get(DECODE_WIDTH);
        Integer height = options.get(DECODE_HEIGHT);

        Picture picture = svg.renderToPicture(width, height);
        PictureDrawable drawable = new PictureDrawable(picture);
        return new SimpleResource<>(drawable);
    }

    public static final Option<Integer> DECODE_WIDTH =
            Option.memory("com.mapbox.mapboxgl.glide.DECODE_WIDTH", 40);
    public static final Option<Integer> DECODE_HEIGHT =
            Option.memory("com.mapbox.mapboxgl.glide.DECODE_HEIGHT", 40);
}