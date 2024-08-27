import 'package:flutter/material.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/widgets/PopUp/show_dialog_choose_church.dart';

class ProviderChurch extends ChangeNotifier {
  String? _churchName; // Syriac  Chaldean

  String? get churchName => _churchName ?? (GetStorageHelper().getChurchName());

  void setInitChurch(BuildContext context) {
    try {
      if (GetStorageHelper().getChurchName() != 'Syriac' &&
          GetStorageHelper().getChurchName() != 'Chaldean') {
        showDialogChooseChurch(context);
        return;
      }
      _churchName = GetStorageHelper().getChurchName();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setChurchName(String value, bool withNotifyListeners) {
    if (_churchName != value) {
      _churchName = value;
      GetStorageHelper().setChurchName(churchNameValue: value);
    }
    if (withNotifyListeners) {
      notifyListeners();
    }
  }
}
