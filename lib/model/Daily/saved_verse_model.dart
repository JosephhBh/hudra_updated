import 'dart:convert';

class SavedVerseModel {
  String itemId = '';
  String itemName = '';
  String itemReference = '';
  // List<dynamic> itemDesc = [];
  String itemDescString = '';
  String itemLang = '';

  SavedVerseModel({
    required this.itemId,
    required this.itemName,
    required this.itemReference,
    // required this.itemDesc,
    required this.itemDescString,
    required this.itemLang,
  });


  SavedVerseModel.fromJson(Map<String, dynamic> json) {
    itemId = (json['itemId'] ?? '').toString();
    itemName = (json['itemName'] ?? '').toString();
    itemReference = (json['itemReference'] ?? '').toString();
    itemLang = (json['itemLang'] ?? '').toString();
    // itemDesc = jsonDecode(json['itemDesc']) ?? [];
    for (var element in jsonDecode(json['itemDesc']) ?? []) {
      itemDescString += element["insert"];
    }
  }

  SavedVerseModel.fromString(String data) {
    Map<String, dynamic> json = jsonDecode(data);
    itemId = (json['itemId'] ?? '').toString();
    itemName = (json['itemName'] ?? '').toString();
    itemReference = (json['itemReference'] ?? '').toString();
    itemLang = (json['itemLang'] ?? '').toString();
    // itemDesc = jsonDecode(json['itemDesc']) ?? [];
    for (var element in jsonDecode(json['itemDesc']) ?? []) {
      itemDescString += element["insert"];
    }
  }

  SavedVerseModel.fromList(List<dynamic> data) {
    itemId = (data[0] ?? '').toString();
    itemName = (data[1] ?? '').toString();
    itemReference = (data[2] ?? '').toString();
    itemLang = (data[3] ?? '').toString();
    // itemDesc = jsonDecode(data[3]) ?? [];
    // for (var element in jsonDecode(data[3]) ?? []) {
    //   itemDescString += element["insert"];
    // }
  }

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "itemName": itemName,
    "itemReference": itemReference,
    // "itemDesc": itemDesc,
    "itemDescString": itemDescString,
    "itemLang": itemLang,
  };

  @override
  String toString() {
    return '{"itemId":"$itemId"'
        ',"itemName":"${itemName ?? ''}"}'
        ',"itemReference":"${itemReference ?? ''}"}'
        // ',"itemDesc":"${itemDesc ?? ''}"}'
        ',"itemDescString":"${itemDescString ?? ''}"}'
        ',"itemLang":"${itemLang ?? ''}"}'
        '}';
  }
}
