// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReferenceModel {
  int? id;
  String? language;
  String? referenceType;
  String? name;
  dynamic? data;
  ReferenceModel({
    this.id,
    this.language,
    this.referenceType,
    this.name,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'language': language,
      'referenceType': referenceType,
      'name': name,
      'data': data,
    };
  }

  factory ReferenceModel.fromMap(Map<String, dynamic> map) {
    return ReferenceModel(
      id: map['id'] != null ? map['id'] as int : null,
      language: map['language'] != null ? map['language'] as String : null,
      referenceType:
          map['referenceType'] != null ? map['referenceType'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      data: map['data'] != null ? map['data'] as dynamic : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReferenceModel.fromJson(String source) =>
      ReferenceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
