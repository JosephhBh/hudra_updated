import 'dart:convert';

class PrayerModel {
  String prayerId = '';
  String prayerTitle = '';
  // dynamic? data;
  List<dynamic> prayerText = [];

  PrayerModel({
    required this.prayerId,
    required this.prayerTitle,
    required this.prayerText,
    // data,
  });

  PrayerModel.fromJson(Map<String, dynamic> json) {
    prayerId = (json['prayerId'] ?? '').toString();
    prayerTitle = (json['prayerTitle'] ?? '').toString();
    prayerText = json['prayerText'] ?? [];
  }

  PrayerModel.fromString(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    prayerId = (json['prayerId'] ?? '').toString();
    prayerTitle = (json['prayerTitle'] ?? '').toString();
    prayerText = json['prayerText'] ?? [];
  }

  PrayerModel.fromList(List<dynamic> data) {
    prayerId = (data[0] ?? '').toString();
    prayerTitle = (data[1] ?? '').toString();
    prayerText = json.decode(data[3] ?? "[]");
  }

  Map<String, dynamic> toJson() => {
        "prayerId": prayerId,
        "prayerTitle": prayerTitle,
        "prayerText": prayerText,
      };

  @override
  String toString() {
    return '{"prayerId":"$prayerId"'
        ',"prayerTitle":"${prayerTitle ?? ''}"}'
        ',"prayerText":"${prayerText ?? ''}"}'
        '}';
  }
}
