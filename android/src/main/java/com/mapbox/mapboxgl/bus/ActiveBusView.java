package com.mapbox.mapboxgl.bus;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.core.content.ContextCompat;

import com.mapbox.mapboxgl.R;


/**
 * Created by Agustin on 12/4/2017.
 */

public class ActiveBusView extends LinearLayout {
    private String service;
    private Drawable body;

    private ImageView bodyImage;
    private BorderTextView text;

    public ActiveBusView(Context context, AttributeSet attrs) {
        super(context, attrs, android.R.attr.textViewStyle);

        service = "506";
        body = ContextCompat.getDrawable(context, R.drawable.ic_transantiago_metbus);
        initialize();
    }

    public ActiveBusView(Context context, String service, Drawable body) {
        super(context);
        this.service = service;
        this.body = body;
        initialize();
    }

    private void initialize() {
        String infService = Context.LAYOUT_INFLATER_SERVICE;
        LayoutInflater li =
                (LayoutInflater)getContext().getSystemService(infService);
        li.inflate(R.layout.view_bus, this, true);

        bodyImage = findViewById(R.id.body);
        text = findViewById(R.id.text);
        setLayout();
    }


    private void setLayout() {
        bodyImage.setImageDrawable(body);

        if (service.length() == 0) {
            text.setVisibility(GONE);
        } else {
            text.setVisibility(VISIBLE);
            text.setText(service);
        }
    }

    private int getPixelsFromDp(int dp) {
        float scale = getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }


    private Bitmap loadBitmapFromView(View v) {
        int specWidth = MeasureSpec.makeMeasureSpec(getPixelsFromDp(77) /* any */, MeasureSpec.EXACTLY);
        int specHeight = MeasureSpec.makeMeasureSpec(0 /* any */, MeasureSpec.UNSPECIFIED);

        v.measure(specWidth, specHeight);
        Bitmap b = Bitmap.createBitmap(v.getMeasuredWidth(), v.getMeasuredHeight(), Bitmap.Config.ARGB_4444);
        Canvas c = new Canvas(b);
        v.layout(0, 0, v.getMeasuredWidth(), v.getMeasuredHeight());
        v.draw(c);
        return b;
    }

    public BitmapDrawable getBitmapDrawable() {
        return new BitmapDrawable(getResources(), loadBitmapFromView(this));
    }
}
