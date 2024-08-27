import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/data/data.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Daily/verse_container_model.dart';
import 'package:hudra/remote/apis_model.dart';
import 'package:hudra/widgets/calendar_page/holiday_item.dart';
import 'package:hudra/widgets/home/verse_container.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/utils/date_utils.dart';
import 'package:provider/provider.dart';

class ProviderDaily extends ChangeNotifier {
  // bool _isEidElSalibEarly = false;
  // bool get isEidElSalibEarly => _isEidElSalibEarly;

  final Map<int, List<HolidayItem>> _holidays = {};

  Map<int, bool> _isEidElSalibEarly = {};
  Map<int, bool> get isEidElSalibEarly => _isEidElSalibEarly;

  Map<int, bool> _removeSummber7 = {};
  Map<int, bool> get removeSummber7 => _removeSummber7;

  List<VerseContainer> _verseContainerChildren = <VerseContainer>[];

  List<VerseContainer> get verseContainerChildren => _verseContainerChildren;

  Map<int, List<HolidayItem>> get holidays => _holidays;

  Future<List<VerseContainer>> loadDailyVerses(
      {String? condition, required bool isWeb}) async {
    _verseContainerChildren = [];
    // notifyListeners();Ò
    List<VerseContainer> verseContainerListTmp = [];

    if (kIsWeb) {
      List<VerseContainerModel> response =
          await APISModel().loadVerses(condition: condition);

      for (VerseContainerModel verseContainerModel in response) {
        verseContainerListTmp.add(VerseContainer(
            verseContainerModel: verseContainerModel,
            isWeb: isWeb,
            onTap: () => notifyListeners()));
      }

      if (verseContainerListTmp.isEmpty) {
        verseContainerListTmp.add(
          VerseContainer(
              verseContainerModel: VerseContainerModel(
                itemId: '',
                itemName: '',
                itemReference: '',
                itemDesc: [],
                itemDescString: '',
                // getDeskString([
                //   {"insert": "Empty"},
                //   {"insert": "\n"}
                // ],)
              ),
              isWeb: isWeb,
              onTap: () => notifyListeners()),
        );
      }

      _verseContainerChildren = verseContainerListTmp;
      notifyListeners();
      return verseContainerListTmp;
    }

    if (!await checkInternetConnection()) {
      /// Try to load from saved bibles
      var data = await DatabaseHelper.queryDailyVerses(
          "Bible${GetStorageHelper().getLanguageInEnglish()}");
      if (data.isEmpty) {
        verseContainerListTmp.add(
          VerseContainer(
              verseContainerModel: VerseContainerModel(
                itemId: '',
                itemName: '',
                itemReference: '',
                itemDesc: [],
                itemDescString: '',
                // getDeskString([
                //   {"insert": "Empty"},
                //   {"insert": "\n"}
                // ],)
              ),
              isWeb: isWeb,
              onTap: () => notifyListeners()),
        );
        _verseContainerChildren = verseContainerListTmp;
        notifyListeners();
        return verseContainerListTmp;
      }
      List<VerseContainerModel> loadedData = [];
      for (int i = 0; i < data.length; i++) {
        // print("loading from local");
        loadedData.add(VerseContainerModel.fromJson(data[i]));
      }

      for (VerseContainerModel verseContainerModel in loadedData) {
        verseContainerListTmp.add(VerseContainer(
            verseContainerModel: verseContainerModel,
            isWeb: isWeb,
            onTap: () => notifyListeners()));
      }
      _verseContainerChildren = verseContainerListTmp;
      notifyListeners();
      return verseContainerListTmp;
    }
    List<VerseContainerModel> response =
        await APISModel().loadVerses(condition: condition);

    for (VerseContainerModel verseContainerModel in response) {
      verseContainerListTmp.add(VerseContainer(
          verseContainerModel: verseContainerModel,
          isWeb: isWeb,
          onTap: () => notifyListeners()));
    }

    if (verseContainerListTmp.isEmpty) {
      verseContainerListTmp.add(
        VerseContainer(
            verseContainerModel: VerseContainerModel(
              itemId: '',
              itemName: '',
              itemReference: '',
              itemDesc: [],
              itemDescString: '',
              // getDeskString([
              //   {"insert": "Empty"},
              //   {"insert": "\n"}
              // ],)
            ),
            isWeb: isWeb,
            onTap: () => notifyListeners()),
      );
    }

    _verseContainerChildren = verseContainerListTmp;
    notifyListeners();
    return verseContainerListTmp;
  }

