library livecare;

import 'dart:async';

import 'package:flutter/services.dart';

import 'events.dart';

const MethodChannel platform = MethodChannel("com.plugin.live_care/platform");
const EventChannel receiver = EventChannel("com.plugin.live_care/stream");

final StreamController<LiveCareEvent> eventHandler =
    StreamController<LiveCareEvent>.broadcast();
