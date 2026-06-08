package com.example.sehatalert

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder

class AlarmForegroundService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val title = intent?.getStringExtra("title") ?: "Medicine Reminder"
        val body = intent?.getStringExtra("body") ?: ""

        startForeground(9999, buildNotification(title, body))

        // Launch AlarmActivity from foreground service — allowed on all Android versions
        val alarmIntent = Intent(this, AlarmActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_NO_USER_ACTION)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra("title", title)
            putExtra("body", body)
        }
        startActivity(alarmIntent)

        stopSelf()
        return START_NOT_STICKY
    }

    private fun buildNotification(title: String, body: String): Notification {
        val channelId = "alarm_service_channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Alarm Service",
                NotificationManager.IMPORTANCE_LOW
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
                .setContentTitle(title)
                .setContentText(body)
                .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
                .build()
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
                .setContentTitle(title)
                .setContentText(body)
                .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
                .build()
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}