  String? getHolidayOfToday(
      {required BuildContext context, required bool isWeb}) {
    String? result;
    DateTime date = DateTime.now();

    HolidayItem? holidayItem =
        _initHolidaysHome(context: context, date: date, isWeb: isWeb);
    if (holidayItem != null) {
      result = holidayItem.holidayName;
    }

    return result;
  }

  HolidayItem? _initHolidaysHome(
      {required BuildContext context,
      required DateTime date,
      required bool isWeb}) {
    calculateHolidays(context: context, date: date, isWeb: isWeb);
    List<HolidayItem> holidaysTMP = [];
    if (_holidays.containsKey(date.year)) {
      holidaysTMP.addAll(_holidays[date.year]!
          .where((element) => element.date.isSameDay(date)));
    }
    if (_holidays.containsKey(date.year - 1)) {
      holidaysTMP.addAll(_holidays[date.year - 1]!
          .where((element) => element.date.isSameDay(date)));
    }
    if (_holidays.containsKey(date.year + 1)) {
      holidaysTMP.addAll(_holidays[date.year + 1]!
          .where((element) => element.date.isSameDay(date)));
    }
    if (holidaysTMP.isNotEmpty) {
      int? isSebou3Int = isSebou3(holidayRelated: holidaysTMP[0].holidayName);

      // if (isSebou3Int == 3) {
      //   return holidaysTMP.isNotEmpty ? holidaysTMP[0] : null;
      // }

      if (isSebou3Int != null) {
        HolidayItem? tmp = checkSubHoliday(context, date, isWeb);
        if (tmp != null) {
          holidaysTMP[0].holidayNamePriority = tmp.holidayName;
          // holidaysTMP[0].week = tmp.week;
          // holidaysTMP[0].day = tmp.day;
        }
      } else {
        HolidayItem? tmp = checkSubHoliday(context, date, isWeb);

        if (tmp != null) {
          holidaysTMP.add(tmp);
        }
      }
    }
    if (holidaysTMP.isEmpty) {
      HolidayItem? tmp = checkSubHoliday(context, date, isWeb);

      if (tmp != null) {
        holidaysTMP.add(tmp);
      }
    }

    return holidaysTMP.isNotEmpty ? holidaysTMP[0] : null;
  }

  void calculateHolidays(
      {required BuildContext context,
      required DateTime date,
      required bool isWeb}) {
    // _isLoading = true;
    int year = date.year;
    if (!_holidays.containsKey(year)) {
      debugPrint('calculateHolidays');
      Map<String, DateTime> holidays =
          GlobalProvider2().getAllResults(context: context, currentYear: year);
      List<HolidayItem> listHolidayItemTMP = [];
      holidays.forEach((key, value) {
        // if (value.year == date.year) {
        listHolidayItemTMP.add(HolidayItem(
          holidayName: key,
          holidayNameOnly: key,
          week: null,
          day: null,
          date: value,
          isWeb: isWeb,
        ));
        // }
      });
      _holidays[year] = listHolidayItemTMP;
    }

    int yearMinusOne = year - 1;
    if (!_holidays.containsKey(yearMinusOne)) {
      debugPrint('calculateHolidays');
      Map<String, DateTime> holidays = GlobalProvider2()
          .getAllResults(context: context, currentYear: yearMinusOne);
      List<HolidayItem> listHolidayItemTMP = [];
      holidays.forEach((key, value) {
        // if (value.year == date.year) {
        listHolidayItemTMP.add(HolidayItem(
          holidayName: key,
          holidayNameOnly: key,
          week: null,
          day: null,
          date: value,
          isWeb: isWeb,
        ));
        // }
      });
      _holidays[yearMinusOne] = listHolidayItemTMP;
    }
    int yearPlusOne = year + 1;
    if (!_holidays.containsKey(yearPlusOne)) {
      debugPrint('calculateHolidays');
      Map<String, DateTime> holidays = GlobalProvider2()
          .getAllResults(context: context, currentYear: yearPlusOne);
      List<HolidayItem> listHolidayItemTMP = [];
      holidays.forEach((key, value) {
        // if (value.year == date.year) {
        listHolidayItemTMP.add(HolidayItem(
          holidayName: key,
          holidayNameOnly: key,
          week: null,
          day: null,
          date: value,
          isWeb: isWeb,
        ));
        // }
      });
      _holidays[yearPlusOne] = listHolidayItemTMP;
    }
    // _isLoading = false;
  }

