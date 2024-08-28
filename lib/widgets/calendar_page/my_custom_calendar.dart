import 'dart:async';
import 'dart:math' as math; // import this

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/date_provider/date_provider.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/other/is_rtl.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/data/data.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/utils/hexColor/hexColor.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/PopUp/show_dialog_choose_church.dart';
import 'package:hudra/widgets/calendar_page/holiday_item.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/utils/date_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCustomCalender extends StatefulWidget {
  bool isWeb = false;
  Function(DateTime, List<HolidayItem>) onDayPressed;

  MyCustomCalender({
    Key? key,
    this.isWeb = false,
    required this.onDayPressed,
  }) : super(key: key);

  @override
  State<MyCustomCalender> createState() => _MyCustomCalenderState();
}

class _MyCustomCalenderState extends State<MyCustomCalender> {
  // int _month = DateTime.now().month;
  // int _year = DateTime.now().year;
  // int _month = 9;
  // int _year = DateTime(2008).year;

  final Color _color1 = Colors.yellow;
  final Color _color2 = Colors.white;
  final Color _color3 = Colors.purple;
  final Color _color4 = Colors.red;
  final Color _color5 = Colors.blue;
  final Color _color6 = Colors.green;
  final Color _color7 = HexColor('#8B4513'); // Elijah
  final Color _color8 = HexColor('#C19A6B'); // Mosse
  final Color _color9 = HexColor('#FFD700');

  int _scapeDay = -999;
  bool _isLoading = true;

