import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/loaded_data/rituals_data.dart';
import 'package:hudra/controller/other/is_rtl.dart';
import 'package:hudra/controller/settings_provider/book_mode_provider.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/controller/settings_provider/provider_notifications.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'English';
  bool _isSelectPrayerLanguage = false;

  // double _selectedTextSize = 14;
  bool _isBookMode = false;

  int _k = 0;

  @override
  void initState() {
    // TODO: implement initState
    _loadSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _back(),
      child: !_isSelectPrayerLanguage
          ? ScrollConfiguration(
              behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Padding(
                  padding: EdgeInsets.only(
                    // top: 45.0,
                    top: 8.0,
                    left: isRTL(context) ? 0.0 : 30.0,
                    right: isRTL(context) ? 30.0 : 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.general, //'General',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .darkMode, //'Dark Mode',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          Row(
                            children: [
                              GFToggle(
                                  key: ValueKey(_k++),
                                  value: Provider.of<ProviderTheme>(context)
                                          .themeMode ==
                                      'dark',
                                  type: GFToggleType.ios,
                                  enabledThumbColor:
                                      Theme.of(context).primaryColorDark,
                                  enabledTrackColor: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  onChanged: (bool? value) =>
                                      Provider.of<ProviderTheme>(context,
                                              listen: false)
                                          .setThemeMode()),
                              const SizedBox(width: 30.0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.pushNotifications,
                              //'Push Notifications',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          Row(
                            children: [
                              GFToggle(
                                key: ValueKey(_k++),
                                value:
                                    Provider.of<ProviderNotifications>(context)
                                        .isNotificationEnable,
                                type: GFToggleType.ios,
                                enabledThumbColor:
                                    Theme.of(context).primaryColorDark,
                                enabledTrackColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                onChanged: (bool? value) =>
                                    _notificationChange(value!),
                              ),
                              const SizedBox(width: 30.0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Divider(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .color
                            ?.withOpacity(0.3),
                        thickness: 2.0,
                        indent: 0.0,
                        endIndent: 30.0,
                        height: 2.0,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.churchSyriac,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          Row(
                            children: [
                              GFToggle(
                                key: ValueKey(_k++),
                                value: Provider.of<ProviderChurch>(context)
                                        .churchName ==
                                    "Syriac",
                                type: GFToggleType.ios,
                                enabledThumbColor:
                                    Theme.of(context).primaryColorDark,
                                enabledTrackColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                onChanged: (bool? value) {
                                  Provider.of<ProviderDaily>(context,
                                          listen: false)
                                      .holidays
                                      .clear();
                                  if (value!) {
                                    Provider.of<ProviderChurch>(context,
                                            listen: false)
                                        .setChurchName("Syriac", true);
                                    return;
                                  }
                                  Provider.of<ProviderChurch>(context,
                                          listen: false)
                                      .setChurchName("Chaldean", true);
                                },
                              ),
                              const SizedBox(width: 30.0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.churchChaldean,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          Row(
                            children: [
                              GFToggle(
                                key: ValueKey(_k++),
                                value: Provider.of<ProviderChurch>(context)
                                        .churchName ==
                                    "Chaldean",
                                type: GFToggleType.ios,
                                enabledThumbColor:
                                    Theme.of(context).primaryColorDark,
                                enabledTrackColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                onChanged: (bool? value) {
                                  Provider.of<ProviderDaily>(context,
                                          listen: false)
                                      .holidays
                                      .clear();
                                  if (value!) {
                                    Provider.of<ProviderChurch>(context,
                                            listen: false)
                                        .setChurchName("Chaldean", true);
                                    return;
                                  }
                                  Provider.of<ProviderChurch>(context,
                                          listen: false)
                                      .setChurchName("Syriac", true);
                                },
                              ),
                              const SizedBox(width: 30.0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Divider(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .color
                            ?.withOpacity(0.3),
                        thickness: 2.0,
                        indent: 0.0,
                        endIndent: 30.0,
                        height: 2.0,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .language, //'Language',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          Row(
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  Provider.of<ProviderLanguage>(context,
                                          listen: false)
                                      .setLanguageEn();

                                  Provider.of<ProviderDaily>(context,
                                          listen: false)
                                      .holidays
                                      .clear();
                                },
                                child: Text(
                                  'EN',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontWeight:
                                        Provider.of<ProviderLanguage>(context)
                                            .setFontWeight('en'),
                                    fontSize:
                                        Provider.of<ProviderLanguage>(context)
                                            .setFontSize('en'),
                                  ),
                                ),
                              ),
                              Text(
                                ' | ',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 14),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  Provider.of<ProviderLanguage>(context,
                                          listen: false)
                                      .setLanguageAr();

                                  Provider.of<ProviderDaily>(context,
                                          listen: false)
                                      .holidays
                                      .clear();
                                },
                                child: Text(
                                  'AR',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontWeight:
                                        Provider.of<ProviderLanguage>(context)
                                            .setFontWeight('ar'),
                                    fontSize:
                                        Provider.of<ProviderLanguage>(context)
                                            .setFontSize('ar'),
                                  ),
                                ),
                              ),
                              Text(
                                ' | ',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 14),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  Provider.of<ProviderLanguage>(context,
                                          listen: false)
                                      .setLanguageSyr();
                                  Provider.of<ProviderDaily>(context,
                                          listen: false)
                                      .holidays
                                      .clear();
                                },
                                child: Text(
                                  'SYR',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontWeight:
                                        Provider.of<ProviderLanguage>(context)
                                            .setFontWeight('syr'),
                                    fontSize:
                                        Provider.of<ProviderLanguage>(context)
                                            .setFontSize('syr'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30.0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.prayersLanguage,
                              //'Prayers Language',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          Row(
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () => setState(() {
                                  _isSelectPrayerLanguage = true;
                                }),
                                child: Row(
                                  children: [
                                    Text(
                                      _selectedLanguage,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withOpacity(0.3),
                                      ),
                                    ),
                                    // SizedBox(width: 10),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 23.5),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Divider(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .color
                            ?.withOpacity(0.3),
                        thickness: 2.0,
                        indent: 0.0,
                        endIndent: 30.0,
                        height: 2.0,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .textSize, //'Text Size',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 17)),
                          const Expanded(child: SizedBox()),
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () => Provider.of<ProviderTextSize>(context,
                                    listen: false)
                                .subTextSize(),
                            child: Text(AppLocalizations.of(context)!.a, //'A',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 14)),
                          ),
                          SizedBox(
                            width: 170, //210
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 2.0,
                                activeTrackColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                thumbColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                overlayColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.2),
                                inactiveTrackColor: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.3),
                                inactiveTickMarkColor:
                                    Colors.transparent.withOpacity(0.0),
                                activeTickMarkColor:
                                    Colors.transparent.withOpacity(0.0),
                              ),
                              child: Slider(
                                value: Provider.of<ProviderTextSize>(context)
                                    .textSize,
                                min: 0.8,
                                max: 2.0,
                                divisions: 16,
                                onChanged: (value) =>
                                    Provider.of<ProviderTextSize>(context,
                                            listen: false)
                                        .setTextSize(value),
                              ),
                            ),
                          ),
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () => Provider.of<ProviderTextSize>(context,
                                    listen: false)
                                .addTextSize(),
                            child: Text(AppLocalizations.of(context)!.a, //'A',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 28)),
                          ),
                          const SizedBox(width: 30.0),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.sizeExample,
                                //'Size Example',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                    fontSize: 17)),
                            const Expanded(child: SizedBox()),
                            Text('Lorem ipsum',
                                textScaleFactor:
                                    Provider.of<ProviderTextSize>(context)
                                        .textSize,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                )),
                            const SizedBox(width: 30.0),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Divider(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .color
                            ?.withOpacity(0.3),
                        thickness: 2.0,
                        indent: 0.0,
                        endIndent: 30.0,
                        height: 2.0,
                      ),
                      const SizedBox(height: 20),
                      kIsWeb
                          ? SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    AppLocalizations.of(context)!
                                        .bookMode, //'Book Mode',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                        fontSize: 17)),
                                Row(
                                  children: [
                                    Consumer<BookModeProvider>(builder:
                                        (context, bookModeProvider, _) {
                                      return GFToggle(
                                        key: ValueKey(_k++),
                                        value: bookModeProvider.isBookMode,
                                        type: GFToggleType.ios,
                                        enabledThumbColor:
                                            Theme.of(context).primaryColorDark,
                                        enabledTrackColor: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                        onChanged: (bool? value) async {
                                          bookModeProvider.setBookMode(value!);
                                          // setState(() {
                                          //   _isBookMode = value!;
                                          // });
                                          // GetStorageHelper().setBookMode(
                                          //     bookModeValue: value ?? false);
                                        },
                                      );
                                    }),
                                    const SizedBox(width: 30.0),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 45),
                  Text('Prayers Language',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  Container(
                    height: 220,
                    width: 350,
                    decoration: BoxDecoration(
                      color: CustomColors.brown2,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// English
                        InkWell(
                          onTap: () => _changePrayersLanguage('English'),
                          child: Row(
                            children: [
                              const SizedBox(width: 25),
                              SizedBox(
                                height: 53,
                                width: 300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('English',
                                        style: TextStyle(
                                            color: CustomColors.brown1,
                                            fontSize: 22)),
                                    _selectedLanguage == 'English'
                                        ? const Icon(
                                            Icons.done,
                                            size: 26,
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2.0,
                          indent: 20.0,
                          endIndent: 20.0,
                          height: 2.0,
                        ),

                        /// Arabic عربي
                        InkWell(
                          onTap: () => _changePrayersLanguage('عربي'),
                          child: Row(
                            children: [
                              const SizedBox(width: 25),
                              SizedBox(
                                height: 53,
                                width: 300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('عربي',
                                        style: TextStyle(
                                            color: CustomColors.brown1,
                                            fontSize: 22)),
                                    _selectedLanguage == 'عربي'
                                        ? const Icon(
                                            Icons.done,
                                            size: 26,
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2.0,
                          indent: 20.0,
                          endIndent: 20.0,
                          height: 2.0,
                        ),

                        /// Française
                        // InkWell(
                        //   onTap: () => _changePrayersLanguage('Française'),
                        //   child: Row(
                        //     children: [
                        //       const SizedBox(width: 25),
                        //       SizedBox(
                        //         height: 53,
                        //         width: 300,
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text('Française',
                        //                 style: TextStyle(
                        //                     color: CustomColors.brown1,
                        //                     fontSize: 22)),
                        //             _selectedLanguage == 'Française'
                        //                 ? const Icon(
                        //                     Icons.done,
                        //                     size: 26,
                        //                   )
                        //                 : const SizedBox.shrink(),
                        //           ],
                        //         ),
                        //       ),
                        //       const SizedBox(width: 25),
                        //     ],
                        //   ),
                        // ),
                        // const Divider(
                        //   thickness: 2.0,
                        //   indent: 20.0,
                        //   endIndent: 20.0,
                        //   height: 2.0,
                        // ),
                        /// A ܠܫܢܐ ܣܘܪܝܝܐ
                        InkWell(
                          onTap: () => _changePrayersLanguage('ܠܫܢܐ ܣܘܪܝܝܐ'),
                          child: Row(
                            children: [
                              const SizedBox(width: 25),
                              SizedBox(
                                height: 53,
                                width: 300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ܠܫܢܐ ܣܘܪܝܝܐ',
                                        style: TextStyle(
                                            color: CustomColors.brown1,
                                            fontSize: 22)),
                                    _selectedLanguage == 'ܠܫܢܐ ܣܘܪܝܝܐ'
                                        ? const Icon(
                                            Icons.done,
                                            size: 26,
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _changeLanguage() {}

  void _changePrayersLanguage(String language) async {
    setState(() {
      _selectedLanguage = language;
      _isSelectPrayerLanguage = false;
    });

    GetStorageHelper().setPrayersLanguage(lang: language);
    GetStorageHelper().deleteKey("bibleQueriedAt");
    await BibleData.loadBibles();
    await PrayersData.loadPrayers();
    await RitualsData.loadPrayers();
  }

  void _loadSession() {
    // if (mounted) {
    //   _selectedTextSize =
    //       Provider.of<GlobalSettings>(context, listen: false).textSize;
    // }
    _selectedLanguage = GetStorageHelper().getPrayersLanguage();
    _isBookMode = GetStorageHelper().getBookMode();

    setState(() {
      _selectedLanguage;
      _isBookMode;
      _k++;
    });
  }

  _back() {
    Provider.of<ProviderGlobal>(context, listen: false).goBackAll();
  }

  Future<void> _notificationChange(bool value) async {
    await Provider.of<ProviderNotifications>(context, listen: false)
        .setNotificationAndSession(value);
    // if(mounted){
    //   PhoenixNative.restartApp();
    // }
  }
}
