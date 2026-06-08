package com.example.sehatalert

import android.app.KeyguardManager
import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.RingtoneManager
import android.media.Ringtone
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class AlarmActivity : AppCompatActivity() {

    private var ringtone: Ringtone? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Wake screen and show over lock screen
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }

        setContentView(R.layout.activity_alarm)

        val title = intent.getStringExtra("title") ?: "Medicine Reminder"
        val body  = intent.getStringExtra("body")  ?: ""

        findViewById<TextView>(R.id.tv_title).text = title
        findViewById<TextView>(R.id.tv_body).text  = body

        playAlarmSound()

        findViewById<Button>(R.id.btn_dismiss).setOnClickListener {
            stopAlarm()
            finish()
        }
    }

    private fun playAlarmSound() {
        val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)

        ringtone = RingtoneManager.getRingtone(applicationContext, alarmUri)

        ringtone?.let { r ->
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                r.isLooping = true
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                r.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
            }
            r.play()
        }
    }

    private fun stopAlarm() {
        ringtone?.stop()
        ringtone = null
    }

    override fun onDestroy() {
        stopAlarm()
        super.onDestroy()
    }
}