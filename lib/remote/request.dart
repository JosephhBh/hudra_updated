import 'package:flutter/material.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/utils/app_constant.dart';

class RequestModel {
  String url = '';
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};

  RequestModel() {
    url = AppConstant().apiUrl;
    headers = {};
    headers.putIfAbsent("Accept", () {
      return "application/json";
    });

    // _putLanguage(WidgetsBinding.instance.window.locale.languageCode);
  }

  // withAuth() {
  //   _putAccessToken(GetStorageHelper().accessToken());
  // }

  // _putAccessToken(String accessToken) {
  //   if (accessToken.isNotEmpty) {
  //     headers.putIfAbsent("Authorization", () {
  //       return "Bearer $accessToken";
  //     });
  //   }
  // }

  // _putLanguage(String language) {
  //   headers.putIfAbsent("Accept-Language", () {
  //     return language;
  //   });
  // }

  // withCountryCode() {
  //   _putCountryCode(GetStorageHelper().getCountryCode());
  // }

  // _putCountryCode(String code) {
  //   if (code.isNotEmpty) {
  //     headers.putIfAbsent("country-code", () {
  //       return code;
  //     });
  //   }
  // }
}
