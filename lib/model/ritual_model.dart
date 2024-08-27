import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RitualObject {
  String? itemId;
  String? itemName;
  dynamic itemDesc;
  int? isSyriac;
  int? isChaldean;
  String? createdAt;
  RitualObject({
    this.itemId,
    this.itemName,
    this.itemDesc,
    this.isSyriac,
    this.isChaldean,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'itemName': itemName,
      'itemDesc': itemDesc,
      'isSyriac': isSyriac,
      'isChaldean': isChaldean,
      'createdAt': createdAt,
    };
  }

  factory RitualObject.fromMap(Map<String, dynamic> map) {
    return RitualObject(
      itemId: map['itemId'] as String,
      itemName: map['itemName'] as String,
      itemDesc: map['itemDesc'] as String,
      isSyriac: map['isSyriac'] as int,
      isChaldean: map['isChaldean'] as int,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RitualObject.fromJson(String source) =>
      RitualObject.fromMap(json.decode(source) as Map<String, dynamic>);
}
