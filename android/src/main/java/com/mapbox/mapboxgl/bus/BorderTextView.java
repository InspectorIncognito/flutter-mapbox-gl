package com.mapbox.mapboxgl.bus;

import android.content.Context;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import com.mapbox.mapboxgl.R;


/**
 * Created by Agustin on 12/4/2017.
 */

public class BorderTextView extends LinearLayout {

    private TextView textView;
    private TextView shadowTextView;


    public BorderTextView(Context context) {
        super(context);
        initialize();
    }

    public BorderTextView(Context context, AttributeSet attrs) {
        super(context, attrs, android.R.attr.textViewStyle);

        initialize();
    }

    private void initialize() {
        String infService = Context.LAYOUT_INFLATER_SERVICE;
        LayoutInflater li =
                (LayoutInflater)getContext().getSystemService(infService);
        li.inflate(R.layout.view_border_text, this, true);

        textView = findViewById(R.id.textViewId);
        textView.setTextColor(getResources().getColor(R.color.background_black));

        shadowTextView = findViewById(R.id.textViewShadowId);

        shadowTextView.getPaint().setStrokeWidth(5);
        shadowTextView.getPaint().setStyle(Paint.Style.STROKE);
    }

    public void setText(String text) {
        shadowTextView.setText(text);
        textView.setText(text);
        invalidate();
    }
    public void setWhite() {
        shadowTextView.setVisibility(INVISIBLE);
        textView.setTextColor(ContextCompat.getColor(getContext(), R.color.background_white));
        textView.setTextSize(15f);
    }

    public int getTextLength() {
        return textView.length();
    }
}
