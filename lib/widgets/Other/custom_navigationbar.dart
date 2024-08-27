import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/loaded_data/rituals_data.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/widgets/Buttons/custom_navigationbar_button.dart';
import 'package:hudra/widgets/other/Responsive.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderGlobal>(builder: (context, globalProvider, _) {
      return Responsive(
        desktop: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 40.0),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Image.asset(
                  'Assets/Images/crossLight.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40.0),
              const Divider(
                thickness: 1.0,
                color: Colors.white70,
                indent: 12.0,
                endIndent: 12.0,
              ),
              const SizedBox(height: 40.0),

              ///DailyPage
              globalProvider.currentPage == 'DailyPage' ||
                      globalProvider.currentPage == 'CalendarPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString:
                          AppLocalizations.of(context)!.daily, //'Daily',
                      imageString: 'Assets/Icons/timer.svg',
                      onTap: () => debugPrint('DailyPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString:
                          AppLocalizations.of(context)!.daily, //'Daily',
                      imageString: 'Assets/Icons/timer(1).svg',
                      onTap: () => _dailyPage(),
                    ),
              const SizedBox(height: 32),
              // ///CalendarPage
              // globalProvider.currentPage == 'CalendarPage'
              //     ? CustomNavigationBarButton(
              //   isWeb: true,
              //   textString: AppLocalizations.of(context)!.calendar,
              //   //'Calendar',
              //   imageString: 'Assets/Icons/calendar(1).svg',
              //   onTap: () => debugPrint('CalendarPage'),
              // )
              //     : CustomNavigationBarButton(
              //   isWeb: true,
              //   textString: AppLocalizations.of(context)!.calendar,
              //   //'Calendar',
              //   imageString: 'Assets/Icons/calendar.svg',
              //   onTap: () => _calendarPage(),
              // ),
              // const SizedBox(height: 32),

              ///RitualPage
              globalProvider.currentPage == 'RitualsPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.rituals,
                      //'Rituals',
                      imageString: 'Assets/Icons/dove (1).svg',
                      onTap: () => debugPrint('RitualsPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.rituals,
                      //'Rituals',
                      imageString: 'Assets/Icons/dove.svg',
                      onTap: () => _ritualPage(),
                    ),
              const SizedBox(height: 32),

              ///PrayersPage
              globalProvider.currentPage == 'PrayersPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.prayers,
                      //'Rituals',
                      imageString: 'Assets/Icons/Group 139.svg',
                      onTap: () => debugPrint('PrayersPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.prayers,
                      //'Rituals',
                      imageString: 'Assets/Icons/Path 3684.svg',
                      onTap: () => _prayerPage(),
                    ),
              const SizedBox(height: 32),

              ///BiblePage
              globalProvider.currentPage == 'BiblePage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString:
                          AppLocalizations.of(context)!.bible, //'Bible',
                      imageString: 'Assets/Icons/book(1).svg',
                      onTap: () => debugPrint('BiblePage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString:
                          AppLocalizations.of(context)!.bible, //'Bible',
                      imageString: 'Assets/Icons/book.svg',
                      onTap: () => _biblePage(),
                    ),
              const SizedBox(height: 32),

              /// Sicover Page
              globalProvider.currentPage == 'DiscoverPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.discover,
                      //'Settings',
                      imageString: 'Assets/Icons/search-normal.svg',
                      onTap: () => debugPrint('DiscoverPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.discover,
                      //'Settings',
                      imageString: 'Assets/Icons/search-normal.svg',
                      onTap: () => _discoverPage(),
                    ),
              const SizedBox(height: 32.0),

              /// Notifications Page
              globalProvider.currentPage == 'NotificationsPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.notifications,
                      //'Settings',
                      imageString: 'Assets/Icons/notification.svg',
                      onTap: () => debugPrint('NotificationsPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.notifications,
                      //'Settings',
                      imageString: 'Assets/Icons/notification.svg',
                      onTap: () => _notificationsPage(),
                    ),
              const SizedBox(height: 32.0),

              ///SettingsPage
              globalProvider.currentPage == 'SettingsPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.settings,
                      //'Settings',
                      imageString: 'Assets/Icons/setting-2(1).svg',
                      onTap: () => debugPrint('SettingsPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString: AppLocalizations.of(context)!.settings,
                      //'Settings',
                      imageString: 'Assets/Icons/setting-2.svg',
                      onTap: () => _settingsPage(),
                    ),
              const SizedBox(height: 32),

              ///InfoPage
              globalProvider.currentPage == 'InfoPage'
                  ? CustomNavigationBarButton(
                      isWeb: true,
                      textString: 'Info',
                      // AppLocalizations.of(context)!.settings,

                      imageString: 'Assets/info/info filled.svg',
                      onTap: () => debugPrint('InfoPage'),
                    )
                  : CustomNavigationBarButton(
                      isWeb: true,
                      textString: 'Info',
                      // AppLocalizations.of(context)!.settings,

                      imageString: 'Assets/info/info.svg',
                      onTap: () => _infoPage(),
                    ),
            ],
          ),
        ),
        mobile: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Provider.of<ProviderGlobal>(context).currentPage ==
                      'DailyPage'
                  ? 6.0
                  : 0.0),
          child: Stack(
            children: [
              globalProvider.currentPage == 'CalendarPage' &&
                      globalProvider.isCalendar == 0
                  ? Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 73),
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22.0),
                    topRight: Radius.circular(22.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///DailyPage
                    globalProvider.currentPage == 'DailyPage'
                        ? CustomNavigationBarButton(
                            textString:
                                AppLocalizations.of(context)!.daily, //'Daily',
                            imageString: 'Assets/Icons/timer.svg',
                            onTap: () => debugPrint('DailyPage'),
                          )
                        : CustomNavigationBarButton(
                            textString:
                                AppLocalizations.of(context)!.daily, //'Daily',
                            imageString: 'Assets/Icons/timer(1).svg',
                            onTap: () => _dailyPage(),
                          ),

                    ///CalendarPage
                    globalProvider.currentPage == 'CalendarPage'
                        ? CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.calendar,
                            //'Calendar',
                            imageString: 'Assets/Icons/calendar(1).svg',
                            onTap: () => debugPrint('CalendarPage'),
                          )
                        : CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.calendar,
                            //'Calendar',
                            imageString: 'Assets/Icons/calendar.svg',
                            onTap: () => _calendarPage(),
                          ),

                    ///RitualPage
                    globalProvider.currentPage == 'RitualsPage'
                        ? CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.rituals,
                            //'Rituals',
                            imageString: 'Assets/Icons/dove (1).svg',
                            onTap: () => debugPrint('RitualsPage'),
                          )
                        : CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.rituals,
                            //'Rituals',
                            imageString: 'Assets/Icons/dove.svg',
                            onTap: () => _ritualPage(),
                          ),

                    ///PrayersPage
                    globalProvider.currentPage == 'PrayersPage'
                        ? CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.prayers,
                            //'Rituals',
                            imageString: 'Assets/Icons/Group 139.svg',
                            onTap: () => debugPrint('PrayersPage'),
                          )
                        : CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.prayers,
                            //'Rituals',
                            imageString: 'Assets/Icons/Path 3684.svg',
                            onTap: () => _prayerPage(),
                          ),

                    ///BiblePage
                    globalProvider.currentPage == 'BiblePage'
                        ? CustomNavigationBarButton(
                            textString:
                                AppLocalizations.of(context)!.bible, //'Bible',
                            imageString: 'Assets/Icons/book(1).svg',
                            onTap: () => debugPrint('BiblePages'),
                          )
                        : CustomNavigationBarButton(
                            textString:
                                AppLocalizations.of(context)!.bible, //'Bible',
                            imageString: 'Assets/Icons/book.svg',
                            onTap: () => _biblePage(),
                          ),

                    ///SettingsPage
                    globalProvider.currentPage == 'SettingsPage'
                        ? CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.settings,
                            //'Settings',
                            imageString: 'Assets/Icons/setting-2(1).svg',
                            onTap: () => debugPrint('SettingsPage'),
                          )
                        : CustomNavigationBarButton(
                            textString: AppLocalizations.of(context)!.settings,
                            //'Settings',
                            imageString: 'Assets/Icons/setting-2.svg',
                            onTap: () => _settingsPage(),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  bool _checkPage(String pageName) {
    if (Provider.of<ProviderGlobal>(context, listen: false).currentPage !=
        pageName) {
      debugPrint(pageName);
      // widget.onTap();
      if (mounted) {
        // setState(() {
        // globals.previousPage = 'DailyPage';
        // globals.currentPage = pageName;
        Provider.of<ProviderGlobal>(context, listen: false)
            .goToFromHome(pageName);
        // });
      }
      return true;
    }
    return false;
  }

  _dailyPage() {
    if (_checkPage('DailyPage')) {}
  }

  _calendarPage() {
    if (_checkPage('CalendarPage')) {}
  }

  Future<void> _ritualPage() async {
    await RitualsData.loadPrayers();
    if (_checkPage('RitualsPage')) {}
  }

  Future<void> _prayerPage() async {
    await PrayersData.loadPrayers();
    if (_checkPage('PrayersPage')) {}
  }

  Future<void> _biblePage() async {
    await BibleData.loadBibles();
    if (_checkPage('BiblePage')) {}
  }

  _discoverPage() {
    if (_checkPage('DiscoverPage')) {}
  }

  _notificationsPage() {
    if (_checkPage('NotificationsPage')) {}
  }

  _settingsPage() {
    if (_checkPage('SettingsPage')) {}
  }

  _infoPage() {
    if (_checkPage('InfoPage')) {}
  }
}
