import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/remote/apis_model.dart';
import 'package:hudra/remote/request.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/view/bible_page.dart';
import 'package:hudra/view/calendar_page.dart';
import 'package:hudra/view/daily_page.dart';
import 'package:hudra/view/discover_page.dart';
import 'package:hudra/view/error_page.dart';
import 'package:hudra/view/holiday_prayer_page.dart';
import 'package:hudra/view/info_view.dart';
import 'package:hudra/view/notifications_page.dart';
import 'package:hudra/view/prayers_page.dart';
import 'package:hudra/view/rituals_page.dart';
import 'package:hudra/view/saved_verses_page.dart';
import 'package:hudra/view/settings_page.dart';
import 'package:hudra/view/web_page.dart';
import 'package:hudra/widgets/AppBars/bible_appbar.dart';
import 'package:hudra/widgets/AppBars/calendar_appbar.dart';
import 'package:hudra/widgets/AppBars/daily_appbar.dart';
import 'package:hudra/widgets/AppBars/discover_appbar.dart';
import 'package:hudra/widgets/AppBars/holiday_prayer_appbar.dart';
import 'package:hudra/widgets/AppBars/info_appbar.dart';
import 'package:hudra/widgets/AppBars/notifications_appbar.dart';
import 'package:hudra/widgets/AppBars/prayers_appbar.dart';
import 'package:hudra/widgets/AppBars/rituals_appbar.dart';
import 'package:hudra/widgets/AppBars/saved_verses_appbar.dart';
import 'package:hudra/widgets/AppBars/settings_appbar.dart';
import 'package:hudra/widgets/Other/custom_navigationbar.dart';
import 'package:hudra/widgets/Other/myDrawer.dart';
import 'package:hudra/widgets/other/Responsive.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _k = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setSystemUIOverlayStyle());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderGlobal>(builder: (context, globalProvider, _) {
      return Scaffold(
        extendBodyBehindAppBar: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => APISModel().loadPrayers(),
        // ),
        appBar: Responsive.isMobile(context)
            ? globalProvider.currentPage == 'DailyPage'
                ? DailyAppBar(
                    primaryColor: Theme.of(context).primaryColor,
                    context: context,
                  )
                : globalProvider.currentPage == 'CalendarPage'
                    ? globalProvider.isCalendar == 0
                        ? CalendarAppBar(
                            primaryColor: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.color,
                            secondaryColor: CustomColors.brown1,
                            context: context,
                          )
                        : HolidayPrayerAppBar(
                            primaryColor: Theme.of(context).primaryColorDark,
                            secondaryColor:
                                Theme.of(context).textTheme.bodySmall?.color,
                            context: context,
                          )
                    : globalProvider.currentPage == 'BiblePage'
                        ? BibleAppBar(
                            primaryColor: Theme.of(context).primaryColorDark,
                            secondaryColor:
                                Theme.of(context).textTheme.bodySmall?.color,
                            context: context,
                          )
                        : globalProvider.currentPage == 'PrayersPage'
                            ? PrayersAppBar(
                                primaryColor:
                                    Theme.of(context).primaryColorDark,
                                secondaryColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                context: context,
                              )
                            : globalProvider.currentPage == 'RitualsPage'
                                ? RitualsAppBar(
                                    primaryColor:
                                        Theme.of(context).primaryColorDark,
                                    secondaryColor: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    context: context,
                                  )
                                : globalProvider.currentPage == 'SettingsPage'
                                    ? SettingsAppBar(
                                        primaryColor:
                                            Theme.of(context).primaryColorDark,
                                        secondaryColor: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                        context: context,
                                      )
                                    : globalProvider.currentPage ==
                                            'DiscoverPage'
                                        ? DiscoverAppBar(
                                            primaryColor: Theme.of(context)
                                                .primaryColorDark,
                                            secondaryColor: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                            context: context,
                                          )
                                        : globalProvider.currentPage ==
                                                'NotificationsPage'
                                            ? NotificationsAppbar(
                                                primaryColor: Theme.of(context)
                                                    .primaryColorDark,
                                                secondaryColor:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color,
                                                context: context,
                                              )
                                            : globalProvider.currentPage ==
                                                    'SavedVersesPage'
                                                ? SavedVersesAppBar(
                                                    primaryColor:
                                                        Theme.of(context)
                                                            .primaryColorDark,
                                                    secondaryColor:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.color,
                                                    context: context,
                                                  )
                                                : globalProvider.currentPage ==
                                                        'InfoPage'
                                                    ? InfoAppBar(
                                                        primaryColor: Theme.of(
                                                                context)
                                                            .primaryColorDark,
                                                        secondaryColor:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.color,
                                                        context: context,
                                                      )
                                                    : null
            : null,
        drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).primaryColorDark,
        bottomNavigationBar:
            Responsive.isMobile(context) ? const CustomNavigationBar() : null,
        body: Responsive(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomNavigationBar(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: onPagesChangeWeb(
                  index: globals.currentPageList.indexOf(
                    globalProvider.currentPage,
                  ),
                  isCalendar: globalProvider.isCalendar,
                ),
              )),
            ],
          ),
          mobile: onPagesChange(
            index: globals.currentPageList.indexOf(
              globalProvider.currentPage,
            ),
            isCalendar: globalProvider.isCalendar,
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () async {
        //     RequestModel request = RequestModel();
        //     request.url += "CRUD/php_mysql/ReadData.php";
        //     request.body = <String, dynamic>{
        //       "tableName": "BibleEnglish",
        //     };
        //     var result = await http.post(
        //       Uri.parse(request.url),
        //       headers: request.headers,
        //       body: json.encode(request.body),
        //     );
        //     print(result.body);
        //   },
        // ),
        // IndexedStack(
        //   index: globals.currentPageList.indexOf(globalProvider.currentPage),
        //   children: [
        //     const DailyPage(),
        //     IndexedStack(
        //       index: globalProvider.isCalendar,
        //       children: const [
        //         CalendarPage(
        //             // key: ValueKey(_k++), // Reset on today
        //             ),
        //         HolidayPrayerPage(),
        //       ],
        //     ),
        //     const RitualsPage(),
        //     const ErrorPage(//BiblePage
        //         ),
        //     const SettingsPage(),
        //     const DiscoverPage(),
        //     const NotificationsPage(),
        //     const SavedVersesPage(),
        //   ],
        // ),
      );
    });
  }

  Widget onPagesChangeWeb({required int index, required int isCalendar}) {
    switch (index) {
      /// Web Page
      /// Calendar Page
      case 0:
      case 1:
        return WebPage(isCalendar: isCalendar);

      // /// Calendar Page
      // case 1:
      //   switch (isCalendar) {
      //     // Calendar Page
      //     case 0:
      //       return WebPage();
      //     // HolidayPrayer Page
      //     case 1:
      //       return HolidayPrayerPage();
      //     default:
      //       return const ErrorPage();
      //   }

      /// Rituals Page
      case 2:
        return const RitualsPage();

      /// Prayers Page
      case 3:
        return const PrayersPage();

      /// Bible Page
      case 4:
        return const BiblePage();

      /// Settings Page
      case 5:
        return const SettingsPage();

      /// DiscoverPage
      case 6:
        return const DiscoverPage();

      /// Notifications Page
      case 7:
        return const NotificationsPage();

      /// SavedVerses Page
      case 8:
        return const SavedVersesPage();

      /// Info Page
      case 9:
        return const InfoView();

      default:
        return const ErrorPage();
    }
  }

  Widget onPagesChange({required int index, required int isCalendar}) {
    switch (index) {
      /// Daily Page
      case 0:
        return const DailyPage();

      /// Calendar Page
      case 1:
        switch (isCalendar) {
          // Calendar Page
          case 0:
            return CalendarPage();
          // HolidayPrayer Page
          case 1:
            return HolidayPrayerPage();
          default:
            return const ErrorPage();
        }

      /// Rituals Page
      case 2:
        return const RitualsPage();

      /// Rituals Page
      case 3:
        return const PrayersPage();

      /// Bible Page
      case 4:
        return const BiblePage();

      /// Settings Page
      case 5:
        return const SettingsPage();

      /// DiscoverPage
      case 6:
        return const DiscoverPage();

      /// Notifications Page
      case 7:
        return const NotificationsPage();

      /// SavedVerses Page
      case 8:
        return const SavedVersesPage();

      /// Info Page
      case 9:
        return const InfoView();

      default:
        return const ErrorPage();
    }
  }

  void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: CustomColors.brown2,
    ));
  }
}
