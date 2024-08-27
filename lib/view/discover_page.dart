import 'dart:async';
import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/data/data.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/view/prayer_detail_page.dart';
import 'package:hudra/view/reference_page.dart';
import 'package:hudra/widgets/other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/other/search_field.dart';
import 'package:hudra/widgets/prayer_page/prayer_item.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final int _maxSearchList = 10;
  List<String> _last10SearchList = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // _loadSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Provider.of<ProviderGlobal>(context).goBackAll(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Column(
          children: [
            SearchField(
                textEditingController: _textEditingController,
                changeLast10Search: (newValue) =>
                    _changeLast10Search(newValue)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FutureBuilder(
                  future: _loadSession(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapShot) {
                    if (snapShot.hasData) {
                      List<Widget> tmpList = [];
                      for (String element in snapShot.data) {
                        tmpList.add(
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              if (_textEditingController.text != element) {
                                setState(() {
                                  _textEditingController.text = element;
                                });
                              }
                              _changeLast10Search(element);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(18.0))),
                              child: Text(
                                element,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: CustomColors.brown1,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          children: tmpList.reversed.toList(),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(
                          color: Theme.of(context).textTheme.bodySmall?.color),
                    );
                  }),
            ),
            Provider.of<PrayersData>(context).listOfPrayersBySearch == []
                ? const SizedBox.shrink()
                : Expanded(
                    child: ScrollConfiguration(
                      behavior:
                          MyCustomScrollBehavior().copyWith(overscroll: false),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: Provider.of<PrayersData>(context)
                              .listOfPrayersBySearch
                              .length,
                          itemBuilder: (context, index) {
                            return PrayerItem(
                              prayerObject: PrayersData.listOfPrayers[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrayerDetailsPage(
                                            prayerObject: PrayersData
                                                .listOfPrayers[index],
                                          )),
                                );
                              },
                            );
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLast10Search(String newValue) async {
    newValue = newValue.trim();
    if (_last10SearchList.contains(newValue)) {
      _last10SearchList.removeWhere((element) => element == newValue);
      // setState(() {});
      // return;
    } else {
      if (_last10SearchList.length > _maxSearchList) {
        _last10SearchList.removeAt(0);
      }
    }
    setState(() {
      _last10SearchList.add(newValue);
    });
    // _last10SearchList.clear();
    GetStorageHelper().setLast10Search(last10SearchList: _last10SearchList);

    await _loadPrayers(holidayNameLike: newValue);
  }

  Future<List<String>> _loadSession() async {
    List<dynamic> tmp = GetStorageHelper().getLast10Search();
    _last10SearchList = [];
    for (var element in tmp) {
      _last10SearchList.add(element.toString());
    }
    // _last10SearchList = await SessionManager().get('last10Search') ?? [];
    // setState(() {
    return _last10SearchList;
    // _k++;
    // });
  }

  _loadPrayers({required String holidayNameLike}) async {
    // globals.currentPage = 'CalendarPage';
    // globals.isCalendar = 1;
    // globals.holidayName = holidayName;
    // seState();
    debugPrint("the holiday is $holidayNameLike");
    await Future.delayed(Duration.zero, () {
      String holidayNameTMP = holidayNameLike;
      // Provider.of<ProviderGlobal>(context, listen: false).holidayName;

      if (GetStorageHelper().getPrayersLanguageInEnglish() == "Arabic") {
        for (var element in holidaysNames) {
          if (element["en"] == holidayNameTMP) {
            holidayNameTMP = element["ar"];
            break;
          }
        }
      }

      if (GetStorageHelper().getPrayersLanguageInEnglish() == "Syriac") {
        for (var element in holidaysNames) {
          if (element["en"] == holidayNameTMP) {
            holidayNameTMP = element["syr"];
            break;
          }
        }
      }

      Provider.of<PrayersData>(context, listen: false).loadHolidayBySearch(
          context: context, holidayNameLike: holidayNameTMP);
    });
  }
}
