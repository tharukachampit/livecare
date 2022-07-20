import '../../../livecare.dart';
import '../reading/reading.dart';

class Device {
  String id;

  String name;

  VitalType type;

  bool connected;

  Reading latestReading;

  DateTime? lastReadAt;

  Device({
    required this.id,
    required this.name,
    required this.type,
    this.connected = false,
    Reading? latestReading,
    this.lastReadAt,
  }) : latestReading = latestReading ?? Reading();

  factory Device.fromJson(Map<String, dynamic> json) {
    VitalType _type = (json['device'] ?? '').toString().toVitalType();
    Reading _read = Reading.fromRawJson(json['data']);
    return Device(
      id: "${_type.name}_${json['deviceId']}",
      name: json['deviceId'],
      type: _type,
      lastReadAt: DateTime.now(),
      latestReading: _read,
    );
  }

  Device copyWith({
    String? id,
    String? name,
    VitalType? type,
    bool? connected,
    Reading? latestReading,
    DateTime? lastReadAt,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      latestReading: latestReading ?? this.latestReading,
      connected: connected ?? this.connected,
    );
  }
}
