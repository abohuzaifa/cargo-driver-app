// MainActivity.kt
package com.example.cargo_driver_app// Make sure this matches your package name

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.content.ContextCompat
import android.content.Intent
import com.example.cargo_driver_app.MyBackgroundService

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.tarudDriver.app/background_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startService") {
                startBackgroundService()
                result.success("Background service started")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startBackgroundService() {
        val intent = Intent(this, MyBackgroundService::class.java)
        ContextCompat.startForegroundService(this, intent)
    }
}
