import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hudra/model/Daily/verse_container_model.dart';
import 'package:hudra/model/Notifications/notification_model.dart';
import 'package:hudra/model/Prayers/prayer_model.dart';

import 'package:hudra/remote/services.dart';

class APISModel {
  Services? _services;
  static final APISModel _singleton = APISModel._internal();

  factory APISModel() {
    _singleton.setServices();
    return _singleton;
  }

  APISModel._internal();

  setServices() {
    _services = Services();
  }

  String? _manipulateResponse(http.Response response,
      {bool withMessage = false}) {
    switch (response.statusCode) {
      case 200:
        dynamic result = json.decode(response.body);
        if (withMessage) {
          String? message = result['message'];
          if (message != null) {
            debugPrint(message);
          }
        }

        return response.body;
      case 401:
        debugPrint("Unauthorized");
        break;
      case 422:
        dynamic result = json.decode(response.body);
        debugPrint("Incorrect Fields.");
        if (result['message'] != null) {
          debugPrint(result['message']);
        }

        if (result['errors'] != null) {
          debugPrint(result['errors']);
        }
        break;
      case 500:
        dynamic result = json.decode(response.body);
        if (result['message'] != null) {
          debugPrint(result['message']);
        } else {
          debugPrint("Error Occurred.");
        }
        break;

      default:
        debugPrint("Other Error.");
    }
    return null;
  }

  /// Verses (From Bible)
  Future<List<VerseContainerModel>> loadVerses({String? condition}) async {
    List<VerseContainerModel>? response =
        await _services!.loadVerses(condition: condition).then((response) {
      if (response == null) return null;

      String? result = _manipulateResponse(response);
      if (result == null) return null;

      List<VerseContainerModel> verseContainerModelList = [];
      for (var element in json.decode(result)) {
        verseContainerModelList.add(VerseContainerModel.fromList(element));
      }

      return verseContainerModelList;
    });

    if (response == null) return []; //null;
    return response;
  }

  /// Prayers
  Future<List<PrayerModel>> loadPrayers({String? condition}) async {
    List<PrayerModel>? response =
        await _services!.loadPrayers(condition: condition).then((response) {
      if (response == null) return null;

      String? result = _manipulateResponse(response);
      if (result == null) return null;

      List<PrayerModel> prayerModelList = [];
      for (var element in json.decode(result)) {
        prayerModelList.add(PrayerModel.fromList(element));
      }

      return prayerModelList;
    });

    if (response == null) return []; //null;
    return response;
  }

  /// Notifications
  Future<List<NotificationModel>> loadNotifications({String? condition}) async {
    List<NotificationModel>? response = await _services!
        .loadNotifications(condition: condition)
        .then((response) {
      if (response == null) return null;

      String? result = _manipulateResponse(response);
      if (result == null) return null;

      List<NotificationModel> notificationModelList = [];
      for (var element in json.decode(result)) {
        notificationModelList.add(NotificationModel.fromList(element));
      }

      return notificationModelList;
    });

    if (response == null) return []; //null;
    return response;
  }

  /// Login
// Future<LoginResponse?> login(String email, String password) async {
//   LoginResponse? response =
//       await _services!.login(email, password).then((response) {
//     if (response == null) return null;
//
//     String? result = _manipulateResponse(response);
//     // Get.back();
//     // switch (response.statusCode) {
//     //   case 200:
//     //     if (result == null) return null;
//     //     return GeneralResponse.fromStringLoginResponse(result);
//     //   case 403:
//     //     Get.to(() => ConfirmCodeScreen(email));
//     //     break;
//     //   case 405:
//     //     GeneralUtil().showMessageDialog(
//     //         "You have to validate account first. Do you want to resend link to your email?",
//     //         "Resend", () {
//     //       Get.back();
//     //       if (Platform.isAndroid) {
//     //         AndroidIntent intent = const AndroidIntent(
//     //           action: 'android.intent.action.MAIN',
//     //           category: 'android.intent.category.APP_EMAIL',
//     //         );
//     //         intent.launch().catchError((e) {});
//     //       } else if (Platform.isIOS) {
//     //         launchUrl(Uri.parse("message://")).catchError((e) {});
//     //       }
//     //     }, () {
//     //       GeneralUtil().showWaitingDialog();
//     //       resendverify(email).then((value) {
//     //         Get.back();
//     //         if (Platform.isAndroid) {
//     //           AndroidIntent intent = const AndroidIntent(
//     //             action: 'android.intent.action.MAIN',
//     //             category: 'android.intent.category.APP_EMAIL',
//     //           );
//     //           intent.launch().catchError((e) {});
//     //         } else if (Platform.isIOS) {
//     //           launchUrl(Uri.parse("message://")).catchError((e) {});
//     //         }
//     //       });
//     //     });
//     //     break;
//     //   case 406:
//     //     if (result == null) return null;
//     //     Fluttertoast.showToast(
//     //         msg: json.decode(result)['message'].toString(),
//     //         toastLength: Toast.LENGTH_SHORT);
//     //     break;
//     // }
//     return null;
//   });
//
//   if (response == null) return null;
//   return response;
// }
}