  final List<String> _dayName = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  DateTime _selectedDate =
      DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal()));

  // final Map<int, List<HolidayItem>> _holidays = {};

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var dateProvider = Provider.of<DateProvider>(context, listen: false);

      _selectDate(DateTime(dateProvider.year, dateProvider.month));
      Provider.of<GlobalProvider2>(context, listen: false)
          .getAllResults(context: context, currentYear: dateProvider.year);
      // Provider.of<ProviderDaily>(context, listen: false)
      //     .checkIfEidElSalibIsEarly(
      //         context, DateTime(dateProvider.year, dateProvider.month));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DateProvider>(builder: (context, dateProvider, _) {
      return Container(
        padding: !widget.isWeb
            ? const EdgeInsets.fromLTRB(35.0, 1.0, 35.0, 1.0)
            : const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .primaryColorDark, //Colors.white, //HexColor('#fafafa'),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          //border: Border.all(width: 1),
        ),
        child: ListView(
          children: [
            Padding(
              padding: !widget.isWeb
                  ? const EdgeInsets.symmetric(horizontal: 16.0)
                  : const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      dateProvider.goLeft(context);
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(isRTL(context) ? math.pi : 0),
                      child: SvgPicture.asset(
                        'Assets/Icons/arrow-circle-left.svg',
                        height: 26,
                        width: 26,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showYearPicker(context, dateProvider.year);
                    },
                    child: Container(
                      padding: !widget.isWeb
                          ? const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20)
                          : const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 0),
                      margin: const EdgeInsets.all(10),
                      child: Consumer<ProviderLanguage>(
                          builder: (context, providerLanguage, _) {
                        return Text(
                          DateFormat('MMMM yyyy',
                                  providerLanguage.currentLanguage.languageCode)
                              .format(DateTime(
                                  dateProvider.year, dateProvider.month)),
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      }),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      dateProvider.goRight(context);
                    },
                    child: Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(isRTL(context) ? math.pi : 0),
                      child: SvgPicture.asset(
                        'Assets/Icons/arrow-circle-right.svg',
                        height: 26,
                        width: 26,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// add a row showing the weekdays
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weekText(
                    AppLocalizations.of(context)!.monday,
                  ),
                  weekText(
                    AppLocalizations.of(context)!.tuesday,
                  ),
                  weekText(
                    AppLocalizations.of(context)!.wednesday,
                  ),
                  weekText(
                    AppLocalizations.of(context)!.thursday,
                  ),
                  weekText(
                    AppLocalizations.of(context)!.friday,
                  ),
                  weekText(
                    AppLocalizations.of(context)!.saturday,
                  ),
                  weekText(
                    AppLocalizations.of(context)!.sunday,
                  ),
                  // weekText('Mo'),
                  // weekText('Tu'),
                  // weekText('We'),
                  // weekText('Th'),
                  // weekText('Fr'),
                  // weekText('Sa'),
                  // weekText('Su'),
                ],
              ),
            ),
            _isLoading
                ? Padding(
                    padding: EdgeInsets.only(
                      left: isRTL(context) ? 2.0 : 7.0,
                      right: isRTL(context) ? 7.0 : 2.0,
                    ),
                    child: ScrollConfiguration(
                      behavior:
                          MyCustomScrollBehavior().copyWith(overscroll: false),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateTime date = DateTime(
                              dateProvider.year, dateProvider.month, index);
                          if (_scapeDay == -999) {
                            // print('=======================');
                            Provider.of<ProviderDaily>(context, listen: false)
                                .calculateHolidays(
                                    context: context,
                                    date: date,
                                    isWeb: widget.isWeb);
                            _scapeDay =
                                _dayName.indexOf(DateFormat('E').format(date));
                          }
                          date = DateTime(dateProvider.year, dateProvider.month,
                              index - _scapeDay);
                          if (index == 41) {
                            _scapeDay = -999;
                          }
                          Color? colorTMP = _checkColorFromHolidays(
                              date, false, dateProvider.month);
                          Color? colorNumberTMP = colorTMP;
                          //     _checkColorFromHolidays(date, true);
                          // bool isHoliday = _checkIsHoliday(date);
                          return InkWell(
                            // onTap: () => _selectDate(date),
                            onTap: () {
                              // print("here2 : $date");
                              _selectDate(date);
                              // Provider.of<ProviderDaily>(context, listen: false)
                              //     .checkIfEidElSalibIsEarly(
                              //         context,
                              //         DateTime(
                              //             date.year, date.month, date.day));
                              // Provider.of<ProviderDaily>(context, listen: false)
                              //     .checkIfEidElSalibIsEarly(context, date);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2.3,
                                    horizontal: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: date.isAtSameMomentAs(DateTime.parse(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.now().toLocal())))
                                        ? colorTMP ??
                                            Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color
                                        : null, //HexColor('#dfe2e6'),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(300.0),
                                    ),
                                    border: date.isAtSameMomentAs(_selectedDate)
                                        ? Border.all(
                                            width: 2,
                                            color:
                                                colorTMP ?? CustomColors.brown3)
                                        : null,
                                  ),
                                  child: Consumer<ProviderLanguage>(
                                      builder: (context, providerLanguage, _) {
                                    return Text(
                                      DateFormat(
                                              'd',
                                              providerLanguage
                                                  .currentLanguage.languageCode)
                                          .format(date),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: date.isAtSameMomentAs(
                                                  DateTime.parse(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(DateTime.now()
                                                              .toLocal())))
                                              ? colorTMP != _color2
                                                  ? Colors.white70
                                                  : Colors.black87
                                              : colorNumberTMP ??
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.color
                                                      ?.withOpacity(date.month
                                                                  .toInt() !=
                                                              dateProvider.month
                                                          ? 0.4
                                                          : 1)),
                                    );
                                  }),
                                ),
                                _checkIsHoliday(date)
                                    ? Positioned(
                                        bottom: 6.5,
                                        child: Icon(
                                          Icons.circle,
                                          color: date.isAtSameMomentAs(
                                                  DateTime.parse(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(DateTime.now()
                                                              .toLocal())))
                                              ? Theme.of(context)
                                                  .primaryColorDark
                                              : colorTMP ??
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .color,
                                          size: 5,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          );
                        },
                        itemCount: 42,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 42,
                          crossAxisCount: 7,
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      );
    });
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  // HolidayItem initHolidaysHome() {
  //   DateTime date = DateTime.now();
  //   _calculateHolidays(date);
  //   List<HolidayItem> holidaysTMP = [];
  //   if (_holidays.containsKey(date.year)) {
  //     holidaysTMP.addAll(_holidays[date.year]!
  //         .where((element) => element.date.isSameDay(date)));
  //   }
  //   if (_holidays.containsKey(date.year - 1)) {
  //     holidaysTMP.addAll(_holidays[date.year - 1]!
  //         .where((element) => element.date.isSameDay(date)));
  //   }
  //   if (_holidays.containsKey(date.year + 1)) {
  //     holidaysTMP.addAll(_holidays[date.year + 1]!
  //         .where((element) => element.date.isSameDay(date)));
  //   }
  //
  //   if (holidaysTMP.isEmpty) {
  //     HolidayItem? tmp = _checkSubHoliday(date);
  //     if (tmp != null) {
  //       holidaysTMP.add(tmp);
  //     }
  //   }
  //
  //   return holidaysTMP[0];
  // }
  List<HolidayItem> holidaysTMP = [];
  _selectDate(DateTime date) {
    holidaysTMP.clear();

    _selectedDate = date;
    Map<int, List<HolidayItem>> holidays =
        Provider.of<ProviderDaily>(context, listen: false).holidays;

    if (holidays.containsKey(date.year)) {
      holidaysTMP.addAll(holidays[date.year]!
          .where((element) => element.date.isSameDay(date)));
    }
    if (holidays.containsKey(date.year - 1)) {
      holidaysTMP.addAll(holidays[date.year - 1]!
          .where((element) => element.date.isSameDay(date)));
    }
    if (holidays.containsKey(date.year + 1)) {
      holidaysTMP.addAll(holidays[date.year + 1]!
          .where((element) => element.date.isSameDay(date)));
    }

    if (holidaysTMP.isNotEmpty) {
      int? isSebou3Int = Provider.of<ProviderDaily>(context, listen: false)
          .isSebou3(holidayRelated: holidaysTMP[0].holidayName);

      // if (isSebou3Int == 3) {
      //   widget.onDayPressed(date, holidaysTMP);
      //   return;
      // }

      if (isSebou3Int != null) {
        HolidayItem? tmp = Provider.of<ProviderDaily>(context, listen: false)
            .checkSubHoliday(context, date, widget.isWeb);
        if (tmp != null) {
          holidaysTMP[0].holidayNamePriority = tmp.holidayName;
          // holidaysTMP[0].week = tmp.week;
          // holidaysTMP[0].day = tmp.day;
        }
      } else {
        HolidayItem? tmp = Provider.of<ProviderDaily>(context, listen: false)
            .checkSubHoliday(context, date, widget.isWeb);
        if (tmp != null) {
          holidaysTMP.add(tmp);
        }
      }
    }

    if (holidaysTMP.isEmpty) {
      HolidayItem? tmp = Provider.of<ProviderDaily>(context, listen: false)
          .checkSubHoliday(context, date, widget.isWeb);
      if (tmp != null) {
        holidaysTMP.add(tmp);
      }
    }
    // print("the date is $date");
    // if (areDatesEqual(
    //     date.toString(),
    //     Provider.of<GlobalProvider2>(context, listen: false)
    //         .somElBa3outh1String)) {
    // holidaysTMP.add(HolidayItem(
    //     holidayName: holidaysNames[59]["en"],
    //     holidayNameOnly: "",
    //     week: "",
    //     day: "",
    //     date: date,
    //     isWeb: widget.isWeb));
    // }
    String baoutha1 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh1String;
    String baoutha2 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh2String;
    String baoutha3 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh3String;

    if (baoutha1.isNotEmpty && baoutha2.isNotEmpty && baoutha3.isNotEmpty) {
      if (areDatesEqual(date.toString(), baoutha1)) {
        if (holidaysTMP.isNotEmpty) {
          holidaysTMP.clear();
        }
        holidaysTMP.add(HolidayItem(
            holidayName: holidaysNames[58][GetStorageHelper().getLanguage()],
            holidayNameOnly: holidaysNames[58]
                [GetStorageHelper().getLanguage()],
            week: "",
            day: "",
            date: date,
            isWeb: widget.isWeb));
      }
      if (areDatesEqual(date.toString(), baoutha2)) {
        if (holidaysTMP.isNotEmpty) {
          holidaysTMP.clear();
        }
        holidaysTMP.add(HolidayItem(
            holidayName: holidaysNames[59][GetStorageHelper().getLanguage()],
            holidayNameOnly: holidaysNames[59]
                [GetStorageHelper().getLanguage()],
            week: "",
            day: "",
            date: date,
            isWeb: widget.isWeb));
      }
      if (areDatesEqual(date.toString(), baoutha3)) {
        if (holidaysTMP.isNotEmpty) {
          holidaysTMP.clear();
        }
        holidaysTMP.add(HolidayItem(
            holidayName: holidaysNames[60][GetStorageHelper().getLanguage()],
            holidayNameOnly: holidaysNames[60]
                [GetStorageHelper().getLanguage()],
            week: "",
            day: "",
            date: date,
            isWeb: widget.isWeb));
      }
    } else {
      startPeriodicTask(date);
    }
    widget.onDayPressed(date, holidaysTMP);
    // setState(() {});
  }

  void startPeriodicTask(DateTime date) {
    // Define the duration of the periodic interval
    const duration = Duration(seconds: 1);

    // Create a timer that runs the task periodically
    Timer.periodic(duration, (Timer timer) {
      // Your periodic task
      String baoutha1 = Provider.of<GlobalProvider2>(context, listen: false)
          .somElBa3outh1String;
      String baoutha2 = Provider.of<GlobalProvider2>(context, listen: false)
          .somElBa3outh2String;
      String baoutha3 = Provider.of<GlobalProvider2>(context, listen: false)
          .somElBa3outh3String;

      // Check the condition

      if (baoutha1.isNotEmpty && baoutha2.isNotEmpty && baoutha3.isNotEmpty) {
        if (areDatesEqual(date.toString(), baoutha1)) {
          if (holidaysTMP.isNotEmpty) {
            holidaysTMP.clear();
          }
          holidaysTMP.add(HolidayItem(
              holidayName: holidaysNames[58][GetStorageHelper().getLanguage()],
              holidayNameOnly: holidaysNames[58]
                  [GetStorageHelper().getLanguage()],
              week: "",
              day: "",
              date: date,
              isWeb: widget.isWeb));
          widget.onDayPressed(date, holidaysTMP);
        }
        if (areDatesEqual(date.toString(), baoutha2)) {
          if (holidaysTMP.isNotEmpty) {
            holidaysTMP.clear();
          }
          holidaysTMP.add(HolidayItem(
              holidayName: holidaysNames[59][GetStorageHelper().getLanguage()],
              holidayNameOnly: holidaysNames[59]
                  [GetStorageHelper().getLanguage()],
              week: "",
              day: "",
              date: date,
              isWeb: widget.isWeb));
          widget.onDayPressed(date, holidaysTMP);
        }
        if (areDatesEqual(date.toString(), baoutha3)) {
          if (holidaysTMP.isNotEmpty) {
            holidaysTMP.clear();
          }
          holidaysTMP.add(HolidayItem(
              holidayName: holidaysNames[60][GetStorageHelper().getLanguage()],
              holidayNameOnly: holidaysNames[60]
                  [GetStorageHelper().getLanguage()],
              week: "",
              day: "",
              date: date,
              isWeb: widget.isWeb));
          widget.onDayPressed(date, holidaysTMP);
        }

        // Stop the periodic task
        timer.cancel();
        // print("Condition met. Task stopped.");
      }
    });
  }

  bool areDatesEqual(String dateString1, String dateString2) {
    // Parse the first date string
    DateTime dateTime1 = DateTime.parse(dateString1);
    // print("dates are : $dateString1 - ${dateString2}");

    // Parse the second date string using DateFormat from the intl package
    DateFormat dateFormat = DateFormat("dd-MMMM-yyyy");
    DateTime dateTime2 = dateFormat.parse(dateString2);
    // Compare the year, month, and day
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  Color? _checkColorFromHolidays(DateTime date, bool isANumber, int mth) {
    Color? colorTMP;
    Map<int, List<HolidayItem>> holidays =
        Provider.of<ProviderDaily>(context, listen: false).holidays;
    //if (_checkIsHoliday(date)) {
    if (holidays.containsKey(date.year)) {
      /// 0-2 -> START->2  && 1->END
      // if ((date.isAfter(_holidays[date.year]![0].date) ||
      //         date.isAtSameMomentAs(_holidays[date.year]![0].date)) &&
      //     date.isBefore(_holidays[date.year]![2].date)) {

      if (
          //START->2
          ((date.isAfter(DateTime(date.year, 1, 1)) ||
                      date.isAtSameMomentAs(DateTime(date.year, 1, 1))) &&
                  date.isBefore(holidays[date.year]![2].date)) ||
              //1->END
              ((date.isAfter(holidays[date.year]![1].date) ||
                      date.isAtSameMomentAs(holidays[date.year]![1].date)) &&
                  (date.isBefore(DateTime(date.year, 12, 31)) ||
                      date.isAtSameMomentAs(DateTime(date.year, 12, 31))))) {
        colorTMP = _color1;
      }

      /// 2-3
      if ((date.isAfter(holidays[date.year]![2].date) ||
              date.isAtSameMomentAs(holidays[date.year]![2].date)) &&
          date.isBefore(holidays[date.year]![3].date)) {
        colorTMP = _color2;
      }

      /// 3-4
      if ((date.isAfter(holidays[date.year]![3].date) ||
              date.isAtSameMomentAs(holidays[date.year]![3].date)) &&
          date.isBefore(holidays[date.year]![4].date)) {
        colorTMP = _color3;
      }

      /// 4-5
      if ((date.isAfter(holidays[date.year]![4].date) ||
              date.isAtSameMomentAs(holidays[date.year]![4].date)) &&
          date.isBefore(holidays[date.year]![5].date)) {
        colorTMP = _color4;
      }

      /// 5-6
      if ((date.isAfter(holidays[date.year]![5].date) ||
              date.isAtSameMomentAs(holidays[date.year]![5].date)) &&
          date.isBefore(holidays[date.year]![6].date)) {
        colorTMP = _color5;
      }

      /// 6-7
      if ((date.isAfter(holidays[date.year]![6].date) ||
              date.isAtSameMomentAs(holidays[date.year]![6].date)) &&
          date.isBefore(holidays[date.year]![7].date)) {
        colorTMP = _color6;
      }

      if (holidays[date.year]![8].date != DateTime(0)) {
        /// 7-8
        if ((date.isAfter(holidays[date.year]![7].date) ||
                date.isAtSameMomentAs(holidays[date.year]![7].date)) &&
            date.isBefore(holidays[date.year]![8].date)) {
          colorTMP = _color7;
        }

        /// 8-9
        if ((date.isAfter(holidays[date.year]![8].date) ||
                date.isAtSameMomentAs(holidays[date.year]![8].date)) &&
            date.isBefore(holidays[date.year]![9].date)) {
          colorTMP = _color8;
        }
      } else {
        /// 7-8
        if ((date.isAfter(holidays[date.year]![7].date) ||
                date.isAtSameMomentAs(holidays[date.year]![7].date)) &&
            date.isBefore(holidays[date.year]![9].date)) {
          colorTMP = _color7;
        }
      }

      /// 9-0
      if ((date.isAfter(holidays[date.year]![9].date) ||
              date.isAtSameMomentAs(holidays[date.year]![9].date)) &&
          date.isBefore(holidays[date.year]![0].date)) {
        colorTMP = _color9;
      }
      // else {
      //   return null;
      // }
    }
    return
        // !isANumber
        //   ?
        colorTMP?.withOpacity(date.month.toInt() != mth ? 0.4 : 1);
    // : date.month.toInt() != _month
    //     ? Theme.of(context).textTheme.bodySmall?.color!.withOpacity(0.4)
    //     : colorTMP;
  }

  // void _calculateHolidays(DateTime date) {
  //   // _isLoading = true;
  //   if (!_holidays.containsKey(_year)) {
  //     debugPrint('calculateHolidays');
  //     Map<String, DateTime> holidays =
  //         GlobalProvider2().getAllResults(date.year);
  //     List<HolidayItem> listHolidayItemTMP = [];
  //     holidays.forEach((key, value) {
  //       // if (value.year == date.year) {
  //       listHolidayItemTMP.add(HolidayItem(
  //         holidayName: key,
  //         date: value,
  //         isWeb: widget.isWeb,
  //       ));
  //       // }
  //     });
  //     _holidays[date.year] = listHolidayItemTMP;
  //   }
  //   // _isLoading = false;
  // }
  //
  // HolidayItem? _checkSubHoliday(DateTime date) {
  //   String? holidayItemTMP;
  //   int count = 0;
  //   int index = 0;
  //   //if (_checkIsHoliday(date)) {
  //   if (_holidays.containsKey(date.year)) {
  //     /// 0-2 -> START->2  && 0->END
  //     if (
  //         //START->2
  //         ((date.isAfter(DateTime(date.year, 1, 1)) ||
  //                     date.isAtSameMomentAs(DateTime(date.year, 1, 1))) &&
  //                 date.isBefore(_holidays[date.year]![2].date)) ||
  //             //0->END
  //             ((date.isAfter(_holidays[date.year]![0].date) ||
  //                     date.isAtSameMomentAs(_holidays[date.year]![0].date)) &&
  //                 (date.isBefore(DateTime(date.year, 12, 31)) ||
  //                     date.isAtSameMomentAs(DateTime(date.year, 12, 31))))) {
  //       if (date.isAfter(_holidays[date.year]![0].date) ||
  //           date.isAtSameMomentAs(_holidays[date.year]![0].date)) {
  //         count = date.difference(_holidays[date.year]![0].date).inDays.abs();
  //         index = 1;
  //         holidayItemTMP = _holidays[date.year]![0].holidayName;
  //       } else if (date.isAfter(DateTime(date.year, 1, 1))) {
  //         count = 6 + date.difference(DateTime(date.year, 1, 1)).inDays.abs();
  //         index = 1;
  //
  //         holidayItemTMP = _holidays[date.year]![0].holidayName;
  //       } else {
  //         count = date.difference(_holidays[date.year]![1].date).inDays.abs();
  //         index = 2;
  //         holidayItemTMP = _holidays[date.year]![1].holidayName;
  //       }
  //     }
  //
  //     /// 2-3
  //     if ((date.isAfter(_holidays[date.year]![2].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![2].date)) &&
  //         date.isBefore(_holidays[date.year]![3].date)) {
  //       count = date.difference(_holidays[date.year]![2].date).inDays.abs();
  //       index = 3;
  //
  //       holidayItemTMP = _holidays[date.year]![2].holidayName;
  //     }
  //
  //     /// 3-4
  //     if ((date.isAfter(_holidays[date.year]![3].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![3].date)) &&
  //         date.isBefore(_holidays[date.year]![4].date)) {
  //       count = date.difference(_holidays[date.year]![3].date).inDays.abs();
  //       index = 4;
  //       holidayItemTMP = _holidays[date.year]![3].holidayName;
  //     }
  //
  //     /// 4-5
  //     if ((date.isAfter(_holidays[date.year]![4].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![4].date)) &&
  //         date.isBefore(_holidays[date.year]![5].date)) {
  //       count = date.difference(_holidays[date.year]![4].date).inDays.abs();
  //       index = 5;
  //       holidayItemTMP = _holidays[date.year]![4].holidayName;
  //     }
  //
  //     /// 5-6
  //     if ((date.isAfter(_holidays[date.year]![5].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![5].date)) &&
  //         date.isBefore(_holidays[date.year]![6].date)) {
  //       count = date.difference(_holidays[date.year]![5].date).inDays.abs();
  //       index = 6;
  //       holidayItemTMP = _holidays[date.year]![5].holidayName;
  //     }
  //
  //     /// 6-7
  //     if ((date.isAfter(_holidays[date.year]![6].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![6].date)) &&
  //         date.isBefore(_holidays[date.year]![7].date)) {
  //       count = date.difference(_holidays[date.year]![6].date).inDays.abs();
  //       index = 7;
  //       holidayItemTMP = _holidays[date.year]![6].holidayName;
  //     }
  //
  //     /// 7-8
  //     if ((date.isAfter(_holidays[date.year]![7].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![7].date)) &&
  //         date.isBefore(_holidays[date.year]![8].date)) {
  //       count = date.difference(_holidays[date.year]![7].date).inDays.abs();
  //       index = 8;
  //       holidayItemTMP = _holidays[date.year]![7].holidayName;
  //     }
  //
  //     /// 8-9
  //     if ((date.isAfter(_holidays[date.year]![8].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![8].date)) &&
  //         date.isBefore(_holidays[date.year]![9].date)) {
  //       count = date.difference(_holidays[date.year]![8].date).inDays.abs();
  //       index = 9;
  //       holidayItemTMP = _holidays[date.year]![8].holidayName;
  //     }
  //
  //     /// 9-0
  //     if ((date.isAfter(_holidays[date.year]![9].date) ||
  //             date.isAtSameMomentAs(_holidays[date.year]![9].date)) &&
  //         date.isBefore(_holidays[date.year]![0].date)) {
  //       count = date.difference(_holidays[date.year]![9].date).inDays.abs();
  //       index = 10;
  //       holidayItemTMP = _holidays[date.year]![9].holidayName;
  //     }
  //   }
  //
  //   if (holidayItemTMP != null) {
  //     print(
  //         "${DateFormat('EEEE').format(date).toString()} of the ${getOrdinal(((count + 1) / 7).ceil())} week of ${holidaysNames[index]["en"]}");
  //     return HolidayItem(
  //         holidayName: holidayItemTMP, date: date, isWeb: widget.isWeb);
  //   }
  //   return null;
  // }

  bool _checkIsHoliday(DateTime date) {
    String baoutha1 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh1String;
    String baoutha2 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh2String;
    String baoutha3 = Provider.of<GlobalProvider2>(context, listen: false)
        .somElBa3outh3String;
    Map<int, List<HolidayItem>> holidays =
        Provider.of<ProviderDaily>(context, listen: false).holidays;
    if (holidays.containsKey(date.year)) {
      if (holidays[date.year]!
          .where((element) => element.date.isSameDay(date))
          .isNotEmpty) {
        return true;
      }

      if (holidays.containsKey(date.year - 1)) {
        if (holidays[date.year - 1]!
            .where((element) => element.date.isSameDay(date))
            .isNotEmpty) {
          return true;
        }
      }
      if (holidays.containsKey(date.year + 1)) {
        if (holidays[date.year + 1]!
            .where((element) => element.date.isSameDay(date))
            .isNotEmpty) {
          return true;
        }
      }

      /// Special case for baoutha

      try {
        if (areDatesEqual(date.toString(), baoutha1) ||
            areDatesEqual(date.toString(), baoutha2) ||
            areDatesEqual(date.toString(), baoutha3)) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // _goLeft() {
  //   setState(() {
  //     _month--;
  //     if (_month == 0) {
  //       _month = 12;
  //       _year--;
  //       Provider.of<GlobalProvider2>(context, listen: false)
  //           .getAllResults(context: context, currentYear: _year);
  //     }
  //   });
  // }

  // _goRight() {
  //   setState(() {
  //     _month++;
  //     if (_month == 13) {
  //       _month = 1;
  //       _year++;
  //       Provider.of<GlobalProvider2>(context, listen: false)
  //           .getAllResults(context: context, currentYear: _year);
  //     }
  //   });
  // }

  String getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' 'th';
    }
    switch (number % 10) {
      case 1:
        return '$number' 'st';
      case 2:
        return '$number' 'nd';
      case 3:
        return '$number' 'rd';
      default:
        return '$number' 'th';
    }
  }
}

// PagedVerticalCalendar(
//   //startDate: DateTime.now().toLocal().subtract(const Duration(days: 60)),
//   onDayPressed: (date) => _selectDate(date),
//   scrollController: ScrollController(),
//
//   /// customize the month header look by adding a week indicator
//   monthBuilder: (context, month, year) {
//     return Column(
//       children: [
//         /// create a customized header displaying the month and year
//         Container(
//           padding:
//               const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//           margin: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor,
//             borderRadius: const BorderRadius.all(Radius.circular(50)),
//           ),
//           child: Text(
//             DateFormat('MMMM yyyy').format(DateTime(year, month)),
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         ),
//
//         /// add a row showing the weekdays
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               weekText('Mo'),
//               weekText('Tu'),
//               weekText('We'),
//               weekText('Th'),
//               weekText('Fr'),
//               weekText('Sa'),
//               weekText('Su'),
//             ],
//           ),
//         ),
//       ],
//     );
//   },
//
//   /// added a line between every week
//   dayBuilder: (context, date) {
//     bool _isHoliday = _checkIsHoliday();
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: date.isAtSameMomentAs(DateTime.parse(
//                     DateFormat('yyyy-MM-dd')
//                         .format(DateTime.now().toLocal())))
//                 ? Theme.of(context).textTheme.bodySmall?.color
//                 : null, //HexColor('#dfe2e6'),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(300.0),
//             ),
//             border: date.isAtSameMomentAs(_selectedDate)
//                 ? Border.all(width: 2, color: globals.brown3)
//                 : null,
//           ),
//           alignment: Alignment.center,
//           margin: const EdgeInsets.all(4.0),
//           child: Text(
//             DateFormat('d').format(date),
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: date.isAtSameMomentAs(DateTime.parse(
//                         DateFormat('yyyy-MM-dd')
//                             .format(DateTime.now().toLocal())))
//                     ? null
//                     : Theme.of(context).textTheme.bodySmall?.color),
//           ),
//         ),
//         _isHoliday
//             ? Positioned(
//                 bottom: 9.0,
//                 child: Icon(
//                   Icons.circle,
//                   color: date.isAtSameMomentAs(DateTime.parse(
//                           DateFormat('yyyy-MM-dd')
//                               .format(DateTime.now().toLocal())))
//                       ? Theme.of(context).primaryColorDark
//                       : globals.brown2,
//                   size: 5,
//                 ),
//               )
//             : const SizedBox.shrink(),
//       ],
//     );
//   },
// ),

// class StrikeThroughWidget extends StatelessWidget {
//   final Widget _child;
//
//   StrikeThroughWidget({Key? key, required Widget child})
//       : _child = child,
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _child,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       // this line is optional to make strikethrough effect outside a text
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage(
//               'Assets/HomePage/graphics/strikethrough2.png',
//             ),
//             fit: BoxFit.fitWidth),
//       ),
//     );
//   }
// }
//
// class StrikeThroughWidget2 extends StatelessWidget {
//   final Widget _child;
//
//   StrikeThroughWidget2({Key? key, required Widget child})
//       : _child = child,
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Center(child: _child),
//         //Center(child: Image.asset('Assets/HomePage/graphics/strikethrough2.png',width: 40,)),
//         Center(
//           child: Container(
//             height: 1,
//             width: 25,
//             color: Colors.black,
//           ),
//         )
//       ],
//     );
//   }
// }
