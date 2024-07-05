package com.tarudDriver.app

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.tarudDriver.app.BackgroundService // Make sure to import your BackgroundService class

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.tarudDriver.app/background_service")
            .setMethodCallHandler { call, result ->
                if (call.method == "startService") {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(Intent(this, BackgroundService::class.java))
                    } else {
                        startService(Intent(this, BackgroundService::class.java))
                    }
                    result.success(null)
                }
            }
    }
}