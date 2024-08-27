import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:meraky_store/model/login/login_response.dart';

class GetStorageHelper {
  static final GetStorageHelper _singleton = GetStorageHelper._internal();

  factory GetStorageHelper() {
    return _singleton;
  }

  GetStorageHelper._internal();

  GetStorage getStorage = GetStorage("localStorage");

  final _language = "language";
  final _pushNotifications = "pushNotifications";
  final _textSize = "textSize";
  final _themeMode = "themeMode";
  final _last10Search = "last10Search";
  final _prayersLanguage = "prayersLanguage";
  final _bookMode = "bookMode";
  final _churchName = "churchName";
  final _mazmourQueriedAt = "mazmourQueriedAt";

  T? getByKey<T>(key) {
    return getStorage.read(key);
  }

  void setByKey(key, value) {
    getStorage.write(key, value);
  }

  void deleteKey(key) {
    getStorage.remove(key);
  }

  /// Language
  String getLanguage() {
    return getStorage.read(_language) ?? "en";
  }

  String getLanguageInEnglish() {
    String switchValue = getStorage.read(_language) ?? "English";
    switch (switchValue) {
      case "en":
        return "English";
      case "ar":
        return "Arabic";
      // case "Française":
      //   return "French";
      case "syr":
        return "Syriac";

      default:
        return "English";
    }
  }

  void setLanguage({required String lang}) {
    getStorage.write(_language, lang);
  }

  /// Push Notifications
  bool getPushNotifications() {
    return getStorage.read(_pushNotifications) ?? true;
  }

  void setPushNotifications({required bool notificationValue}) {
    getStorage.write(_pushNotifications, notificationValue);
  }

  /// Text Size
  double getTextSize() {
    return getStorage.read(_textSize) ?? 14.0;
  }

  void setTextSize({required double sizeValue}) {
    getStorage.write(_textSize, sizeValue);
  }

  /// Theme Mode
  String getThemeMode() {
    return getStorage.read(_themeMode) ?? "dark";
  }

  void setThemeMode({required String themeMode}) {
    getStorage.write(_themeMode, themeMode);
  }

  /// Last 10 Search
  List<String> getLast10Search() {
    return getStorage.read(_last10Search) ?? [];
  }

  void setLast10Search({required List<String> last10SearchList}) {
    getStorage.write(_last10Search, last10SearchList);
  }

  /// Prayers Language
  String getPrayersLanguage() {
    return getStorage.read(_prayersLanguage) ?? "English";
  }

  String getPrayersLanguageInEnglish() {
    String switchValue = getStorage.read(_prayersLanguage) ?? "English";
    switch (switchValue) {
      case "English":
        return "English";
      case "عربي":
        return "Arabic";
      // case "Française":
      //   return "French";
      case "ܠܫܢܐ ܣܘܪܝܝܐ":
        return "Syriac";

      default:
        return "English";
    }
  }

  void setPrayersLanguage({required String lang}) {
    getStorage.write(_prayersLanguage, lang);
  }

  /// Book Mode
  bool getBookMode() {
    return getStorage.read(_bookMode) ?? false;
  }

  void setBookMode({required bool bookModeValue}) {
    getStorage.write(_bookMode, bookModeValue);
  }

  /// Church Name
  String? getChurchName() {
    return getStorage.read(_churchName);
  }

  void setChurchName({required String churchNameValue}) {
    getStorage.write(_churchName, churchNameValue);
  }

  void setMazmourQueriedAt(String time) {
    getStorage.write(_mazmourQueriedAt, time);
  }

  ///   ////////////////////////////////////////////////////////////////   ///
  /// First Entrance
// bool getFirstEntrance() {
//   return getStorage.read(_firstEntrance) ?? true;
// }
//
// void saveFirstEntrance() {
//   getStorage.write(_firstEntrance, false);
// }

  /// Reg Token
// String getRegToken() {
//   return getStorage.read(_regToken);
// }
//
// void saveRegToken(String token) {
//   getStorage.write(_regToken, token);
// }

  /// Country Code
// String getCountryCode() {
//   return (getStorage.read(_countryCode) ?? "gg").toUpperCase();
// }
//
// void saveCountryCode(String code) {
//   getStorage.write(_countryCode, code);
// }

  /// Access Token
// String accessToken() {
//   LoginResponse? response = getProfile();
//   if (response != null) return response.accessToken ?? "null";
//
//   return "null";
// }

  /// Profile
// LoginResponse? getProfile() {
//   return getStorage.read(_userResponse) != null
//       ? LoginResponse.fromString(getStorage.read(_userResponse))
//       : null;
// }

// void saveProfile(LoginResponse profile) {
//   getStorage.write(_userResponse, profile.toString());
// }

// void clearProfile() {
//   getStorage.remove(_userResponse);
// }
}
