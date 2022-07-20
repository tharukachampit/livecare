enum VitalType {
  unknown,
  ecg,
  heartRate,
  bp,
  temp,
  gl,
  spo2,
  fallDetection,
  ws,
  vAlert,
  fitness,
  spirometer,
  activity,
  sleep,
  feelingToday
}

extension VitalTypeExt on String {
  VitalType toVitalType() {
    return VitalType.values.firstWhere(
      (value) =>
          toLowerCase()
              .replaceAll(' ', '')
              .replaceAll('_', '')
              .replaceAll('monitor', '') ==
          value.name.toLowerCase(),
      orElse: () => VitalType.unknown,
    );
  }
}
