import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/remote/request.dart';
import 'package:hudra/view/bible_page.dart';
import 'package:http/http.dart' as http;
import 'package:hudra/view/reference_page.dart';
import 'package:intl/intl.dart';

class BibleData {
  static List<BibleObject> _listOfBibles = [];
  static List<BibleObject> get listOfBibles => _listOfBibles;

  // static List<BibleObject> _listOfReferences = [];
  // static List<BibleObject> get listOfReferences => _listOfReferences;

  static Future<void> loadBibles() async {
    try {
      String language = GetStorageHelper().getPrayersLanguage();
      _listOfBibles = [];
      String tableName = language == "English"
          ? "BibleEnglish"
          : language == "عربي"
              ? "BibleArabic"
              : "BibleSyriac";
      String time = GetStorageHelper().getByKey("bibleQueriedAt") ?? "";
      bool shouldCallApi = false;

      /// Load mazmour data without saving
      if (kIsWeb) {
        RequestModel request = RequestModel();
        request.url += "CRUD/php_mysql/ReadData.php";
        request.body = <String, dynamic>{
          "tableName": tableName,
        };
        var response = await http.post(
          Uri.parse(request.url),
          headers: request.headers,
          body: json.encode(request.body),
        );
        var decodedResponse = jsonDecode(response.body) as List;
        for (int i = 0; i < decodedResponse.length; i++) {
          BibleObject bibleObject = BibleObject();
          bibleObject.itemId = decodedResponse[i][0];
          bibleObject.number = decodedResponse[i][1];
          bibleObject.itemName = decodedResponse[i][2];
          bibleObject.itemDesc = decodedResponse[i][4];
          bibleObject.isSelected = decodedResponse[i][5];
          _listOfBibles.add(bibleObject);
        }

        _listOfBibles.sort((a, b) {
          int numA = replaceArabicNumber(a.number.toString());
          int numB = replaceArabicNumber(b.number.toString());

          return numA.compareTo(numB);
        });
        return;
      }

      /// Check if the difference in time is >24 hours
      if (time.isNotEmpty) {
        DateTime parsedDateTime = DateFormat('y-MM-dd H:mm').parse(time);
        print(
            "difference ${DateTime.now().difference(parsedDateTime).inHours}");
        // if (DateTime.now().difference(parsedDateTime).inHours > 24) {
        shouldCallApi = true;
        // }
      } else {
        shouldCallApi = true;
      }
      if (!shouldCallApi) {
        ///Get the bibles from db
        // print("Loading bibles from local database");
        List listOfSavedBibles = await DatabaseHelper.queryBibles(tableName);
        for (int i = 0; i < listOfSavedBibles.length; i++) {
          _listOfBibles.add(BibleObject(
            itemId: listOfSavedBibles[i]["itemId"],
            number: listOfSavedBibles[i]["number"],
            itemName: listOfSavedBibles[i]['itemName'],
            itemDesc: listOfSavedBibles[i]['itemDesc'],
            isSelected: listOfSavedBibles[i]['isSelected'],
          ));
        }

        _listOfBibles.sort((a, b) {
          int numA = replaceArabicNumber(a.number.toString());
          int numB = replaceArabicNumber(b.number.toString());

          return numA.compareTo(numB);
        });
        return;
      }
      // print("Getting bibles from server");
      if (!await checkInternetConnection()) {
        // print("Loading bibles from local database since no internet available");
        List listOfSavedBibles = await DatabaseHelper.queryBibles(tableName);
        for (int i = 0; i < listOfSavedBibles.length; i++) {
          _listOfBibles.add(BibleObject(
            itemId: listOfSavedBibles[i]["itemId"],
            number: listOfSavedBibles[i]["number"],
            itemName: listOfSavedBibles[i]['itemName'],
            itemDesc: listOfSavedBibles[i]['itemDesc'],
            isSelected: listOfSavedBibles[i]['isSelected'],
          ));
        }

        _listOfBibles.sort((a, b) {
          int numA = replaceArabicNumber(a.number.toString());
          int numB = replaceArabicNumber(b.number.toString());

          return numA.compareTo(numB);
        });
        return;
      }
      ;

      RequestModel request = RequestModel();
      request.url += "CRUD/php_mysql/ReadData.php";
      request.body = <String, dynamic>{
        "tableName": tableName,
      };
      var response = await http.post(
        Uri.parse(request.url),
        headers: request.headers,
        body: json.encode(request.body),
      );
      GetStorageHelper().setByKey("bibleQueriedAt", DateTime.now().toString());
      var decodedResponse = jsonDecode(response.body) as List;

      for (int i = 0; i < decodedResponse.length; i++) {
        BibleObject bibleObject = BibleObject();
        bibleObject.itemId = decodedResponse[i][0];
        bibleObject.number = decodedResponse[i][1];
        bibleObject.itemName = decodedResponse[i][2];
        bibleObject.itemDesc = decodedResponse[i][4];
        bibleObject.isSelected = decodedResponse[i][5];
        _listOfBibles.add(bibleObject);
        await DatabaseHelper.insertBible(tableName, bibleObject);
      }
      _listOfBibles.sort((a, b) {
        int numA = replaceArabicNumber(a.number!);
        int numB = replaceArabicNumber(b.number!);

        return numA.compareTo(numB);
      });
    } catch (e) {
      print("error loading bibles $e");
    }
  }

