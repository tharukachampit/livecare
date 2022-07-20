import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../enums/livecare_event.dart';
import '../interfaces/devices/device.dart';
import '../interfaces/platform_message.dart';
import '../logger/logger.dart';
import 'channels.dart';
import 'core.dart';

class LiveCare {
  static final Map<String, Device> _devices = {};
  static StreamSubscription? _liveSubscription;

  //getters
  static Map<String, Device> get devices => _devices;
  static Stream<LiveCareEvent> get onEvent => eventHandler.stream;

  //initialize
  static Future<bool> initialize({String? key, String? secret}) async {
    try {
      if (_liveSubscription == null) {
        Stream eventStream = receiver.receiveBroadcastStream();

        _liveSubscription = eventStream.listen(_listenToChanges);

        String init = await platform.invokeMethod('initialize');

        if (init == LiveCareEventHandle.initialized.name) {
          return true;
        }
        return false;
      } else {
        return true;
      }
    } catch (err) {
      Logger.error(err);
      return false;
    }
  }

  static Future<void> cancel() async {
    try {
      _liveSubscription?.cancel();
      _liveSubscription = null;
      String dispose = await platform.invokeMethod('dispose');
    } catch (err) {
      Logger.error(err);
    }
  }

  static Future<void> enableBle() async {
    try {
      String dispose = await platform.invokeMethod('enableBle');
    } catch (err) {
      Logger.error(err);
    }
  }

  static Future<void> disableBle() async {
    try {
      String dispose = await platform.invokeMethod('disableBle');
    } catch (err) {
      Logger.error(err);
    }
  }

  //listen to platform events
  static _listenToChanges(dynamic event) async {
    LiveCareMessage _msg = LiveCareMessage.fromJsonString(event);

    print(_msg.data);
    switch (_msg.event) {
      case LiveCareEventHandle.initialized:
        _handleAuthChange(_msg);
        break;
      case LiveCareEventHandle.onScanStatusChanged:
        _handleScanStatusChange(_msg);
        break;
      case LiveCareEventHandle.onDataReceived:
        _handleDataReceived(_msg);
        break;
      case LiveCareEventHandle.onDeviceConnected:
        _handleDeviceConnected(_msg);
        break;
      case LiveCareEventHandle.onDeviceDisconnected:
        _handleDeviceDisconnected(_msg);
        break;
      default:
        break;
    }
  }

  static void _handleAuthChange(LiveCareMessage message) async {
    if (message.data['authenticated'] == LiveCareEventHandle.initialized.name) {
      eventHandler.add(LiveAuthenticated());
    } else {
      eventHandler.add(LiveAuthenticateFailed());
    }
  }

  static void _handleScanStatusChange(LiveCareMessage message) async {
    try {
      if (message.data['status'] == 'onScanStarted') {
        eventHandler.add(LiveScanning());
      } else {
        eventHandler.add(LiveScanCompleted());
      }
    } catch (err) {
      Logger.error(err);
    }
  }

  static void _handleDataReceived(LiveCareMessage message) async {
    try {
      Device _device = Device.fromJson(message.data);
      Device _updated = _device.copyWith(
        connected: true,
      );

      _devices[_device.id] = _updated;
      eventHandler.add(LiveDataReceived(_updated));
    } catch (err) {
      Logger.error(err);
    }
  }

  static void _handleDeviceConnected(LiveCareMessage message) async {
    try {
      Device _device = Device.fromJson(message.data).copyWith(
        connected: true,
      );
      if (_devices[_device.id] == null) {
        _devices[_device.id] = _device;
      } else {
        _devices[_device.id]?.connected = true;
      }
      eventHandler.add(LiveDeviceConnected(_devices[_device.id]!));
    } catch (err) {
      Logger.error(err);
    }
  }

  static void _handleDeviceDisconnected(LiveCareMessage message) async {
    try {
      Device _device = Device.fromJson(message.data).copyWith(
        connected: false,
      );
      if (_devices[_device.id] == null) {
        _devices[_device.id] = _device;
      } else {
        _devices[_device.id]?.connected = false;
      }
      eventHandler.add(LiveDeviceDisconnected(_devices[_device.id]!));
    } catch (err) {
      Logger.error(err);
    }
  }

  static void dispose() async {
    _liveSubscription?.cancel();
    _liveSubscription = null;
  }
}
