import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/prayer_model.dart';
import 'package:hudra/remote/request.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PrayersData extends ChangeNotifier {
  static List<PrayerObject> _listOfPrayers = [];

  static List<PrayerObject> get listOfPrayers => _listOfPrayers;

  List<PrayerObject> _listOfPrayersByName = [];

  List<PrayerObject> get listOfPrayersByName => _listOfPrayersByName;

  List<PrayerObject> _listOfPrayersBySearch = [];

  List<PrayerObject> get listOfPrayersBySearch => _listOfPrayersBySearch;

  static String prayersQueriedAtKey = "prayersQueriedAt";

  PrayerObject _prayerObject = PrayerObject();

  PrayerObject get prayerObject => _prayerObject;

  static Future<void> loadPrayers() async {
    try {
      String language = GetStorageHelper().getPrayersLanguage();
      _listOfPrayers = [];
      String tableName = language == "English"
          ? "PrayersEnglish"
          : language == "عربي"
              ? "PrayersArabic"
              : "PrayersSyriac";
      String time = GetStorageHelper().getByKey(prayersQueriedAtKey) ?? "";
      bool shouldCallApi = false;

      /// Load all prayers without saving them
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
          PrayerObject prayerObject = PrayerObject();
          prayerObject.itemId = decodedResponse[i][0];
          prayerObject.itemName = decodedResponse[i][1];
          prayerObject.itemRelatedHoliday = decodedResponse[i][2];
          prayerObject.itemDesc = decodedResponse[i][3];
          prayerObject.isSyriac = decodedResponse[i][4];
          prayerObject.isChaldean = decodedResponse[i][5];
          prayerObject.week = decodedResponse[i][6];
          prayerObject.day = decodedResponse[i][7];
          prayerObject.prayerTime = decodedResponse[i][8];
          prayerObject.createdAt = decodedResponse[i][9];
          _listOfPrayers.add(prayerObject);
        }

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
        ///Get the prayers from db
        print("Loading prayers from local database");
        List listOfSavedBibles = await DatabaseHelper.queryPrayers(tableName);
        for (int i = 0; i < listOfSavedBibles.length; i++) {
          _listOfPrayers.add(PrayerObject(
            itemId: listOfSavedBibles[i]["itemId"],
            itemName: listOfSavedBibles[i]['itemName'],
            itemRelatedHoliday: listOfSavedBibles[i]['itemRelatedHoliday'],
            itemDesc: listOfSavedBibles[i]['itemDesc'],
            isSyriac: listOfSavedBibles[i]['isSyriac'],
            isChaldean: listOfSavedBibles[i]['isChaldean'],
            week: listOfSavedBibles[i]['week'],
            day: listOfSavedBibles[i]['day'],
            prayerTime: listOfSavedBibles[i]['prayerTime'],
            createdAt: listOfSavedBibles[i]['createdAt'],
          ));
        }
        return;
      }
      print("Getting prayers from server");
      if (!await checkInternetConnection()) {
        print("Loading prayers from local database no internet");
        List listOfSavedBibles = await DatabaseHelper.queryPrayers(tableName);
        for (int i = 0; i < listOfSavedBibles.length; i++) {
          _listOfPrayers.add(PrayerObject(
            itemId: listOfSavedBibles[i]["itemId"],
            itemName: listOfSavedBibles[i]['itemName'],
            itemRelatedHoliday: listOfSavedBibles[i]['itemRelatedHoliday'],
            itemDesc: listOfSavedBibles[i]['itemDesc'],
            isSyriac: listOfSavedBibles[i]['isSyriac'],
            isChaldean: listOfSavedBibles[i]['isChaldean'],
            week: listOfSavedBibles[i]['week'],
            day: listOfSavedBibles[i]['day'],
            prayerTime: listOfSavedBibles[i]['prayerTime'],
            createdAt: listOfSavedBibles[i]['createdAt'],
          ));
        }
        return;
      }

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
      print(response.body);
      GetStorageHelper()
          .setByKey(prayersQueriedAtKey, DateTime.now().toString());
      var decodedResponse = jsonDecode(response.body) as List;

      for (int i = 0; i < decodedResponse.length; i++) {
        PrayerObject prayerObject = PrayerObject();
        prayerObject.itemId = decodedResponse[i][0];
        prayerObject.itemName = decodedResponse[i][1];
        prayerObject.itemRelatedHoliday = decodedResponse[i][2];
        prayerObject.itemDesc = decodedResponse[i][3];
        prayerObject.isSyriac = decodedResponse[i][4];
        prayerObject.isChaldean = decodedResponse[i][5];
        prayerObject.week = decodedResponse[i][6];
        prayerObject.day = decodedResponse[i][7];
        prayerObject.prayerTime = decodedResponse[i][8];
        prayerObject.createdAt = decodedResponse[i][9];
        _listOfPrayers.add(prayerObject);
        await DatabaseHelper.insertPrayer(tableName, prayerObject);
      }
    } catch (e) {
      print("error loading prayers $e");
    }
  }

  loadHolidayByName(
      {required BuildContext context,
      required String holidayName,
      required String? condition}) async {
    try {
      // debugPrint("holidayPrayer $holidayName");
      _listOfPrayersByName = [];
      notifyListeners();
      String language = GetStorageHelper().getPrayersLanguage();
      String tableName = language == "English"
          ? "PrayersEnglish"
          : language == "عربي"
              ? "PrayersArabic"
              : "PrayersSyriac";

      /// Load holiday from server on web

      String fullCondition = "";

      if (condition != null) {
        fullCondition += condition;
      }

      if (condition == null) {
        fullCondition += "where `itemRelatedHoliday` = '$holidayName'";
      }

      bool isSyriac =
          Provider.of<ProviderChurch>(context, listen: false).churchName ==
              "Syriac";
      fullCondition +=
          " AND `isSyriac` = '${isSyriac ? 1 : 0}' ORDER BY createdAt DESC";

      debugPrint("fullCondition: $fullCondition");
      if (true) {
        // if (kIsWeb) {
        debugPrint("loading prayer by name $holidayName");
        RequestModel request = RequestModel();
        request.url += "CRUD/php_mysql/ReadData.php";
        request.body = <String, dynamic>{
          "tableName": tableName,
          "condition": fullCondition
        };
        var response = await http.post(
          Uri.parse(request.url),
          headers: request.headers,
          body: json.encode(request.body),
        );
        var decodedResponse = jsonDecode(response.body) as List;
        // print(decodedResponse);

        debugPrint(decodedResponse.toString());
        if (decodedResponse.isEmpty) {
          return _listOfPrayersByName;
        }

        for (int index = 0; index < decodedResponse.length; index++) {
          PrayerObject prayerObject = PrayerObject();
          prayerObject.itemId = decodedResponse[index][0];
          prayerObject.itemName = decodedResponse[index][1];
          prayerObject.itemRelatedHoliday = decodedResponse[index][2];
          prayerObject.itemDesc = decodedResponse[index][3];
          prayerObject.isSyriac = decodedResponse[index][4];
          prayerObject.isChaldean = decodedResponse[index][5];
          prayerObject.week = decodedResponse[index][6];
          prayerObject.day = decodedResponse[index][7];
          prayerObject.prayerTime = decodedResponse[index][8];
          prayerObject.createdAt = decodedResponse[index][9];
          _listOfPrayersByName.add(prayerObject);
        }
        notifyListeners();
        return _listOfPrayersByName;
      }
      if (!await checkInternetConnection()) {
        /// Check if exist in local database
        List listOfSavedHolidayPrayers =
            await DatabaseHelper.queryHolidyPrayerByName(
                tableName, holidayName, 1);
        // print("here $listOfSavedHolidayPrayers");
        if (listOfSavedHolidayPrayers.isNotEmpty) {
          _prayerObject =
              PrayerObject.fromJson(jsonEncode(listOfSavedHolidayPrayers[0]));
          _listOfPrayersByName.add(_prayerObject);
          notifyListeners();
          return _prayerObject;
        }
      }

      /// Check if exist in local database
      List listOfSavedHolidayPrayers =
          await DatabaseHelper.queryHolidyPrayerByName(
              tableName, holidayName, 1);
      // print("here1 $listOfSavedHolidayPrayers");
      if (listOfSavedHolidayPrayers.isNotEmpty) {
        // print("here2 $listOfSavedHolidayPrayers");
        _prayerObject =
            PrayerObject.fromJson(jsonEncode(listOfSavedHolidayPrayers[0]));
        _listOfPrayersByName.add(_prayerObject);
        notifyListeners();
        return _prayerObject;
      }
      // print("here3");
      RequestModel request = RequestModel();
      request.url += "CRUD/php_mysql/ReadData.php";
      request.body = <String, dynamic>{
        "tableName": tableName,
        "condition": fullCondition
      };
      var response = await http.post(
        Uri.parse(request.url),
        headers: request.headers,
        body: json.encode(request.body),
      );
      print(response.body);
      var decodedResponse = jsonDecode(response.body) as List;

      PrayerObject prayerObject = PrayerObject();
      prayerObject.itemId = decodedResponse[0][0];
      prayerObject.itemName = decodedResponse[0][1];
      prayerObject.itemRelatedHoliday = decodedResponse[0][2];
      prayerObject.itemDesc = decodedResponse[0][3];
      prayerObject.isSyriac = decodedResponse[0][4];
      prayerObject.isChaldean = decodedResponse[0][5];
      prayerObject.week = decodedResponse[0][6];
      prayerObject.day = decodedResponse[0][7];
      prayerObject.prayerTime = decodedResponse[0][8];
      prayerObject.createdAt = decodedResponse[0][9];
      _listOfPrayersByName.add(prayerObject);
      await DatabaseHelper.insertPrayer(tableName, prayerObject);
      notifyListeners();
      return;
    } catch (e) {
      print("error loading holoday prayer $e");
      return []; //PrayerObject();
    }
  }

  loadHolidayBySearch(
      {required BuildContext context, required String holidayNameLike}) async {
    try {
      debugPrint("holidayPrayer $holidayNameLike");
      _listOfPrayersBySearch = [];
      notifyListeners();
      String language = GetStorageHelper().getPrayersLanguage();
      String tableName = language == "English"
          ? "PrayersEnglish"
          : language == "عربي"
              ? "PrayersArabic"
              : "PrayersSyriac";

      /// Load holiday from server on web

      String fullCondition = "";

      // if (condition != null) {
      //   fullCondition += condition;
      // }
      //
      // if (condition == null) {
      fullCondition += "where `itemName` LIKE '%$holidayNameLike%'";
      // }

      bool isSyriac =
          Provider.of<ProviderChurch>(context, listen: false).churchName ==
              "Syriac";
      fullCondition +=
          " AND `isSyriac` = '${isSyriac ? 1 : 0}' ORDER BY createdAt DESC";

      debugPrint("fullCondition: $fullCondition");
      if (true) {
        // if (kIsWeb) {
        debugPrint("loading prayer by name $holidayNameLike");
        RequestModel request = RequestModel();
        request.url += "CRUD/php_mysql/ReadData.php";
        request.body = <String, dynamic>{
          "tableName": tableName,
          "condition": fullCondition
        };
        var response = await http.post(
          Uri.parse(request.url),
          headers: request.headers,
          body: json.encode(request.body),
        );
        var decodedResponse = jsonDecode(response.body) as List;
        // print(decodedResponse);

        print(decodedResponse);
        if (decodedResponse.isEmpty) {
          return _listOfPrayersBySearch;
        }

        for (int index = 0; index < decodedResponse.length; index++) {
          PrayerObject prayerObject = PrayerObject();
          prayerObject.itemId = decodedResponse[index][0];
          prayerObject.itemName = decodedResponse[index][1];
          prayerObject.itemRelatedHoliday = decodedResponse[index][2];
          prayerObject.itemDesc = decodedResponse[index][3];
          prayerObject.isSyriac = decodedResponse[index][4];
          prayerObject.isChaldean = decodedResponse[index][5];
          prayerObject.week = decodedResponse[index][6];
          prayerObject.day = decodedResponse[index][7];
          prayerObject.prayerTime = decodedResponse[index][8];
          prayerObject.createdAt = decodedResponse[index][9];
          _listOfPrayersBySearch.add(prayerObject);
        }
        notifyListeners();
        return _listOfPrayersBySearch;
      }
      if (!await checkInternetConnection()) {
        /// Check if exist in local database
        List listOfSavedHolidayPrayers =
            await DatabaseHelper.queryHolidyPrayerByName(
                tableName, holidayNameLike, 1);
        // print("here $listOfSavedHolidayPrayers");
        if (listOfSavedHolidayPrayers.isNotEmpty) {
          _prayerObject =
              PrayerObject.fromJson(jsonEncode(listOfSavedHolidayPrayers[0]));
          _listOfPrayersBySearch.add(_prayerObject);
          notifyListeners();
          return _prayerObject;
        }
      }

      /// Check if exist in local database
      List listOfSavedHolidayPrayers =
          await DatabaseHelper.queryHolidyPrayerByName(
              tableName, holidayNameLike, 1);
      // print("here1 $listOfSavedHolidayPrayers");
      if (listOfSavedHolidayPrayers.isNotEmpty) {
        // print("here2 $listOfSavedHolidayPrayers");
        _prayerObject =
            PrayerObject.fromJson(jsonEncode(listOfSavedHolidayPrayers[0]));
        _listOfPrayersBySearch.add(_prayerObject);
        notifyListeners();
        return _prayerObject;
      }
      // print("here3");
      RequestModel request = RequestModel();
      request.url += "CRUD/php_mysql/ReadData.php";
      request.body = <String, dynamic>{
        "tableName": tableName,
        "condition": fullCondition
      };
      var response = await http.post(
        Uri.parse(request.url),
        headers: request.headers,
        body: json.encode(request.body),
      );
      print(response.body);
      var decodedResponse = jsonDecode(response.body) as List;

      PrayerObject prayerObject = PrayerObject();
      prayerObject.itemId = decodedResponse[0][0];
      prayerObject.itemName = decodedResponse[0][1];
      prayerObject.itemRelatedHoliday = decodedResponse[0][2];
      prayerObject.itemDesc = decodedResponse[0][3];
      prayerObject.isSyriac = decodedResponse[0][4];
      prayerObject.isChaldean = decodedResponse[0][5];
      prayerObject.week = decodedResponse[0][6];
      prayerObject.day = decodedResponse[0][7];
      prayerObject.prayerTime = decodedResponse[0][8];
      prayerObject.createdAt = decodedResponse[0][9];
      _listOfPrayersBySearch.add(prayerObject);
      await DatabaseHelper.insertPrayer(tableName, prayerObject);
      notifyListeners();
      return;
    } catch (e) {
      print("error loading holoday prayer $e");
      return []; //PrayerObject();
    }
  }

