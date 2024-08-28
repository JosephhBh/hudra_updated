import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/home/fading_images_slider.dart';
import 'package:hudra/widgets/home/verse_container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int _k = 0;

  @override
  void initState() {
    // TODO: implement initState
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
      if (mounted) {
        loadVerses();
      }
    });

    super.initState();
  }

  String? _holidayOfToday = null;

  loadVerses() async {
    try {
      String condition = "WHERE isSelected = 1 ORDER BY rand() LIMIT 3";

      await Future.delayed(Duration.zero, () async {
        await Provider.of<ProviderDaily>(context, listen: false)
            .loadDailyVerses(condition: condition, isWeb: false);
        _holidayOfToday = Provider.of<ProviderDaily>(context, listen: false)
            .getHolidayOfToday(context: context, isWeb: false);
      });
    } catch (e) {
      print("loadVerses.ERROR : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton(
        //   child: Text("print"),
        //   onPressed: () async {
        //     // print(await DatabaseHelper.queryDailyVerses("BibleEnglish"));
        //     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        //   },
        // ),
        Container(
          height: MediaQuery.of(context).size.height * 0.12,
          //110,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(22.0),
              bottomRight: Radius.circular(22.0),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<ProviderLanguage>(
                        builder: (context, providerLanguage, _) {
                      return Text(
                        DateFormat('EEEE, dd MMMM, yyyy',
                                providerLanguage.currentLanguage.languageCode)
                            .format(DateTime.now())
                            .toString(),
                        // 'Monday, 22 June, 2022',
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.8),
                          fontSize: 19.0,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      height: 40,
                      child: Text(
                        // "",
                        // 'Monday of the twelfth week in ordinary time.',
                        _holidayOfToday ??
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
              const SizedBox(width: 30),
            ],
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child:
                  Consumer<ProviderDaily>(builder: (context, providerDaily, _) {
                return Container(
                  key: ValueKey(_k++),
                  height: MediaQuery.of(context).size.height * 0.48,
                  margin: const EdgeInsets.only(top: 16),
                  child: FadingImagesSlider(
                    activeIconColor:
                        Provider.of<ProviderTheme>(context).themeMode == 'dark'
                            ? CustomColors.brown2
                            : CustomColors.brown3,
                    passiveIconColor:
                        Provider.of<ProviderTheme>(context).themeMode == 'dark'
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
            ),
          ),
        ),
      ],
    );
  }
}
