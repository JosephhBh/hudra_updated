import 'package:flutter/material.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Daily/saved_verse_model.dart';
import 'package:hudra/model/Daily/verse_container_model.dart';
import 'package:hudra/model/Prayers/prayer_model.dart';
import 'package:hudra/remote/apis_model.dart';
import 'package:hudra/widgets/calendar_page/holiday_item.dart';
import 'package:hudra/widgets/holiday_prayer_page/holiday_prayer_item.dart';
import 'package:hudra/widgets/home/verse_container.dart';
import 'package:hudra/widgets/saved_verses_page/saved_verses_item.dart';
import 'package:intl/intl.dart';

class ProviderSavedVerses extends ChangeNotifier {
  List<SavedVersesItem> _savedVersesChildren = <SavedVersesItem>[];

  List<SavedVersesItem> get savedVersesChildren => _savedVersesChildren;

  Future<void> loadSavedVerses() async {
    _savedVersesChildren.clear();
    List<Map<String, dynamic>> tmp =
        await DatabaseHelper.querySavedVersesByLang(
            GetStorageHelper().getLanguage());

    for (Map<String, dynamic> element in tmp) {
      _savedVersesChildren.add(SavedVersesItem(
        savedVerseModel: SavedVerseModel(
          itemId: element['itemId'],
          itemName: element['itemName'],
          itemReference: element['itemReference'],
          // itemDesc: element['itemDesc'],
          itemDescString: element['itemDescString'],
          itemLang: element['itemLang'],
        ),
      ));
    }
    notifyListeners();
  }

  // @override
  // void notifyListeners() {
  //   // TODO: implement notifyListeners
  //   super.notifyListeners();
  //
  // }
}