  HolidayItem? checkSubHoliday(
      BuildContext context, DateTime date, bool isWeb) {
    String? holidayItemTMP;
    int count = 0;
    String currentLanguage = GetStorageHelper().getLanguage();
    int date13or14 = 14;
    if (Provider.of<ProviderChurch>(context, listen: false).churchName ==
        "Syriac") {
      date13or14 = 13;
    }
    // printStatus("here1");
    checkIfEidElSalibIsEarly(date, date13or14);
    // print("here2");
    // print("checking sub holidays");
    // print(Provider.of<GlobalProvider2>(context, listen: false)
    //     .somElBa3outh1String);
    // print(Provider.of<GlobalProvider2>(context, listen: false)
    //     .somElBa3outh2String);
    // print(Provider.of<GlobalProvider2>(context, listen: false)
    //     .somElBa3outh3String);
    //if (_checkIsHoliday(date)) {
    // return null;
    // bool _isEidElSalibEarly = false;

    List<DateTime> _listOfBaouth = [];
    String baouth1 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh1String;
    String baouth2 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh2String;
    String baouth3 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh3String;
    // print(baouth1);
    // print(baouth2);
    // print(baouth3);
    // print(baouth1);
    DateFormat df = DateFormat("dd-MMMM-yyyy");
    if (baouth1 != "") {
      DateTime d1 = df.parse(baouth1);
      _listOfBaouth.add(d1);
    }
    if (baouth2 != "") {
      DateTime d2 = df.parse(baouth2);
      _listOfBaouth.add(d2);
    }
    ;
    if (baouth3 != "") {
      DateTime d3 = df.parse(baouth3);
      _listOfBaouth.add(d3);
    }

    // print("the length ${_listOfBaouth.length}");
    // bool isBaouth = false;
    // for (DateTime d in _listOfBaouth) {
    //   if (d.year == date.year && d.month == date.month && d.day == date.day) {
    //     isBaouth = true;
    //     break;
    //   }
    // }
    // if (isBaouth) return null;

    if (_holidays.containsKey(date.year)) {
      /// BlackList
      List<String> blackListHolidaysString = [
        holidaysNames[11][currentLanguage],
        holidaysNames[12][currentLanguage],
        holidaysNames[13][currentLanguage],
        holidaysNames[14][currentLanguage],
        holidaysNames[15][currentLanguage],
        holidaysNames[16][currentLanguage],
        holidaysNames[17][currentLanguage],
        holidaysNames[18][currentLanguage],
        holidaysNames[19][currentLanguage],
        holidaysNames[64][currentLanguage]
      ];
      List<DateTime?> blackListHolidays = [];

      for (var element in _holidays[date.year]!) {
        if (blackListHolidaysString.contains(element.holidayName)) {
          blackListHolidays.add(DateTime(
              element.date.year, element.date.month, element.date.day));
        }
      }

      if (blackListHolidays
          .contains(DateTime(date.year, date.month, date.day))) {
        return null;
      }

      ///

      /// 0-2 -> START->2  && 1->END
      if (
          //START->2
          ((date.isAfter(DateTime(date.year, 1, 1)) ||
                      date.isAtSameMomentAs(DateTime(date.year, 1, 1))) &&
                  date.isBefore(_holidays[date.year]![2]
                      .date
                      .subtract(const Duration(days: 1)))) ||
              //1->END
              ((date.isAfter(_holidays[date.year]![1].date) ||
                      date.isAtSameMomentAs(_holidays[date.year]![1].date)) &&
                  (date.isBefore(DateTime(date.year, 12, 31)) ||
                      date.isAtSameMomentAs(DateTime(date.year, 12, 31))))) {
        DateTime firstSundayAfter1 = findNthDayAfter(
            startDate: DateTime(date.year, 12, 25), x: 1, dayName: 'Sunday');
        if (date.isAfter(_holidays[date.year]![0].date) ||
            date.isAtSameMomentAs(_holidays[date.year]![0].date)) {
          count = date.difference(_holidays[date.year]![0].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![0].holidayName;
          if (date.isBefore(firstSundayAfter1) ||
              date.isAtSameMomentAs(firstSundayAfter1)) {
            count = date.difference(_holidays[date.year]![1].date).inDays.abs();
            holidayItemTMP = _holidays[date.year]![1].holidayName;
          }
        } else if (date.isAfter(DateTime(date.year, 1, 1)) ||
            date.isAtSameMomentAs(DateTime(date.year, 1, 1))) {
          count =
              date.difference(_holidays[date.year - 1]![0].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![0].holidayName;
        } else {
          count = date.difference(_holidays[date.year]![1].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![1].holidayName;
        }
      }

      /// 2-3
      if ((date.isAfter(_holidays[date.year]![2].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![2].date)) &&
          date.isBefore(_holidays[date.year]![3].date)) {
        // remove sub holiday from deneh friday
        count = date.difference(_holidays[date.year]![2].date).inDays.abs();
        holidayItemTMP = _holidays[date.year]![2].holidayName;
      }

      /// 3-4
      if ((date.isAfter(_holidays[date.year]![3].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![3].date)) &&
          date.isBefore(_holidays[date.year]![4].date)) {
        count = date.difference(_holidays[date.year]![3].date).inDays.abs();
        holidayItemTMP = _holidays[date.year]![3].holidayName;
      }

      /// 4-5
      if ((date.isAfter(_holidays[date.year]![4].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![4].date)) &&
          date.isBefore(_holidays[date.year]![5].date)) {
        count = date.difference(_holidays[date.year]![4].date).inDays.abs();
        holidayItemTMP = _holidays[date.year]![4].holidayName;
      }

      /// 5-6
      if ((date.isAfter(_holidays[date.year]![5].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![5].date)) &&
          date.isBefore(_holidays[date.year]![6].date)) {
        count = date.difference(_holidays[date.year]![5].date).inDays.abs();
        holidayItemTMP = _holidays[date.year]![5].holidayName;
      }

      int difference1 = DateTime(date.year, 9, date13or14)
              .difference(_holidays[date.year]![7].date)
              .inDays
              .abs() +
          1;
      // print("here1 : $difference1");

      /// 6-7
      if ((date.isAfter(_holidays[date.year]![6].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![6].date)) &&
          date.isBefore(_holidays[date.year]![7].date)) {
        count = date.difference(_holidays[date.year]![6].date).inDays.abs();
        holidayItemTMP = _holidays[date.year]![6].holidayName;
        // print("here2 : $difference1");
        // count = count - 7;
        // int diff3 = _holidays[date.year]![6]
        //     .date
        //     .difference(_holidays[date.year]![7].date)
        //     .inDays
        //     .abs();
        // print("summer diff : $diff3 - $difference1");

        // if (difference1 < 7) {
        //   // print("here count $count - $difference1");
        // if (_removeSummber7[date.year]!) {
        //   print("removing summer $count");
        //   if (count <= 0 || count < 7) {
        //     count = 0;
        //   }
        //   if (count >= 7 && count < 14) {
        //     count = 7;
        //   }
        //   if (count >= 14 && count < 21) {
        //     count = 14;
        //   }
        //   if (count >= 21 && count < 28) {
        //     count = 21;
        //   }
        //   if (count >= 28 && count < 35) {
        //     count = 28;
        //   }
        //   if (count >= 35 && count < 42) {
        //     count = 35;
        //   }
        // }
        //   // _holidays[date.year]![7].date =
        //   //     _holidays[date.year]![7].date.subtract(Duration(days: 7));
        // }
      }
      // print("here date : ${_holidays[date.year]![7].date}");
      // _holidays[date.year]![8].date =
      //     _holidays[date.year]![8].date.subtract(Duration(days: 7));
      // print("here date : ${_holidays[date.year]![8].date}");
      if (_holidays[date.year]![8].date != DateTime(0)) {
        // print("second1 : 7-9");

        /// 7-8
        if ((date.isAfter(_holidays[date.year]![7].date) ||
                date.isAtSameMomentAs(_holidays[date.year]![7].date)) &&
            date.isBefore(_holidays[date.year]![8].date)) {
          count = date.difference(_holidays[date.year]![7].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![7].holidayName;

          /// After  3id el salib  eliya = week 4
          DateTime firstSundayAfter14 = findNthDayAfter(
              startDate: DateTime(date.year, 9, 14), x: 1, dayName: 'Sunday');
          if (date.year == firstSundayAfter14.year &&
              ((date.month == firstSundayAfter14.month &&
                      date.day >= firstSundayAfter14.day) ||
                  (date.month > firstSundayAfter14.month))) {
            count = 14 + date.difference(firstSundayAfter14).inDays.abs();
          }

          // /// We don't have eliya 8 so we put eliya 3
          // if ((((count + 1) / 7).ceil()) == 8) {
          //   // print("here1");
          //   count = 14;
          // }
          // // print("the count is $count");
        }

        /// 8-9
        if ((date.isAfter(_holidays[date.year]![8].date) ||
                date.isAtSameMomentAs(_holidays[date.year]![8].date)) &&
            date.isBefore(_holidays[date.year]![9].date)) {
          count = date.difference(_holidays[date.year]![8].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![8].holidayName;
        }
      } else {
        // print("second1 : 7-9");

        /// 7-9
        if ((date.isAfter(_holidays[date.year]![7].date) ||
                date.isAtSameMomentAs(_holidays[date.year]![7].date)) &&
            date.isBefore(_holidays[date.year]![9].date)) {
          // print("second2 : 7-9");
          count = date.difference(_holidays[date.year]![7].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![7].holidayName;
          // print("the count2 is $count");

          // /// After  3id el salib  eliya = week 4
          // DateTime firstSundayAfter14 = findNthDayAfter(
          //     startDate: DateTime(date.year, 9, 14), x: 1, dayName: 'Sunday');
          // if (date.year == firstSundayAfter14.year &&
          //     ((date.month == firstSundayAfter14.month &&
          //             date.day >= firstSundayAfter14.day) ||
          //         (date.month > firstSundayAfter14.month))) {
          //   count = 21 + date.difference(firstSundayAfter14).inDays.abs();
          // }

          // /// We don't have eliya 8 so we put eliya 3
          // if ((((count + 1) / 7).ceil()) == 8) {
          //   // print("here2");
          //   count = 14;
          // }
        }
      }

      /// 9-0
      if ((date.isAfter(_holidays[date.year]![9].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![9].date))
          // &&
          // date.isBefore(_holidays[date.year]![0].date)
          ) {
        count = date.difference(_holidays[date.year]![9].date).inDays.abs();
        holidayItemTMP = _holidays[date.year]![9].holidayName;

        if (date.isAfter(_holidays[date.year]![1].date) ||
            date.isAtSameMomentAs(_holidays[date.year]![1].date)) {
          count = date.difference(_holidays[date.year]![1].date).inDays.abs();
          holidayItemTMP = _holidays[date.year]![1].holidayName;
        }

        if ((date.isAfter(_holidays[date.year]![0].date) ||
            date.isAtSameMomentAs(_holidays[date.year]![0].date))) {
          count = date.difference(DateTime(date.year, 12, 31)).inDays.abs();
          holidayItemTMP = _holidays[date.year]![0].holidayName;
        }
      }
    }

    if (holidayItemTMP != null) {
      // print("newhere $count");
      String language = GetStorageHelper().getLanguageInEnglish();
      String languageCode = language == "English" ? "en" : "ar";
      String result = "";
      if ((date.isAfter(_holidays[date.year]![6].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![6].date)) &&
          date.isBefore(_holidays[date.year]![7].date)) {
        int diff3 = _holidays[date.year]![6]
            .date
            .difference(_holidays[date.year]![7].date)
            .inDays
            .abs();
        if (diff3 <= 42 && count >= 35) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 6/7 $holidayItemTMP";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} ${(((count + 1) / 7).ceil())} $holidayItemTMP";
        }
      } else if ((date.isAfter(_holidays[date.year]![2].date) ||
              date.isAtSameMomentAs(_holidays[date.year]![2].date)) &&
          date.isBefore(_holidays[date.year]![3].date)) {
        result = calculateEidlDenehString(date, languageCode, holidayItemTMP);
      } else {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} ${(((count + 1) / 7).ceil())} $holidayItemTMP";
      }

      // ${holidaysNames[index]["en"]}

      // print("here result $result");
      if (holidayItemTMP == _holidays[date.year]![7].holidayName) {
        int date13or14 = 14;
        if (Provider.of<ProviderChurch>(context, listen: false).churchName ==
            "Syriac") {
          date13or14 = 13;
        }

        count = count + 1;
        int count1 = (((count) / 7).ceil());

        // print("Counts :  $count - $count1");

        if (date.year == DateTime(date.year, 9, date13or14).year &&
            ((date.month == DateTime(date.year, 9, date13or14).month &&
                    date.day > DateTime(date.year, 9, date13or14).day) ||
                (date.month > DateTime(date.year, 9, date13or14).month))) {
          // print("Counts1 :  $count - $count1 ");
          int count2 = count1 + 3;
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} $count2 ${holidaysNames[83][currentLanguage]} - $count1 ${holidaysNames[84][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} $count1 ${holidaysNames[83][currentLanguage]}";
        }
        result = calculateSebou3Eliya(DateTime(date.year, 9, date13or14),
            _holidays[date.year]![7].date, date, languageCode, currentLanguage);
      }

      if (GetStorageHelper().getPrayersLanguageInEnglish() == "Arabic") {
        for (var element in holidaysNames) {
          if (element["en"] == holidayItemTMP) {
            holidayItemTMP = element["ar"];
            break;
          }
        }
      }
      if (GetStorageHelper().getPrayersLanguageInEnglish() == "Syriac") {
        for (var element in holidaysNames) {
          if (element["en"] == holidayItemTMP) {
            holidayItemTMP = element["syr"];
            break;
          }
        }
      }

      if (result == "") {
        return null;
      }
      // print("here1 : $result");
      // print("here2 : $holidayItemTMP");
      // notifyListeners();
      return HolidayItem(
          holidayName: result,
          holidayNameOnly: holidayItemTMP,
          week: "${weeksNames[((count + 1) / 7).ceil()][languageCode]}",
          day: daysNames[getNumberOfTheDay(DateFormat('EEEE').format(date))]
              [languageCode],
          date: date,
          isWeb: isWeb);
    }
    return null;
  }

  String calculateEidlDenehString(
      DateTime date, String languageCode, String holidayItemTMP) {
    String result = "";
    int diff = _holidays[date.year]![2]
        .date
        .difference(_holidays[date.year]![3].date)
        .inDays
        .abs();
    int diff2 = _holidays[date.year]![2].date.difference(date).inDays.abs();
    print(diff);
    if (diff == 28) {
      print("case0");
      if (diff2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 $holidayItemTMP";
      }
      if (diff2 >= 7 && diff2 < 14) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 $holidayItemTMP";
      }
      if (diff2 >= 14 && diff2 < 21) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 $holidayItemTMP";
      }
      if (diff2 >= 21 && diff2 < 28) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 $holidayItemTMP";
      }
    }
    if (diff == 35) {
      print("case1");
      if (diff2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 $holidayItemTMP";
      }
      if (diff2 >= 7 && diff2 < 14) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 2 $holidayItemTMP";
      }
      if (diff2 >= 14 && diff2 < 21) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 $holidayItemTMP";
      }
      if (diff2 >= 21 && diff2 < 28) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 $holidayItemTMP";
      }
      if (diff2 >= 28 && diff2 < 35) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 $holidayItemTMP";
      }
    }
    if (diff == 49) {
      print("case2");
      if (diff2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 $holidayItemTMP";
      }
      if (diff2 >= 7 && diff2 < 14) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 2 $holidayItemTMP";
      }
      if (diff2 >= 14 && diff2 < 21) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 3 $holidayItemTMP";
      }
      if (diff2 >= 21 && diff2 < 28) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 4 $holidayItemTMP";
      }
      if (diff2 >= 28 && diff2 < 35) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 $holidayItemTMP";
      }
      if (diff2 >= 35 && diff2 < 42) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 $holidayItemTMP";
      }
      if (diff2 >= 42 && diff2 < 49) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 $holidayItemTMP";
      }
    }
    if (diff == 42) {
      print("case3");
      if (diff2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 $holidayItemTMP";
      }
      if (diff2 >= 7 && diff2 < 14) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 2 $holidayItemTMP";
      }
      if (diff2 >= 14 && diff2 < 21) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 3 $holidayItemTMP";
      }
      if (diff2 >= 21 && diff2 < 28) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 $holidayItemTMP";
      }
      if (diff2 >= 28 && diff2 < 35) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 $holidayItemTMP";
      }
      if (diff2 >= 35 && diff2 < 42) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 $holidayItemTMP";
      }
    }
    return result;
  }

  checkIfEidElSalibIsEarly(DateTime date, int eidSalibDay) {
    int difference1 = DateTime(date.year, 9, eidSalibDay)
            .difference(_holidays[date.year]![7].date)
            .inDays
            .abs() +
        1;

    int diff3 = _holidays[date.year]![6]
        .date
        .difference(_holidays[date.year]![7].date)
        .inDays
        .abs();
    // print("first diff : $diff3 - $difference1 - ${date.year}");

    if (difference1 <= 7) {
      _isEidElSalibEarly.putIfAbsent(date.year, () => true);
      if (difference1 == 1) {
        _removeSummber7.putIfAbsent(date.year, () => true);
        _holidays[date.year]![7].date =
            _holidays[date.year]![7].date.subtract(Duration(days: 7));
      } else if (diff3 <= 42) {
        {
          _removeSummber7.putIfAbsent(date.year, () => true);
        }
      } else {
        {
          _removeSummber7.putIfAbsent(date.year, () => false);
        }
      }
    } else {
      _isEidElSalibEarly.putIfAbsent(date.year, () => false);
      _removeSummber7.putIfAbsent(date.year, () => false);
    }
  }

  String calculateSebou3Eliya(DateTime eidElSlaib, DateTime startOfEliya,
      DateTime date, String languageCode, String currentLanguage) {
    int difference1 = eidElSlaib.difference(startOfEliya).inDays.abs() + 1;
    int difference2 = startOfEliya.difference(date).inDays.abs();
    String result = "";
    print(difference1);
    print(difference2);
    print(_isEidElSalibEarly[date.year]);
    bool isSunday = eidElSlaib.weekday == DateTime.sunday ? true : false;

    /// Case 1
    if (difference1 > 14 && difference1 <= 21) {
      // print("case1");
      if (difference2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 7 && difference2 < 14) {
        // if (isSunday) {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 2/3 ${holidaysNames[83][currentLanguage]}";
        // } else {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 2 ${holidaysNames[83][currentLanguage]}";
        // }
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 2 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 14 && difference2 < 21) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 4 ${holidaysNames[83][currentLanguage]} - 1 ${holidaysNames[84][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 3 ${holidaysNames[83][currentLanguage]}";
        }
      }
      if (difference2 >= 21 && difference2 < 28) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 3 ${holidaysNames[83][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 4 ${holidaysNames[83][currentLanguage]} - 1 ${holidaysNames[84][currentLanguage]}";
        }
      }
      if (difference2 >= 28 && difference2 < 35) {
        // if (isSunday) {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
        // } else {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
        // }
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 35 && difference2 < 42) {
        // if (isSunday) {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]} - 3 ${holidaysNames[84][currentLanguage]}";
        // } else {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]} - 3 ${holidaysNames[84][currentLanguage]}";
        // }
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]} - 3 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 42) {
        // if (isSunday) {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 7 ${holidaysNames[83][currentLanguage]} - 4 ${holidaysNames[84][currentLanguage]}";
        // } else {
        //   result =
        //       "${DateFormat('EEEE', languageCode).format(date).toString()} 7 ${holidaysNames[83][currentLanguage]} - 4 ${holidaysNames[84][currentLanguage]}";
        // }
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 ${holidaysNames[83][currentLanguage]} - 4 ${holidaysNames[84][currentLanguage]}";
      }
      notifyListeners();
      return result;
    }

    /// Case 2
    if (_isEidElSalibEarly[date.year]!) {
      // _holidays[date.year]![7].date =
      //     _holidays[date.year]![7].date.subtract(Duration(days: 7));
      // print("case2");
      if (difference2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 7 && difference2 < 14) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 4 ${holidaysNames[83][currentLanguage]} - 1 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 14 && difference2 < 21) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 2 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 21 && difference2 < 28) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 3 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 28 && difference2 < 35) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 35 && difference2 < 42) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]} - 3 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 42) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 ${holidaysNames[83][currentLanguage]} - 4 ${holidaysNames[84][currentLanguage]}";
      }
      notifyListeners();
      return result;
    }

    /// Case 3
    if (difference1 > 21 && difference1 <= 28) {
      // print("case3");
      if (difference2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 7 && difference2 < 14) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 2 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 14 && difference2 < 21) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 3/4 ${holidaysNames[83][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 3 ${holidaysNames[83][currentLanguage]}";
        }
      }
      if (difference2 >= 21 && difference2 < 28) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 1 ${holidaysNames[84][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]}";
        }
      }
      if (difference2 >= 28 && difference2 < 35) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 4 ${holidaysNames[83][currentLanguage]} - 1 ${holidaysNames[84][currentLanguage]}";
        }
      }
      if (difference2 >= 35 && difference2 < 42) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]} - 3 ${holidaysNames[84][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
        }
      }
      if (difference2 >= 42 && difference2 < 49) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 ${holidaysNames[83][currentLanguage]} - 4 ${holidaysNames[84][currentLanguage]}";
      }
      notifyListeners();
      return result;
    }
    if (difference1 <= 14 && !_isEidElSalibEarly[date.year]!) {
      // print("case4");
      if (difference2 < 7) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 1 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 7 && difference2 < 14) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 4 ${holidaysNames[83][currentLanguage]} - 1 ${holidaysNames[84][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 2 ${holidaysNames[83][currentLanguage]}";
        }
      }
      if (difference2 >= 14 && difference2 < 21) {
        if (isSunday) {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 2 ${holidaysNames[83][currentLanguage]}";
        } else {
          result =
              "${DateFormat('EEEE', languageCode).format(date).toString()} 4 ${holidaysNames[83][currentLanguage]} - 1 ${holidaysNames[84][currentLanguage]}";
        }
      }
      if (difference2 >= 21 && difference2 < 28) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 3 ${holidaysNames[83][currentLanguage]}";
      }
      if (difference2 >= 28 && difference2 < 35) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 5 ${holidaysNames[83][currentLanguage]} - 2 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 35 && difference2 < 42) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 6 ${holidaysNames[83][currentLanguage]} - 3 ${holidaysNames[84][currentLanguage]}";
      }
      if (difference2 >= 42) {
        result =
            "${DateFormat('EEEE', languageCode).format(date).toString()} 7 ${holidaysNames[83][currentLanguage]} - 4 ${holidaysNames[84][currentLanguage]}";
      }
      notifyListeners();
      return result;
    }
    notifyListeners();
    return result;
  }

  int? isSebou3({required String holidayRelated}) {
    if (holidayRelated == holidaysNames[1]["en"] ||
        holidayRelated == holidaysNames[1]["ar"] ||
        holidayRelated == holidaysNames[1]["syr"]) {
      return 1;
    }
    if (holidayRelated == holidaysNames[2]["en"] ||
        holidayRelated == holidaysNames[2]["ar"] ||
        holidayRelated == holidaysNames[2]["syr"]) {
      return 2;
    }
    if (holidayRelated == holidaysNames[3]["en"] ||
        holidayRelated == holidaysNames[3]["ar"] ||
        holidayRelated == holidaysNames[3]["syr"]) {
      return 3;
    }
    if (holidayRelated == holidaysNames[4]["en"] ||
        holidayRelated == holidaysNames[4]["ar"] ||
        holidayRelated == holidaysNames[4]["syr"]) {
      return 4;
    }
    if (holidayRelated == holidaysNames[5]["en"] ||
        holidayRelated == holidaysNames[5]["ar"] ||
        holidayRelated == holidaysNames[5]["syr"]) {
      return 5;
    }
    if (holidayRelated == holidaysNames[6]["en"] ||
        holidayRelated == holidaysNames[6]["ar"] ||
        holidayRelated == holidaysNames[6]["syr"]) {
      return 6;
    }
    if (holidayRelated == holidaysNames[7]["en"] ||
        holidayRelated == holidaysNames[7]["ar"] ||
        holidayRelated == holidaysNames[7]["syr"]) {
      return 7;
    }
    if (holidayRelated == holidaysNames[8]["en"] ||
        holidayRelated == holidaysNames[8]["ar"] ||
        holidayRelated == holidaysNames[8]["syr"]) {
      return 8;
    }
    if (holidayRelated == holidaysNames[9]["en"] ||
        holidayRelated == holidaysNames[9]["ar"] ||
        holidayRelated == holidaysNames[9]["syr"]) {
      return 9;
    }
    if (holidayRelated == holidaysNames[10]["en"] ||
        holidayRelated == holidaysNames[10]["ar"] ||
        holidayRelated == holidaysNames[10]["syr"]) {
      return 10;
    }

    return null;
  }

  // String getOrdinal(int number) {
  //   if (number % 100 >= 11 && number % 100 <= 13) {
  //     return '$number' 'th';
  //   }
  //   switch (number % 10) {
  //     case 1:
  //       return '$number' 'st';
  //     case 2:
  //       return '$number' 'nd';
  //     case 3:
  //       return '$number' 'rd';
  //     default:
  //       return '$number' 'th';
  //   }
  // }

  int getNumberOfTheDay(String val) {
    switch (val) {
      case "Monday":
        return 1;
      case "Tuesday":
        return 2;
      case "Wednesday":
        return 3;
      case "Thursday":
        return 4;
      case "Friday":
        return 5;
      case "Saturday":
        return 6;
      case "Sunday":
        return 7;
      default:
        return 0;
    }
  }

  DateTime findNthDayAfter(
      {required DateTime startDate, required int x, required String dayName}) {
    // Create a map to map the day names to their corresponding numerical representation
    final dayMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    // Get the numerical representation of the desired day
    final desiredDay = dayMap[dayName];

    // Start iterating from the next day after the start date
    var currentDate = startDate.add(const Duration(days: 1));

    // Keep track of the number of occurrences found
    var occurrencesFound = 0;

    // Iterate until the desired number of occurrences are found
    while (occurrencesFound < x) {
      // If the current day matches the desired day, increment the occurrences count
      if (currentDate.weekday == desiredDay) {
        occurrencesFound++;
      }

      // Move to the next day
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return currentDate.subtract(const Duration(days: 1));
  }

// String getDeskString(List itemDesc) {
//   String itemDescString = '';
//   for (var element in itemDesc) {
//     itemDescString += element["insert"];
//   }
//   return itemDescString;
// }
}
