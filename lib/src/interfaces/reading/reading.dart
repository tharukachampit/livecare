import 'dart:convert';

class Reading {
  Reading({
    this.oxygen = "0",
    this.pi = "0",
    this.pulse = "0",
    this.sys = "0",
    this.dia = "0",
    this.ahr = "0",
    this.ecg = "0",
    this.bgValue = "0",
    this.weight = "0",
    this.fev1 = "0",
    this.pef = "0",
    this.temperature = "0",
    this.location = "",
    this.steps = "0",
    this.kCal = "0",
    this.hr = "0",
    this.helpRequest = false,
    this.fallDetection = false,
    int? readAt,
  }) : readAt = readAt ?? DateTime.now().millisecondsSinceEpoch;

  String oxygen;
  String pi;
  String pulse;
  String sys;
  String dia;
  String ahr;
  String ecg;
  String bgValue;
  String weight;
  String fev1;
  String pef;
  String temperature;
  String location;
  String steps;
  String kCal;
  String hr;
  bool helpRequest;
  bool fallDetection;
  int readAt;

  Reading copyWith({
    String? oxygen,
    String? pi,
    String? pulse,
    String? sys,
    String? dia,
    String? ahr,
    String? ecg,
    String? bgValue,
    String? weight,
    String? fev1,
    String? pef,
    String? temperature,
    String? location,
    String? steps,
    String? kCal,
    String? hr,
    bool? helpRequest,
    bool? fallDetection,
    int? readAt,
  }) =>
      Reading(
        oxygen: oxygen ?? this.oxygen,
        pi: pi ?? this.pi,
        pulse: pulse ?? this.pulse,
        sys: sys ?? this.sys,
        dia: dia ?? this.dia,
        ahr: ahr ?? this.ahr,
        ecg: ecg ?? this.ecg,
        bgValue: bgValue ?? this.bgValue,
        weight: weight ?? this.weight,
        fev1: fev1 ?? this.fev1,
        pef: pef ?? this.pef,
        temperature: temperature ?? this.temperature,
        location: location ?? this.location,
        steps: steps ?? this.steps,
        kCal: kCal ?? this.kCal,
        hr: hr ?? this.hr,
        helpRequest: helpRequest ?? this.helpRequest,
        fallDetection: fallDetection ?? this.fallDetection,
        readAt: readAt ?? this.readAt,
      );

  factory Reading.fromRawJson(String? str) {
    if (str == null || str.isEmpty) {
      return Reading();
    }
    Reading read = Reading.fromJson(json.decode(str));
    return read;
  }

  String toRawJson() => json.encode(toJson());

  factory Reading.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Reading();
    }
    return Reading(
      oxygen: json["oxygen"] ?? '0',
      pi: json["pi"] ?? '0',
      pulse: json["pulse"] ?? '0',
      sys: json["sys"] ?? '0',
      dia: json["dia"] ?? '0',
      ahr: json["ahr"] ?? '0',
      ecg: json["ecg"] ?? '0',
      bgValue: json["bgValue"] ?? '0',
      weight: json["weight"] ?? '0',
      fev1: json["fev1"] ?? '0',
      pef: json["pef"] ?? '0',
      temperature: json["temperature"] ?? '0',
      location: json["location"] ?? "",
      steps: json["steps"] ?? '0',
      kCal: json["kCal"] ?? '0',
      hr: json["hr"] ?? '0',
      helpRequest: json["help_request"] ?? false,
      fallDetection: json["fall_detection"] ?? false,
      readAt: json["readAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "readAt": readAt,
        "oxygen": oxygen,
        "pi": pi,
        "pulse": pulse,
        "sys": sys,
        "dia": dia,
        "ahr": ahr,
        "ecg": ecg,
        "bgValue": bgValue,
        "weight": weight,
        "fev1": fev1,
        "pef": pef,
        "temperature": temperature,
        "location": location,
        "steps": steps,
        "kCal": kCal,
        "hr": hr,
        "help_request": helpRequest,
        "fall_detection": fallDetection,
      };
}
