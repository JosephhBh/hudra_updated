import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/widgets/other/MyCustomScrollBehavior.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color:
            Theme.of(context).textTheme.headlineMedium?.color, //globals.blue1,
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: ListView(
            controller: ScrollController(),
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 10.0),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: IndexedStack(
                      index: Provider.of<ProviderTheme>(context).themeMode ==
                              'light'
                          ? 0
                          : 1,
                      children: [
                        Image.asset(
                          'Assets/Images/crossLight.png',
                          fit: BoxFit.contain,
                        ),
                        Image.asset(
                          'Assets/Images/crossDark.png',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(
                    thickness: 1.0,
                    color: Colors.white70,
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        MenuItem(
                          text: AppLocalizations.of(context)!.dailyVerses,
                          //'Daily Verses',
                          imageString: 'Assets/Icons/timer(1).svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          onClicked: () => selectedItem(context, 0),
                        ),
                        const SizedBox(height: 5),
                        MenuItem(
                          text: AppLocalizations.of(context)!.fullCalendar,
                          //'Full Calendar',
                          imageString: 'Assets/Icons/calendar.svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          onClicked: () => selectedItem(context, 1),
                        ),
                        const SizedBox(height: 5),
                        MenuItem(
                          text: AppLocalizations.of(context)!.bible,
                          //'Bible',
                          imageString: 'Assets/Icons/book.svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          onClicked: () => selectedItem(context, 2),
                        ),
                        const SizedBox(height: 5),
                        !kIsWeb
                            ? MenuItem(
                                text: AppLocalizations.of(context)!.savedVerses,
                                //'Saved Verses',
                                imageString: 'Assets/Icons/heart.svg',
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                                onClicked: () => selectedItem(context, 3),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 5),
                        MenuItem(
                          text: AppLocalizations.of(context)!.darkMode,
                          //'Dark Mode',
                          widget: GFToggle(
                            // key: const ValueKey(0),
                            value:
                                Provider.of<ProviderTheme>(context).themeMode ==
                                    'dark',
                            type: GFToggleType.ios,
                            enabledThumbColor: CustomColors.brown1,
                            enabledTrackColor:
                                Theme.of(context).textTheme.bodySmall?.color,
                            onChanged: (bool? value) async {
                              // _isDark = value!;
                              await selectedItem(context, 4);
                            },
                          ),
                          imageString: 'Assets/Icons/moon.svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          // onClicked: () => ,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: SvgPicture.asset(
                                  'Assets/Icons/global.svg',
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Row(
                                  children: [
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () => selectedItem(context, 5),
                                      child: Text(
                                        'EN',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                          fontWeight:
                                              Provider.of<ProviderLanguage>(
                                                      context)
                                                  .setFontWeight('en'),
                                          fontSize:
                                              Provider.of<ProviderLanguage>(
                                                      context)
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
                                          fontSize: 17),
                                    ),
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () => selectedItem(context, 6),
                                      child: Text(
                                        'AR',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                          fontWeight:
                                              Provider.of<ProviderLanguage>(
                                                      context)
                                                  .setFontWeight('ar'),
                                          fontSize:
                                              Provider.of<ProviderLanguage>(
                                                      context)
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
                                          fontSize: 17),
                                    ),
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () => selectedItem(context, 7),
                                      child: Text(
                                        'SYR',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                          fontWeight:
                                              Provider.of<ProviderLanguage>(
                                                      context)
                                                  .setFontWeight('syr'),
                                          fontSize:
                                              Provider.of<ProviderLanguage>(
                                                      context)
                                                  .setFontSize('syr'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // const SizedBox(height: 8),
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
                        const SizedBox(height: 12),
                        MenuItem(
                          text:
                              // AppLocalizations.of(context)!.darkMode,
                              'Information',
                          imageString: 'Assets/info/info.svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          onClicked: () async => await selectedItem(context, 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0: // My DailyPage
        if (Provider.of<ProviderGlobal>(context, listen: false).currentPage !=
            'DailyPage') {
          Provider.of<ProviderGlobal>(context, listen: false).goTo('DailyPage');
        }
        Navigator.of(context).pop();
        break;
      case 1: // CalendarPage
        if (Provider.of<ProviderGlobal>(context, listen: false).currentPage !=
            'CalendarPage') {
          Provider.of<ProviderGlobal>(context, listen: false)
              .goTo('CalendarPage');
        }
        Navigator.of(context).pop();
        // widget.setState();
        break;
      case 2: // BiblePage
        if (Provider.of<ProviderGlobal>(context, listen: false).currentPage !=
            'BiblePage') {
          Provider.of<ProviderGlobal>(context, listen: false).goTo('BiblePage');
        }
        Navigator.of(context).pop();
        // widget.setState();
        break;
      case 3: // SavedVerses
        if (Provider.of<ProviderGlobal>(context, listen: false).currentPage !=
            'SavedVersesPage') {
          Provider.of<ProviderGlobal>(context, listen: false)
              .goTo('SavedVersesPage');
        }
        Navigator.of(context).pop();
        break;
      case 4: // Change Theme
        Provider.of<ProviderTheme>(context, listen: false).setThemeMode();
        break;
      case 5: // Make EN
        Provider.of<ProviderLanguage>(context, listen: false).setLanguageEn();
        Provider.of<ProviderDaily>(context, listen: false).holidays.clear();
        break;

      case 6: // Make AR
        Provider.of<ProviderLanguage>(context, listen: false).setLanguageAr();
        Provider.of<ProviderDaily>(context, listen: false).holidays.clear();
        break;

      case 7: // Make Syr
        Provider.of<ProviderLanguage>(context, listen: false).setLanguageSyr();
        Provider.of<ProviderDaily>(context, listen: false).holidays.clear();
        break;

      case 8: // Info
        if (Provider.of<ProviderGlobal>(context, listen: false).currentPage !=
            'InfoPage') {
          Provider.of<ProviderGlobal>(context, listen: false).goTo('InfoPage');
        }
        Navigator.of(context).pop();
        break;
    }
  }
}

class MenuItem extends StatelessWidget {
  String text;
  Widget? widget;
  String imageString;
  Color? color;
  VoidCallback? onClicked;

  MenuItem({
    required this.text,
    this.widget = const SizedBox.shrink(),
    required this.imageString,
    required this.color,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color color = globals.whiteBlue;//Colors.white;
    Color hoverColor = Colors.transparent.withOpacity(1); //Colors.white70;

    return ListTile(
      leading: SizedBox(
          height: 22,
          width: 22,
          child: SvgPicture.asset(imageString, color: color)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(color: color, fontSize: 14)),
          widget!
        ],
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return TextField(
      style: const TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(
          Icons.search,
          color: color,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
