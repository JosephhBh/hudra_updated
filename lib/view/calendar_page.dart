import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/calendar_page/holiday_item.dart';
import 'package:hudra/widgets/calendar_page/my_custom_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  bool isWeb = false;

  CalendarPage({Key? key, this.isWeb = false}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _date = DateTime.now();
  final List<HolidayItem> _holidayItems = [];

  @override
  Widget build(BuildContext context) {
    return !widget.isWeb
        ? WillPopScope(
            onWillPop: () async =>
                Provider.of<ProviderGlobal>(context, listen: false).goBackAll(),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // color: globals.brown2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      // tileMode: TileMode.decal,
                      colors: [
                        Theme.of(context).primaryColorDark,
                        Theme.of(context).primaryColorDark,
                        CustomColors.brown2,
                        CustomColors.brown2,
                        CustomColors.brown2,
                      ],
                    ),
                  ),
                ),
                ScrollConfiguration(
                  behavior:
                      MyCustomScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: MyCustomCalender(
                            onDayPressed: (date, holidayItem) =>
                                _onDayPressed(date, holidayItem),
                          ),
                        ),
                        Container(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.65,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Center(
                                    child: Container(
                                      height: 8,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        color: CustomColors.brown1,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(300.0)),
                                      ),
                                    ),
                                  ),
                                  // title: Icon(
                                  //   Icons.keyboard_arrow_down,
                                  //   size: 36,
                                  // ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Consumer<ProviderLanguage>(builder:
                                            (context, providerLanguage, _) {
                                          return Text(
                                            DateFormat(
                                                    'EEEE, d MMM',
                                                    providerLanguage
                                                        .currentLanguage
                                                        .languageCode)
                                                .format(_date),
                                            style: TextStyle(
                                              color: CustomColors.brown1
                                                  .withOpacity(0.8),
                                              fontSize: 27.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }),
                                        const SizedBox(height: 8.0),
                                        _holidayItems.isEmpty
                                            ? Text(
                                                AppLocalizations.of(context)!
                                                    .noHoliday,
                                                //'No holiday',
                                                style: TextStyle(
                                                  color: CustomColors.brown1
                                                      .withOpacity(0.3),
                                                  fontSize: 20.0,
                                                ),
                                              )
                                            : Text(
                                                'Name of holiday',
                                                style: TextStyle(
                                                  color: CustomColors.brown1
                                                      .withOpacity(0.3),
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                        const SizedBox(height: 20),
                                        _holidayItems.isNotEmpty
                                            ? Expanded(
                                                child: Column(
                                                  children: _holidayItems,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(height: 2.0)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : WillPopScope(
            onWillPop: () async =>
                Provider.of<ProviderGlobal>(context, listen: false).goBackAll(),
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4, //0.45
                      child: MyCustomCalender(
                        isWeb: true,
                        onDayPressed: (date, holidayItem) =>
                            _onDayPressed(date, holidayItem),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        // padding: EdgeInsets.only(
                        //     bottom:
                        //         MediaQuery.of(context).viewInsets.bottom),
                        // decoration: BoxDecoration(
                        //   color: Theme.of(context).primaryColor,
                        //   borderRadius: const BorderRadius.only(
                        //     topLeft: Radius.circular(30),
                        //     topRight: Radius.circular(30),
                        //   ),
                        // ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Consumer<ProviderLanguage>(builder:
                                        (context, providerLanguage, _) {
                                      return Text(
                                        DateFormat(
                                                'EEEE, d MMM',
                                                providerLanguage.currentLanguage
                                                    .languageCode)
                                            .format(_date),
                                        style: TextStyle(
                                          color: CustomColors.brown2
                                              .withOpacity(0.8),
                                          fontSize: 27.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 8.0),
                                    _holidayItems.isEmpty
                                        ? Text(
                                            AppLocalizations.of(context)!
                                                .noHoliday,
                                            //'No holiday',
                                            style: TextStyle(
                                              color: CustomColors.brown2
                                                  .withOpacity(0.3),
                                              fontSize: 20.0,
                                            ),
                                          )
                                        : Text(
                                            'Name of holiday',
                                            style: TextStyle(
                                              color: CustomColors.brown2
                                                  .withOpacity(0.3),
                                              fontSize: 20.0,
                                            ),
                                          ),
                                    const SizedBox(height: 20),
                                    _holidayItems.isNotEmpty
                                        ? Expanded(
                                            child: Column(
                                              children: _holidayItems,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(height: 2.0)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
  }

  void _onDayPressed(DateTime date, List<HolidayItem> holidayItem) {
    // debugPrint(DateFormat('yyyy-MM-dd').format(date));
    setState(() {
      _date = date;
    });

    _holidayItems.clear();
    _holidayItems.addAll(holidayItem);
    // _open(date);
    // _checkIfIsLoggedIn(date);
  }
}

// _open(DateTime date) {
//   showModalBottomSheet<void>(
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//           height: MediaQuery.of(context).size.height * 0.45,
//           padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom),
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(30),
//               topRight: Radius.circular(30),
//             ),
//           ),
//           child: Column(
//             children: [
//               ListTile(
//                 title: Center(
//                   child: Container(
//                     height: 8,
//                     width: 170,
//                     decoration: BoxDecoration(
//                       color: globals.brown1,
//                       borderRadius:
//                       const BorderRadius.all(Radius.circular(300.0)),
//                     ),
//                   ),
//                 ),
//                 // title: Icon(
//                 //   Icons.keyboard_arrow_down,
//                 //   size: 36,
//                 // ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: 10000,
//                   padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         DateFormat('EEEE, MMM d').format(date),
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .textTheme
//                               .bodyMedium
//                               ?.color
//                               ?.withOpacity(0.8),
//                           fontSize: 27.0,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(
//                         'No holiday',
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .textTheme
//                               .bodyMedium
//                               ?.color
//                               ?.withOpacity(0.3),
//                           fontSize: 20.0,
//                         ),
//                       ),
//                       const SizedBox(height: 30)
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ));
//     },
//   ).then((exit) {});
// }
