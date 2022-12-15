package com.byfrunze.battery_indicator

import android.content.*
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BatteryIndicatorPlugin */
class BatteryIndicatorPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context
    private var chargingStateChangeReceiver: BroadcastReceiver? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "battery_indicator")
        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "battery_indicator/stream")
        eventChannel.setStreamHandler(this)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getBatteryLevel" -> {
                val currentBatteryLevel = getBatteryLevel()
                if (currentBatteryLevel != -1) {
                    result.success(currentBatteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            }
            else -> {
                println(call.method)

                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        chargingStateChangeReceiver = createChargingStateChangeReceiver(events)
        context.registerReceiver(
            chargingStateChangeReceiver,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )
        val lvl = getBatteryLevel()
        events.success(lvl)

    }

    private fun createChargingStateChangeReceiver(events: EventChannel.EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val lvl = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                events.success(lvl)
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(chargingStateChangeReceiver)
        chargingStateChangeReceiver = null
    }

    private fun getBatteryLevel(): Int {
        return if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            getBatteryProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(context).registerReceiver(
                null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )
            intent!!.getIntExtra(BatteryManager.EXTRA_HEALTH, -1)
        }
    }

    @RequiresApi(api = VERSION_CODES.LOLLIPOP)
    private fun getBatteryProperty(property: Int): Int {
        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(property)
    }

}
