import 'package:flutter/material.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/locale/get_storage_helper.dart';

class ProviderTextSize extends ChangeNotifier {
  static const minTextSize = 0.8;
  static const maxTextSize = 2;
  double _textSize = 1.0;

  double get textSize => _textSize;

  void setInitTextSize() {
    try {
      if (
          // GetStorageHelper().getTextSize() != null &&
          GetStorageHelper().getTextSize() >= minTextSize &&
              GetStorageHelper().getTextSize() <= maxTextSize) {
        _textSize = GetStorageHelper().getTextSize();
        // notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setTextSize(double value) {
    if (_textSize != value.round().toDouble()) {
      _textSize = value;
      GetStorageHelper().setTextSize(sizeValue: value);
    }
    notifyListeners();
  }

  subTextSize() {
    if (_textSize > minTextSize) {
      _textSize--;
    }
    notifyListeners();
  }

  addTextSize() {
    if (_textSize < maxTextSize) {
      _textSize++;
    }
    notifyListeners();
  }
}