// Future<PrayerObject> loadHolidayByName(String holidayPrayer) async {
//   try {
//     _prayerObject = PrayerObject();
//     notifyListeners();
//     String language = GetStorageHelper().getPrayersLanguage();
//     String tableName = language == "English"
//         ? "PrayersEnglish"
//         : language == "عربي"
//             ? "PrayersArabic"
//             : "PrayersSyriac";
//
//     /// Load holiday from server on web
//     if (kIsWeb) {
//       print("loading prayer by name ${holidayPrayer}");
//       RequestModel request = RequestModel();
//       request.url += "CRUD/php_mysql/ReadData.php";
//       request.body = <String, dynamic>{
//         "tableName": tableName,
//         "condition":
//             "where `itemRelatedHoliday` = '$holidayPrayer' AND `isSyriac` = '1'"
//       };
//       var response = await http.post(
//         Uri.parse(request.url),
//         headers: request.headers,
//         body: json.encode(request.body),
//       );
//       var decodedResponse = jsonDecode(response.body) as List;
//       print(decodedResponse);
//
//       if (decodedResponse.isEmpty) {
//         return _prayerObject;
//       }
//
//       PrayerObject prayerObject = PrayerObject();
//       prayerObject.itemId = decodedResponse[0][0];
//       prayerObject.itemName = decodedResponse[0][1];
//       prayerObject.itemRelatedHoliday = decodedResponse[0][2];
//       prayerObject.itemDesc = decodedResponse[0][3];
//       prayerObject.isSyriac = decodedResponse[0][4];
//       prayerObject.isChaldean = decodedResponse[0][5];
//       prayerObject.week = decodedResponse[0][6];
//       prayerObject.day = decodedResponse[0][7];
//       prayerObject.prayerTime = decodedResponse[0][8];
//       _prayerObject = prayerObject;
//       notifyListeners();
//       return _prayerObject;
//     }
//
//     /// Check if exist in local database
//     List listOfSavedHolidayPrayers =
//         await DatabaseHelper.queryHolidyPrayerByName(
//             tableName, holidayPrayer, 1);
//     print("here ${listOfSavedHolidayPrayers.length}");
//     if (listOfSavedHolidayPrayers.isNotEmpty) {
//       print("Holiday prayer from local db");
//       print(listOfSavedHolidayPrayers[0]["itemId"]);
//       _prayerObject =
//           PrayerObject.fromJson(jsonEncode(listOfSavedHolidayPrayers[0]));
//       notifyListeners();
//       return _prayerObject;
//     }
//     _prayerObject = PrayerObject();
//     notifyListeners();
//     print("No holiday prayer found");
//     return PrayerObject();
//
//     // print("Holiday prayer from server");
//     // RequestModel request = RequestModel();
//     // request.url += "CRUD/php_mysql/ReadData.php";
//     // request.body = <String, dynamic>{
//     //   "tableName": tableName,
//     //   "conditions":
//     //       "where `itemRelatedHoliday` = '$holidayPrayer' AND `isSyriac` = '1'"
//     // };
//     // var response = await http.post(
//     //   Uri.parse(request.url),
//     //   headers: request.headers,
//     //   body: json.encode(request.body),
//     // );
//     // var decodedResponse = jsonDecode(response.body) as List;
//
//     // PrayerObject prayerObject = PrayerObject();
//     // prayerObject.itemId = decodedResponse[i][0];
//     // prayerObject.itemName = decodedResponse[i][1];
//     // prayerObject.itemRelatedHoliday = decodedResponse[i][2];
//     // prayerObject.itemDesc = decodedResponse[i][3];
//     // prayerObject.isSyriac = decodedResponse[i][4];
//     // prayerObject.isChaldean = decodedResponse[i][5];
//     // prayerObject.week = decodedResponse[i][6];
//     // prayerObject.day = decodedResponse[i][7];
//     // prayerObject.prayerTime = decodedResponse[i][8];
//     // _listOfPrayers.add(prayerObject);
//     // await DatabaseHelper.insertPrayer(tableName, prayerObject);
//   } catch (e) {
//     print("error loading holoday prayer $e");
//     return PrayerObject();
//   }
// }
}
