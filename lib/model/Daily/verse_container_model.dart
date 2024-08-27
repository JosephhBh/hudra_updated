import 'dart:convert';

class VerseContainerModel {
  String itemId = '';
  String itemName = '';
  String itemReference = '';
  List<dynamic> itemDesc = [];
  String itemDescString = '';

  VerseContainerModel({
    required this.itemId,
    required this.itemName,
    required this.itemReference,
    required this.itemDesc,
    required this.itemDescString,
  });

  VerseContainerModel.fromJson(Map<String, dynamic> json) {
    itemId = (json['itemId'] ?? '').toString();
    itemName = (json['itemName'] ?? '').toString();
    itemReference = (json['itemReference'] ?? '').toString();
    itemDesc = jsonDecode(json['itemDesc']) ?? [];
    for (var element in jsonDecode(json['itemDesc']) ?? []) {
      itemDescString += element["insert"];
    }
  }

  VerseContainerModel.fromString(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    itemId = (json['itemId'] ?? '').toString();
    itemName = (json['itemName'] ?? '').toString();
    itemReference = (json['itemReference'] ?? '').toString();
    itemDesc = jsonDecode(json['itemDesc']) ?? [];
    for (var element in jsonDecode(json['itemDesc']) ?? []) {
      itemDescString += element["insert"];
    }
  }

  VerseContainerModel.fromList(List<dynamic> data) {
    itemId = (data[0] ?? '').toString();
    itemName = (data[2] ?? '').toString();
    itemReference = (data[3] ?? '').toString();
    itemDesc = jsonDecode(data[4]) ?? [];
    for (var element in jsonDecode(data[4]) ?? []) {
      itemDescString += element["insert"];
    }
  }

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "itemName": itemName,
        "itemReference": itemReference,
        "itemDesc": itemDesc,
        "itemDescString": itemDescString,
      };

  @override
  String toString() {
    return '{"itemId":"$itemId"'
        ',"itemName":"${itemName ?? ''}"}'
        ',"itemReference":"${itemReference ?? ''}"}'
        ',"itemDesc":"${itemDesc ?? ''}"}'
        ',"itemDescString":"${itemDescString ?? ''}"}'
        '}';
  }
}
