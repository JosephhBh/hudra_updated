import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:hudra/locale/get_storage_helper.dart';

class BookModeProvider extends ChangeNotifier {
  bool _isBookMode = GetStorageHelper().getBookMode();

  bool get isBookMode => _isBookMode;

  loadBookModeSettings() {
    if (kIsWeb) return;
    if (_isBookMode) {
      FullScreenWindow.setFullScreen(true);
    } else {
      FullScreenWindow.setFullScreen(false);
    }
  }

  setBookMode(bool value) {
    GetStorageHelper().setBookMode(bookModeValue: value);
    _isBookMode = value;
    notifyListeners();
  }

  enableBookMode() {
    FullScreenWindow.setFullScreen(true);
    GetStorageHelper().setBookMode(bookModeValue: true);
    _isBookMode = true;
    notifyListeners();
  }

  disableBookMode() {
    FullScreenWindow.setFullScreen(false);
    GetStorageHelper().setBookMode(bookModeValue: false);
    _isBookMode = false;
    notifyListeners();
  }
}
