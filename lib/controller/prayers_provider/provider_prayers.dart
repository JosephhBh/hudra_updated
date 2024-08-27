import 'package:flutter/material.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Prayers/prayer_model.dart';
import 'package:hudra/remote/apis_model.dart';
import 'package:hudra/widgets/calendar_page/holiday_item.dart';
import 'package:hudra/widgets/holiday_prayer_page/holiday_prayer_item.dart';

class ProviderPrayers extends ChangeNotifier {
  List<HolidayPrayerItem> _holidayPrayerItemChildren = [];

  List<HolidayPrayerItem> get holidayPrayerItemChildren =>
      _holidayPrayerItemChildren;

  Future<List<HolidayPrayerItem>> loadPrayers({String? condition}) async {
    _holidayPrayerItemChildren = [];
    // notifyListeners();
    List<HolidayPrayerItem> holidayPrayerItemListTmp = [];
    List<PrayerModel> response =
        await APISModel().loadPrayers(condition: condition);
    // print("the response is $response");
    for (PrayerModel prayerModel in response) {
      holidayPrayerItemListTmp.add(HolidayPrayerItem(prayerModel: prayerModel));
    }

    _holidayPrayerItemChildren = holidayPrayerItemListTmp;
    notifyListeners();
    return holidayPrayerItemListTmp;
  }
}
