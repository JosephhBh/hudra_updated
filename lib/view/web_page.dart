import 'package:flutter/material.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/view/calendar_page.dart';
import 'package:hudra/view/daily_page.dart';
import 'package:hudra/view/discover_page.dart';
import 'package:hudra/view/error_page.dart';
import 'package:hudra/view/holiday_prayer_page.dart';
import 'package:hudra/view/notifications_page.dart';
import 'package:hudra/view/prayers_page.dart';
import 'package:hudra/view/saved_verses_page.dart';
import 'package:hudra/view/settings_page.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/Other/custom_navigationbar.dart';
import 'package:hudra/widgets/home/fading_images_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WebPage extends StatefulWidget {
  int isCalendar = 0;

  WebPage({Key? key, required this.isCalendar}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  int _k = 0;

  @override
  void initState() {
    // TODO: implement initState

    ///Kenet 3emle mshekel 3al back
    widget.isCalendar = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // String? condition;
      // while(GetStorageHelper().getChurchName() == null){
      //   await Future.delayed(const Duration(seconds: 1));
      // }
      // if (GetStorageHelper().getChurchName() == "SyriacChurch") {
      //   condition = "WHERE isSyriac = '1'";
      // }
      // if (GetStorageHelper().getChurchName() == "ChaldeanChurch") {
      //   condition = "WHERE isChaldean = '1'";
      // }
      String condition = "WHERE isSelected = 1 ORDER BY rand() LIMIT 3";
      if (mounted) {
        await Provider.of<ProviderDaily>(context, listen: false)
            .loadDailyVerses(condition: condition, isWeb: true);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _isCalendarWidget()),
        ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(right: 16.0, left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.brown2,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<ProviderLanguage>(
                            builder: (context, providerLanguage, _) {
                          return Text(
                            DateFormat(
                                    'EEEE, dd MMMM, yyyy',
                                    providerLanguage
                                        .currentLanguage.languageCode)
                                .format(DateTime.now())
                                .toString(),
                            // 'Monday, 22 June, 2022',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.8),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 45,
                          child: Text(
                            // 'Monday of the twelfth week in ordinary time.',
                            Provider.of<ProviderDaily>(context)
                                    .getHolidayOfToday(
                                        context: context, isWeb: true) ??
                                "${AppLocalizations.of(context)!.noHoliday}.",
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.fade,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.3),
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Consumer<ProviderDaily>(builder: (context, providerDaily, _) {
                    return providerDaily.verseContainerChildren.isEmpty
                        ? Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: CustomColors.brown2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                          )
                        : Container(
                            key: ValueKey(_k++),
                            height: !providerDaily
                                    .verseContainerChildren[0].isClicked
                                ? 200 //MediaQuery.of(context).size.height * 0.215
                                : 400, //MediaQuery.of(context).size.height * 0.43,
                            // height: 300,
                            margin: const EdgeInsets.only(top: 8),
                            child: FadingImagesSlider(
                              activeIconColor:
                                  Provider.of<ProviderTheme>(context)
                                              .themeMode ==
                                          'dark'
                                      ? CustomColors.brown2
                                      : CustomColors.brown3,
                              passiveIconColor:
                                  Provider.of<ProviderTheme>(context)
                                              .themeMode ==
                                          'dark'
                                      ? CustomColors.brown3
                                      : CustomColors.brown2,
                              // animationDuration: const Duration(seconds: 3),
                              autoFade: false,
                              images: providerDaily.verseContainerChildren,
                              // [
                              //   VerseContainer(
                              //     key: const ValueKey(0),
                              //     text:
                              //         '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren''',
                              //     reference: 'John 1:1',
                              //   ),
                              //   VerseContainer(
                              //     key: const ValueKey(1),
                              //     text: 'Empty',
                              //   ),
                              //   VerseContainer(
                              //     key: const ValueKey(2),
                              //     text: '',
                              //   ),
                              // ],
                              iconSize: 10,
                            ),
                          );
                  }),
                  const SizedBox(height: 8.0),
                  CalendarPage(isWeb: true),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _isCalendarWidget() {
    switch (widget.isCalendar) {
      // Calendar Page
      case 0:
        return const SizedBox.shrink();
      // HolidayPrayer Page
      case 1:
        return HolidayPrayerPage(
          isWeb: true,
        );
      default:
        return const ErrorPage();
    }
  }
}