  static int replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    if (english.contains(input[0])) return int.parse(input);
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return int.parse(input);
  }

  static Future<List<BibleObject>> loadBibleByNumbers(String params) async {
    try {
      List<BibleObject> _listOfReferences = [];
      String commaSeparatedNumbers = "";
      // Remove all spaces
      String cleanString = params.replaceAll(" ", "");
      // RegExp regExp = RegExp(
      //     r'(([\u0660-\u0669\u06F0-\u06F9]|[0-9]+)-?([\u0660-\u0669\u06F0-\u06F9]|[0-9]+)?)');
      RegExp regExp = RegExp(
          r'([\u0660-\u0669\u06F0-\u06F9]+|[0-9]+)(?:-([\u0660-\u0669\u06F0-\u06F9]+|[0-9]+))?');

      String extractedNumbers = "";

      if (regExp.hasMatch(cleanString)) {
        extractedNumbers = regExp.firstMatch(cleanString)!.group(0)!;
      }
      List<String> numbers = extractedNumbers.contains("-")
          ? extractedNumbers.split('-')
          : [extractedNumbers];
      String startStr = numbers[0];
      print(extractedNumbers);
      if (numbers.length == 1) {
        commaSeparatedNumbers = "\'$startStr'";
      } else {
        String endStr = numbers[1];

        int num1 = replaceArabicNumber(startStr);
        int num2 = replaceArabicNumber(endStr);
        if (num2 < num1) {
          return [];
        }
        List<String> englishList = [];
        for (int i = 0; i <= num2 - num1; i++) {
          englishList.add((num1 + i).toString());
        }
        // print("here1 $englishList");
        List<String> arabicList = [];
        for (int i = 0; i < englishList.length; i++) {
          arabicList.add(replaceEnglishNumber(englishList[i]).toString());
        }

        // String commaSeparatedNumbers = arabicList.join(',');
        commaSeparatedNumbers = isEnglish(startStr)
            ? englishList.map((number) => '\'$number\'').join(',')
            : arabicList.map((number) => '\'$number\'').join(',');
      }

      print(commaSeparatedNumbers);

      String language = GetStorageHelper().getPrayersLanguage();

      String tableName = language == "English"
          ? "BibleEnglish"
          : language == "عربي"
              ? "BibleArabic"
              : "BibleSyriac";
      if (kIsWeb) {
        RequestModel request = RequestModel();
        request.url += "CRUD/php_mysql/ReadData.php";
        request.body = <String, dynamic>{
          "tableName": tableName,
          "condition": "WHERE number IN ($commaSeparatedNumbers)"
        };
        var response = await http.post(
          Uri.parse(request.url),
          headers: request.headers,
          body: json.encode(request.body),
        );
        var decodedResponse = jsonDecode(response.body) as List;
        for (int i = 0; i < decodedResponse.length; i++) {
          BibleObject bibleObject = BibleObject();
          bibleObject.itemId = decodedResponse[i][0];
          bibleObject.number = decodedResponse[i][1];
          bibleObject.itemName = decodedResponse[i][2];
          bibleObject.itemDesc = decodedResponse[i][4];
          bibleObject.isSelected = decodedResponse[i][5];
          _listOfReferences.add(bibleObject);
        }

        _listOfReferences.sort((a, b) {
          int numA = replaceArabicNumber(a.number.toString());
          int numB = replaceArabicNumber(b.number.toString());

          return numA.compareTo(numB);
        });
        return _listOfReferences;
      }

      List listOfSavedBibles = await DatabaseHelper.queryBiblesByNumber(
          tableName, commaSeparatedNumbers);
      // print(listOfSavedBibles.length);
      for (int i = 0; i < listOfSavedBibles.length; i++) {
        _listOfReferences.add(BibleObject(
          itemId: listOfSavedBibles[i]["itemId"],
          number: listOfSavedBibles[i]["number"],
          itemName: listOfSavedBibles[i]['itemName'],
          itemDesc: listOfSavedBibles[i]['itemDesc'],
          isSelected: listOfSavedBibles[i]['isSelected'],
        ));
      }
      _listOfReferences.sort((a, b) {
        int numA = replaceArabicNumber(a.number.toString());
        int numB = replaceArabicNumber(b.number.toString());

        return numA.compareTo(numB);
      });
      return _listOfReferences;
    } catch (e) {
      print("loaddd error $e");
      return [];
    }
  }

  // static loadBibleByNumbers(String params) async {
  //   try {
  //     _listOfReferences = [];
  //     String commaSeparatedNumbers = "";
  //     // Remove all spaces
  //     String cleanString = params.replaceAll(" ", "");
  //     RegExp regExp =
  //         RegExp(r'(([\u0660-\u0669]|[0-9])\-?([\u0660-\u0669]|[0-9])?)');

  //     String extractedNumbers = "";

  //     if (regExp.hasMatch(cleanString)) {
  //       extractedNumbers = regExp.firstMatch(cleanString)!.group(1)!;
  //     }
  //     print(extractedNumbers);
  //     List<String> numbers = extractedNumbers.contains("-")
  //         ? extractedNumbers.split('-')
  //         : [extractedNumbers];
  //     String startStr = numbers[0];
  //     // print(params);
  //     if (numbers.length == 1) {
  //       commaSeparatedNumbers = "\'$startStr'";
  //     } else {
  //       String endStr = numbers[1];

  //       int num1 = replaceArabicNumber(startStr);
  //       int num2 = replaceArabicNumber(endStr);
  //       if (num2 < num1) {
  //         return [];
  //       }
  //       List<String> englishList = [];
  //       for (int i = 0; i < num2 - num1; i++) {
  //         englishList.add((num1 + i).toString());
  //       }
  //       List<String> arabicList = [];
  //       for (int i = 0; i < englishList.length; i++) {
  //         arabicList.add(replaceEnglishNumber(englishList[i]).toString());
  //       }

  //       // String commaSeparatedNumbers = arabicList.join(',');
  //       commaSeparatedNumbers = isEnglish(startStr)
  //           ? englishList.map((number) => '\'$number\'').join(',')
  //           : arabicList.map((number) => '\'$number\'').join(',');
  //     }

  //     String language = GetStorageHelper().getPrayersLanguage();

  //     String tableName = language == "English"
  //         ? "BibleEnglish"
  //         : language == "عربي"
  //             ? "BibleArabic"
  //             : "BibleSyriac";
  //     if (kIsWeb) {
  //       RequestModel request = RequestModel();
  //       request.url += "CRUD/php_mysql/ReadData.php";
  //       request.body = <String, dynamic>{
  //         "tableName": tableName,
  //         "condition": "WHERE number IN ($commaSeparatedNumbers)"
  //       };
  //       var response = await http.post(
  //         Uri.parse(request.url),
  //         headers: request.headers,
  //         body: json.encode(request.body),
  //       );
  //       var decodedResponse = jsonDecode(response.body) as List;
  //       for (int i = 0; i < decodedResponse.length; i++) {
  //         BibleObject bibleObject = BibleObject();
  //         bibleObject.itemId = decodedResponse[i][0];
  //         bibleObject.number = decodedResponse[i][1];
  //         bibleObject.itemName = decodedResponse[i][2];
  //         bibleObject.itemDesc = decodedResponse[i][4];
  //         bibleObject.isSelected = decodedResponse[i][5];
  //         _listOfReferences.add(bibleObject);
  //       }

  //       _listOfReferences.sort((a, b) {
  //         int numA = replaceArabicNumber(a.number.toString());
  //         int numB = replaceArabicNumber(b.number.toString());

  //         return numA.compareTo(numB);
  //       });
  //       return;
  //     }

  //     /// Load from local database
  //     if (!await checkInternetConnection()) {
  //       List listOfSavedBibles = await DatabaseHelper.queryBiblesByNumber(
  //           tableName, commaSeparatedNumbers);
  //       for (int i = 0; i < listOfSavedBibles.length; i++) {
  //         _listOfReferences.add(BibleObject(
  //           itemId: listOfSavedBibles[i]["itemId"],
  //           number: listOfSavedBibles[i]["number"],
  //           itemName: listOfSavedBibles[i]['itemName'],
  //           itemDesc: listOfSavedBibles[i]['itemDesc'],
  //           isSelected: listOfSavedBibles[i]['isSelected'],
  //         ));
  //       }
  //       _listOfReferences.sort((a, b) {
  //         int numA = replaceArabicNumber(a.number.toString());
  //         int numB = replaceArabicNumber(b.number.toString());

  //         return numA.compareTo(numB);
  //       });
  //       return;
  //     }
  //     RequestModel request = RequestModel();
  //     request.url += "CRUD/php_mysql/ReadData.php";
  //     request.body = <String, dynamic>{
  //       "tableName": tableName,
  //       "condition": "WHERE number IN ($commaSeparatedNumbers)"
  //     };
  //     var response = await http.post(
  //       Uri.parse(request.url),
  //       headers: request.headers,
  //       body: json.encode(request.body),
  //     );
  //     var decodedResponse = jsonDecode(response.body) as List;
  //     for (int i = 0; i < decodedResponse.length; i++) {
  //       BibleObject bibleObject = BibleObject();
  //       bibleObject.itemId = decodedResponse[i][0];
  //       bibleObject.number = decodedResponse[i][1];
  //       bibleObject.itemName = decodedResponse[i][2];
  //       bibleObject.itemDesc = decodedResponse[i][4];
  //       bibleObject.isSelected = decodedResponse[i][5];
  //       _listOfReferences.add(bibleObject);
  //       await DatabaseHelper.insertBible(tableName, bibleObject);
  //     }

  //     _listOfReferences.sort((a, b) {
  //       int numA = replaceArabicNumber(a.number.toString());
  //       int numB = replaceArabicNumber(b.number.toString());

  //       return numA.compareTo(numB);
  //     });
  //   } catch (e) {
  //     print("loaddd error $e");
  //   }
  // }

  static String replaceEnglishNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    // if (arabic.contains(input[0])) return int.parse(input);
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }

  static bool isEnglish(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    if (english.contains(input[0])) {
      return true;
    }
    return false;
  }
}
