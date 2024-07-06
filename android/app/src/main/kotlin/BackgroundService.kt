// MyBackgroundService.kt
package  com.example.cargo_driver_app // Ensure this matches the package name

import android.app.Service
import android.content.Intent
import android.os.IBinder

class MyBackgroundService : Service() {
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Your background service code here
        return START_STICKY
    }
}
