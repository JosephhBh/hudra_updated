// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/remote/request.dart';
import 'package:hudra/view/bible_detals_page.dart';
import 'package:hudra/widgets/AppBars/holiday_prayer_appbar.dart';
import 'package:hudra/widgets/AppBars/rituals_appbar.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/bible/bible_item.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  // List<BibleObject> _listOfBibles = [];

  @override
  void initState() {
    super.initState();
    // loadBibleData();
  }

  // loadBibleData() async {
  //   try {
  //     RequestModel request = RequestModel();
  //     request.url += "CRUD/php_mysql/ReadData.php";
  //     request.body = <String, dynamic>{
  //       "tableName": "BibleEnglish",
  //     };
  //     var response = await http.post(
  //       Uri.parse(request.url),
  //       headers: request.headers,
  //       body: json.encode(request.body),
  //     );
  //     var decodedResponse = jsonDecode(response.body) as List;
  //     for (int i = 0; i < decodedResponse.length; i++) {
  //       BibleObject bibleObject = BibleObject();
  //       bibleObject.id = decodedResponse[i][0];
  //       bibleObject.itemName = decodedResponse[i][1];
  //       bibleObject.itemDesc = decodedResponse[i][3];
  //       bibleObject.isSelected = decodedResponse[i][4] == 0 ? false : true;
  //       bibleObject.createdAt = decodedResponse[i][5];
  //       bibleObject.createdBy = decodedResponse[i][6];
  //       _listOfBibles.add(bibleObject);
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print("Error loading data $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _back(),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: BibleData.listOfBibles.length,
              itemBuilder: (c, index) {
                return BibleItem(
                  bibleName: BibleData.listOfBibles[index].itemName!,
                  bibleNumber: BibleData.listOfBibles[index].number!,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BibleDetailsPage(
                                bibleObject: BibleData.listOfBibles[index],
                              )),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  _back() {
    Provider.of<ProviderGlobal>(context, listen: false).goBackAll();
  }
}

class BibleObject {
  String? itemId;
  String? number;
  String? itemName;
  dynamic itemDesc;
  int? isSelected;

  BibleObject({
    this.itemId,
    this.number,
    this.itemName,
    this.itemDesc,
    this.isSelected,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'number': number,
      'itemName': itemName,
      'itemDesc': itemDesc,
      'isSelected': isSelected,
    };
  }

  factory BibleObject.fromMap(Map<String, dynamic> map) {
    return BibleObject(
      itemId: map['itemId'] != null ? map['itemId'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      itemName: map['itemName'] != null ? map['itemName'] as String : null,
      itemDesc: map['itemDesc'] as dynamic,
      isSelected: map['isSelected'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BibleObject.fromJson(String source) =>
      BibleObject.fromMap(json.decode(source) as Map<String, dynamic>);
}
