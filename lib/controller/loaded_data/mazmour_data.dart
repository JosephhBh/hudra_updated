import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/reference_model.dart';
import 'package:hudra/remote/request.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MazmourData {
  // static loadAllMazmourData() async {
  //   try {
  //     String time = GetStorageHelper().getByKey("mazmourQueriedAt") ?? "";
  //     bool shouldCallApi = false;

  //     /// Dont load mazmour data on web
  //     if (kIsWeb) {
  //       print("dont load mazmour data on web");
  //       return;
  //     }

  //     /// Check if the difference in time is >24 hours
  //     if (time.isNotEmpty) {
  //       DateTime parsedDateTime = DateFormat('y-MM-dd H:mm').parse(time);
  //       // if (DateTime.now().difference(parsedDateTime).inHours > 24) {
  //       shouldCallApi = true;
  //       // }
  //     } else {
  //       shouldCallApi = true;
  //     }
  //     if (!shouldCallApi) {
  //       print("Mazmour already exists");
  //       return;
  //     }

  //     if (shouldCallApi) {
  //       if (!await checkInternetConnection()) return;

  //       /// Load mazmour from server and save to database
  //       RequestModel request = RequestModel();
  //       request.url += "CRUD/php_mysql/ReadData.php";
  //       request.body = <String, dynamic>{
  //         "tableName": "Mazmour",
  //       };
  //       var response = await http.post(
  //         Uri.parse(request.url),
  //         headers: request.headers,
  //         body: json.encode(request.body),
  //       );
  //       GetStorageHelper()
  //           .setByKey("mazmourQueriedAt", DateTime.now().toString());
  //       var decodedResponse = jsonDecode(response.body) as List;
  //       for (int i = 0; i < decodedResponse.length; i++) {
  //         ReferenceModel referenceModel = ReferenceModel();
  //         referenceModel.id = decodedResponse[i][0];
  //         referenceModel.language = decodedResponse[i][1];
  //         referenceModel.referenceType = decodedResponse[i][2];
  //         referenceModel.name = decodedResponse[i][3];
  //         referenceModel.data = decodedResponse[i][4];
  //         await DatabaseHelper.insertMazmour(referenceModel);
  //       }
  //     }
  //   } catch (e) {
  //     print("error loading mazmour $e");
  //   }
  // }

  // static Future<ReferenceModel> loadMsazmourBydId(int mazmourId) async {
  //   try {
  //     /// Load mazmour withoud saving it to database
  //     if (kIsWeb) {
  //       RequestModel request = RequestModel();
  //       request.url += "CRUD/php_mysql/ReadData.php";
  //       request.body = <String, dynamic>{
  //         "tableName": "Mazmour",
  //         "condition": "WHERE id = '${mazmourId}'"
  //       };
  //       var response = await http.post(
  //         Uri.parse(request.url),
  //         headers: request.headers,
  //         body: json.encode(request.body),
  //       );
  //       var decodedResponse = jsonDecode(response.body) as List;
  //       ReferenceModel referenceModel = ReferenceModel();

  //       referenceModel.id = decodedResponse[0][0];
  //       referenceModel.language = decodedResponse[0][1];
  //       referenceModel.referenceType = decodedResponse[0][2];
  //       referenceModel.name = decodedResponse[0][3];
  //       referenceModel.data = decodedResponse[0][4];
  //       return referenceModel;
  //     }

  //     /// Check if exist in database
  //     var data = await DatabaseHelper.queryMazmourById(mazmourId);
  //     if (data.isNotEmpty) {
  //       print("Mazmour loaded from db");
  //       return ReferenceModel.fromJson(jsonEncode(data.first));
  //     }
  //     print("Mazmour loaded from server");

  //     if (!await checkInternetConnection()) return ReferenceModel();

  //     /// Load mazmour from server and save to database
  //     RequestModel request = RequestModel();
  //     request.url += "CRUD/php_mysql/ReadData.php";
  //     request.body = <String, dynamic>{
  //       "tableName": "Mazmour",
  //       "condition": "WHERE id = '${mazmourId}'"
  //     };
  //     var response = await http.post(
  //       Uri.parse(request.url),
  //       headers: request.headers,
  //       body: json.encode(request.body),
  //     );
  //     var decodedResponse = jsonDecode(response.body) as List;
  //     ReferenceModel referenceModel = ReferenceModel();

  //     referenceModel.id = decodedResponse[0][0];
  //     referenceModel.language = decodedResponse[0][1];
  //     referenceModel.referenceType = decodedResponse[0][2];
  //     referenceModel.name = decodedResponse[0][3];
  //     referenceModel.data = decodedResponse[0][4];
  //     await DatabaseHelper.insertMazmour(referenceModel);
  //     return referenceModel;
  //   } catch (e) {
  //     print("loadmazmoubyid error $e");
  //     return ReferenceModel();
  //   }
  // }
}

Future<bool> checkInternetConnection() async {
  bool _isAvailable = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      _isAvailable = true;
    }
  } catch (e) {
    _isAvailable = false;
  }
  return _isAvailable;
}
