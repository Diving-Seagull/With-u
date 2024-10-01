package com.divingseagull.withu

import android.annotation.TargetApi
import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.ParcelUuid
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.Permissions
import java.security.acl.Permission
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.divingseagull.withu/advertise"
    private var advertiser: BluetoothLeAdvertiser? = null

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter != null) {
            advertiser = bluetoothAdapter.bluetoothLeAdvertiser

            // MethodChannel 설정
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "startAdvertising") {
                    val teamInfo = call.argument<String>("teamInfo")
                    startAdvertising(teamInfo)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startAdvertising(teamInfo: String?) {
        val settings = AdvertiseSettings.Builder()
            .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
            .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
            .setConnectable(true)
            .build()

        val teamInfoBytes = teamInfo?.toByteArray() ?: byteArrayOf()
        val data = AdvertiseData.Builder()
            .addServiceUuid(ParcelUuid.fromString(UUID.randomUUID().toString())) // 고유 서비스 UUID
            .addManufacturerData(0x004C, teamInfoBytes) // Manufacturer ID에 기기 정보 추가
            .build()

        advertiser?.startAdvertising(settings, data, object : AdvertiseCallback() {
            override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
                super.onStartSuccess(settingsInEffect)
                // 광고 시작 성공
                Log.i("Android-Advertisement", "광고 시작!")
            }

            override fun onStartFailure(errorCode: Int) {
                super.onStartFailure(errorCode)
                // 광고 시작 실패
                Log.e("Android-Advertisement", "광고 실패!")
            }
        })
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onDestroy() {
        super.onDestroy()
        advertiser?.stopAdvertising(object : AdvertiseCallback() {})
    }
}
