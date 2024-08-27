import 'package:flutter/material.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/locale/get_storage_helper.dart';

class ProviderLanguage extends ChangeNotifier {
  Locale _currentLanguage = const Locale.fromSubtags(languageCode: 'en');

  Locale get currentLanguage => _currentLanguage;

  // Future<void> setLanguage() async {
  //   if (_currentLanguage.languageCode != 'en') {
  //     _currentLanguage = const Locale.fromSubtags(languageCode: 'en');
  //     await SessionManager().set('language', 'en');
  //     notifyListeners();
  //     return;
  //   }
  //   if (_currentLanguage.languageCode != 'ar') {
  //     _currentLanguage = const Locale.fromSubtags(languageCode: 'ar');
  //     await SessionManager().set('language', 'ar');
  //     notifyListeners();
  //     return;
  //   }
  // }

  void setLanguageEn() {
    if (GetStorageHelper().getLanguage() != 'en') {
      _currentLanguage = const Locale.fromSubtags(languageCode: 'en');
      GetStorageHelper().setLanguage(lang: "en");
      // await SessionManager().set('language', 'en');
      notifyListeners();
    }
  }

  void setLanguageAr() {
    if (GetStorageHelper().getLanguage() != 'ar') {
      _currentLanguage = const Locale.fromSubtags(languageCode: 'ar');
      GetStorageHelper().setLanguage(lang: "ar");
      // await SessionManager().set('language', 'ar');
      notifyListeners();
    }
  }

  void setLanguageSyr() {
    if (GetStorageHelper().getLanguage() != 'syr') {
      _currentLanguage = const Locale.fromSubtags(languageCode: 'ar');

      ///
      GetStorageHelper().setLanguage(lang: "syr");
      // await SessionManager().set('language', 'en');
      notifyListeners();
    }
  }

  void setInitLanguage() {
    try {
      if (GetStorageHelper().getLanguage() == "en") {
        _currentLanguage = const Locale.fromSubtags(languageCode: "en");
        // notifyListeners();
      }

      if (GetStorageHelper().getLanguage() == "ar") {
        _currentLanguage = const Locale.fromSubtags(languageCode: "ar");
        // notifyListeners();
      }

      if (GetStorageHelper().getLanguage() == "syr") {
        _currentLanguage = const Locale.fromSubtags(languageCode: "ar");

        ///
        // notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  FontWeight? setFontWeight(String itemLangCode) {
    return GetStorageHelper().getLanguage() == itemLangCode
        ? FontWeight.bold
        : null;
  }

  double setFontSize(String itemLangCode) {
    return GetStorageHelper().getLanguage() == itemLangCode ? 17.0 : 14.0;
  }
}
