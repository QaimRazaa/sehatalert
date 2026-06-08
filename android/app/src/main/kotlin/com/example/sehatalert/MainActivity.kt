package com.example.sehatalert

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.sehatalert/alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "launchAlarm") {
                val title = call.argument<String>("title") ?: "Medicine Reminder"
                val body = call.argument<String>("body") ?: ""

                val serviceIntent = Intent(this, AlarmForegroundService::class.java).apply {
                    putExtra("title", title)
                    putExtra("body", body)
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startForegroundService(serviceIntent)
                } else {
                    startService(serviceIntent)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}