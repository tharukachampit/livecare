// message class
import 'dart:convert';

import '../enums/enums.dart';

class LiveCareMessage {
  final LiveCareEventHandle event;
  final dynamic data;

  LiveCareMessage({required String event, this.data})
      : event = LiveCareEventHandle.values.singleWhere(
          (id) => id.name == event,
          orElse: () => LiveCareEventHandle.unknown,
        );

  factory LiveCareMessage.fromJsonString(String? jsonString) {
    dynamic json;
    print(jsonString);
    if (jsonString == null) {
      json = {};
    } else {
      json = jsonDecode(jsonString);
    }

    return LiveCareMessage.fromJson(json);
  }

  factory LiveCareMessage.fromJson(Map<String, dynamic> json) {
    return LiveCareMessage(
      event: json['event'],
      data: jsonDecode(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "event": event,
      "data": data,
    };
  }
}
