import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/remote/request.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';

class Services {
  HttpWithMiddleware? _httpWithMiddleware;

  static final Services _singleton = Services._internal();

  factory Services() {
    return _singleton;
  }

  Services._internal() {
    _httpWithMiddleware = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: kReleaseMode ? LogLevel.NONE : LogLevel.BODY),
    ]);
  }

  Future<http.Response?> loadVerses({String? condition}) async {
    String language = GetStorageHelper().getPrayersLanguage();

    String tableName = language == "English"
        ? "BibleEnglish"
        : language == "عربي"
            ? "BibleArabic"
            : "BibleSyriac";

    RequestModel request = RequestModel();
    request.url += "CRUD/php_mysql/ReadData.php";
    request.body = <String, dynamic>{
      "tableName": tableName,
    };

    if (condition != null) {
      request.body["condition"] = condition;
    }

    // await request.withAuth();

    if (_httpWithMiddleware == null) {
      return null;
    }

    return await _httpWithMiddleware!.post(
      Uri.parse(request.url),
      headers: request.headers,
      body: json.encode(request.body),
    );
  }

  Future<http.Response?> loadPrayers({String? condition}) async {
    RequestModel request = RequestModel();
    request.url += "CRUD/php_mysql/ReadData.php";
    request.body = <String, dynamic>{
      "tableName": "Prayers${GetStorageHelper().getPrayersLanguageInEnglish()}",
    };

    if (condition != null) {
      request.body["condition"] = condition;
    }

    // await request.withAuth();

    if (_httpWithMiddleware == null) {
      return null;
    }
    print("request.body + ${request.body}");
    return await _httpWithMiddleware!.post(
      Uri.parse(request.url),
      headers: request.headers,
      body: json.encode(request.body),
    );
  }

  Future<http.Response?> loadNotifications({String? condition}) async {
    RequestModel request = RequestModel();
    request.url += "CRUD/php_mysql/ReadData.php";
    request.body = <String, dynamic>{
      "tableName": "Notifications",
    };

    if (condition != null) {
      request.body["condition"] = condition;
    }

    // await request.withAuth();

    if (_httpWithMiddleware == null) {
      return null;
    }
    return await _httpWithMiddleware!.post(
      Uri.parse(request.url),
      headers: request.headers,
      body: json.encode(request.body),
    );
  }
}
