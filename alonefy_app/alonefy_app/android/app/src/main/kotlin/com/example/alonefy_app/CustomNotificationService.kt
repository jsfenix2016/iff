// CustomNotificationService.kt

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.CountDownTimer
import android.os.IBinder
import android.os.SystemClock
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint

class CustomNotificationService : Service() {

    private var countDownTimer: CountDownTimer? = null
    private var remainingTimeInSeconds: Long = 300 // 5 minutes

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        showCustomNotification()
        startCountdownTimer()
        return START_STICKY
    }

    private fun showCustomNotification() {
        val channelId = "custom_channel"
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Custom Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Custom Notification")
            .setContentText("Time remaining: ${remainingTimeInSeconds / 60}:${remainingTimeInSeconds % 60}")
            .build()

        startForeground(1, notification)
    }

    private fun startCountdownTimer() {
        countDownTimer = object : CountDownTimer(remainingTimeInSeconds * 1000, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                remainingTimeInSeconds = millisUntilFinished / 1000
                updateNotification()
            }

            override fun onFinish() {
                stopSelf()
            }
        }.start()
    }

    private fun updateNotification() {
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val notification = NotificationCompat.Builder(this, "custom_channel")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Custom Notification")
            .setContentText("Time remaining: ${remainingTimeInSeconds / 60}:${remainingTimeInSeconds % 60}")
            .build()

        notificationManager.notify(1, notification)
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        countDownTimer?.cancel()
        super.onDestroy()
    }
}
