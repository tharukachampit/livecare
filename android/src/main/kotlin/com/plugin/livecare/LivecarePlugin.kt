package com.plugin.livecare

import android.Manifest
import android.annotation.SuppressLint
import android.app.Application
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.nfc.NfcAdapter.getDefaultAdapter
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.example.livecare.bluetoothsdk.initFunctions.LiveCareMainClass
import com.example.livecare.bluetoothsdk.initFunctions.bluetooth_connection.BluetoothDataResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


class LivecarePlugin: FlutterPlugin, MethodChannel.MethodCallHandler {


  private val TAG:String = "LiveCareSDK"
  private var methodChannel = "com.plugin.live_care/platform"
  private var dataChannel= "com.plugin.live_care/stream"

  private lateinit var liveCarDataChannel:EventChannel
  private lateinit var liveCareMethodChannel:MethodChannel

  private var emitter:EventChannel.EventSink? =null;

  private  lateinit var application: Context;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    liveCareMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannel)
    liveCarDataChannel = EventChannel(flutterPluginBinding.binaryMessenger,dataChannel)
    application=flutterPluginBinding.applicationContext;
    liveCarDataChannel.setStreamHandler (
            object :EventChannel.StreamHandler {
              override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                if(emitter!=null){
                  emitter?.endOfStream();
                }
                emitter = events;
              }

              override fun onCancel(arguments: Any?) {
                emitter?.endOfStream();

              }
            }
    )

    liveCareMethodChannel.setMethodCallHandler(this)

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    if (call.method == "initialize") {
      try {
        initProcess()
        result.success("initialized");
      }catch (err: Error){
        result.error("Initialization Error", err.message, err.stackTrace)
      }

    } else if (call.method == "dispose") {
      try {
        onDestroy();
        result.success("disposed");
      }catch (err: Error){
        result.error("Dispose Error", err.message, err.stackTrace)
      }

    } else if (call.method == "enableBle") {
      try {
        enableBle()
        result.success("enabled")
      }catch (err: Error){
        result.error("Enable Error", err.message, err.stackTrace)
      }

    }else if (call.method == "disableBle") {
      try {
        disableBle()
        result.success("disabled")
      }catch (err: Error){
        result.error("Disable Error", err.message, err.stackTrace)
      }

    }else {
      result.notImplemented()
    }
  }

  private fun onDestroy(){
    LiveCareMainClass.getInstance().destroy();
  }


  private fun enableBle(){
    if (ActivityCompat.checkSelfPermission(
        application.applicationContext,
        Manifest.permission.BLUETOOTH_CONNECT
      ) != PackageManager.PERMISSION_GRANTED
    ) {
      return
    }
    var ble = BluetoothAdapter.getDefaultAdapter()
    ble.enable();

  }

  private fun disableBle(){
    if (ActivityCompat.checkSelfPermission(
        application.applicationContext,
        Manifest.permission.BLUETOOTH_CONNECT
      ) != PackageManager.PERMISSION_GRANTED
    ) {
      return
    }
    var ble = BluetoothAdapter.getDefaultAdapter()
    ble.disable();
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    LiveCareMainClass.getInstance().destroy();
    emitter?.endOfStream();
    emitter =null;
    liveCarDataChannel.setStreamHandler(null)
    liveCareMethodChannel.setMethodCallHandler(null)
  }

  fun toMessage(event:String, data:Map<String,Any>?): String {
    println("message")
    Log.e("TAG", "send data")
    var dataTobeSent: MutableMap<String, Any>? = mutableMapOf(Pair("event",event))
    dataTobeSent?.set("data",JSONObject(data?.toMap()).toString());
    return  JSONObject(dataTobeSent?.toMap()).toString();
  }

  private fun initProcess() {
    val key = "SGA5v3ijooU0qGhiPVAh"
    val secretKey = "yBF6CvN+ebIiJhEOzy1rAFePS15opLxIg/mUCPgYpjjvMShdxK/pTUsmpVYcbzFl5ClwE4N9+97n7y8inuUApA=="
    LiveCareMainClass.getInstance().application = application as Application
    LiveCareMainClass.getInstance().init(application as Application, key, secretKey, object : BluetoothDataResult {
      override fun authenticationStatus(status: String) {
        println("auth")
        Log.e("TAG", "auth")
        var dataTobeSent:MutableMap<String, Any>? = mutableMapOf(Pair("authenticated",status))

        emitter?.success(toMessage("onAuthStatusChanged",dataTobeSent));
      }

      override fun onScanningStatus(onScan: String) {
        println("scanning")
        Log.e("TAG", "sacanning")
        var dataTobeSent: MutableMap<String, Any>? = mutableMapOf(Pair("status",onScan))
        emitter?.success(toMessage("onScanStatusChanged",dataTobeSent));
      }

      override  fun onStartConnect(deviceName: String,deviceId: String) {
        println("start connect")
        Log.e("TAG", "start scan")
        var dataTobeSent: MutableMap<String, Any>? = mutableMapOf(Pair("device",deviceName))
        dataTobeSent?.set("deviceId",deviceId);
        emitter?.success(toMessage("onDeviceConnecting", dataTobeSent));
      }

      override  fun OnConnectedSuccess(deviceType: String, deviceId: String) {

        var dataTobeSent: MutableMap<String, Any>? = mutableMapOf(Pair("device",deviceType))
        dataTobeSent?.set("deviceId",deviceId);
        emitter?.success(toMessage("onDeviceConnected",dataTobeSent));
      }

      override fun OnConnectFail(deviceType: String, message: String,deviceId: String) {
        var dataTobeSent: MutableMap<String, Any>? = mutableMapOf(Pair("device",deviceType))
        dataTobeSent?.set("deviceId",deviceId);
        emitter?.success(toMessage("onDeviceConnectionFailed",dataTobeSent));
      }

      override fun onDisConnected(deviceType: String, deviceId: String) {
        var dataTobeSent: MutableMap<String, Any>? = mutableMapOf(Pair("device",deviceType))
        dataTobeSent?.set("deviceId",deviceId);
        emitter?.success(toMessage("onDeviceDisconnected",dataTobeSent));
      }

      override  fun onDataReceived(data: MutableMap<String, Any>?, deviceType: String?, deviceId: String?) {
        var dataTobeSent: MutableMap<String, Any> = mutableMapOf();
        dataTobeSent["device"] = deviceType.toString()
        dataTobeSent["deviceId"] = deviceId.toString()
        dataTobeSent["data"] = JSONObject(data?.toMap()).toString()

        emitter?.success(toMessage("onDataReceived",  dataTobeSent))
      }
    })
  }
}
