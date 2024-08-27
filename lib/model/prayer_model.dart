import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrayerObject {
  String? itemId;
  String? itemName;
  String? itemRelatedHoliday;
  dynamic? itemDesc;
  int? isSyriac;
  int? isChaldean;
  String? week;
  String? day;
  String? prayerTime;
  String? createdAt;
  PrayerObject({
    this.itemId,
    this.itemName,
    this.itemRelatedHoliday,
    this.itemDesc,
    this.isSyriac,
    this.isChaldean,
    this.week,
    this.day,
    this.prayerTime,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'itemName': itemName,
      'itemRelatedHoliday': itemRelatedHoliday,
      'itemDesc': itemDesc,
      'isSyriac': isSyriac,
      'isChaldean': isChaldean,
      'week': week,
      'day': day,
      'prayerTime': prayerTime,
      'createdAt': createdAt,
    };
  }

  factory PrayerObject.fromMap(Map<String, dynamic> map) {
    return PrayerObject(
      itemId: map['itemId'] as String,
      itemName: map['itemName'] as String,
      itemRelatedHoliday: map['itemRelatedHoliday'] as String,
      itemDesc: map['itemDesc'] as String,
      isSyriac: map['isSyriac'] as int,
      isChaldean: map['isChaldean'] as int,
      week: map['week'] as String,
      day: map['day'] as String,
      prayerTime: map['prayerTime'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrayerObject.fromJson(String source) =>
      PrayerObject.fromMap(json.decode(source) as Map<String, dynamic>);
}
