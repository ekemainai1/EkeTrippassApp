package com.example.eketrippas;


import android.graphics.drawable.Drawable;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.DrawableSplashScreen;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.SplashScreen;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }

}
