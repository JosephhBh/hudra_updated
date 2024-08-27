import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/prayers_provider/provider_prayers.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Prayers/prayer_model.dart';
import 'package:hudra/model/prayer_model.dart';
import 'package:hudra/view/reference_page.dart';
import 'package:hudra/widgets/holiday_prayer_page/holiday_prayer_item.dart';
import 'package:hudra/widgets/other/MyCustomScrollBehavior.dart';
import 'package:provider/provider.dart';
import 'package:hudra/data/data.dart';

class HolidayPrayerPage extends StatefulWidget {
  bool isWeb = false;

  HolidayPrayerPage({Key? key, this.isWeb = false}) : super(key: key);

  @override
  State<HolidayPrayerPage> createState() => _HolidayPrayerPageState();
}

class _HolidayPrayerPageState extends State<HolidayPrayerPage> {
  // double _textSize = 14;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   String holidayNameTMP =
  //       Provider.of<ProviderGlobal>(context, listen: false).holidayName;
  //
  //   if (GetStorageHelper().getPrayersLanguageInEnglish() == "Arabic") {
  //     for (var element in holidaysNames) {
  //       if (element["en"] == holidayNameTMP) {
  //         holidayNameTMP = element["ar"];
  //         break;
  //       }
  //     }
  //   }
  //
  //   if (GetStorageHelper().getPrayersLanguageInEnglish() == "Syriac") {
  //     for (var element in holidaysNames) {
  //       if (element["en"] == holidayNameTMP) {
  //         holidayNameTMP = element["syr"];
  //         break;
  //       }
  //     }
  //   }
  //
  //   // Provider.of<ProviderPrayers>(context, listen: false).loadPrayers(
  //   //     condition:
  //   //         "Where `itemRelatedHoliday` = '$holidayNameTMP' AND `isSyriac` = '1'");
  //   loadHolidayPrayer(holidayNameTMP);
  //   super.initState();
  // }

  PrayerObject _prayerObject = PrayerObject();
  bool _isLoading = false;

  // loadHolidayPrayer(String prayerName) async {
  //   _isLoading = true;
  //   setState(() {});
  //   String holidayNameTMP =
  //       Provider.of<ProviderGlobal>(context, listen: false).holidayName;
  //
  //   if (GetStorageHelper().getPrayersLanguageInEnglish() == "Arabic") {
  //     for (var element in holidaysNames) {
  //       if (element["en"] == holidayNameTMP) {
  //         holidayNameTMP = element["ar"];
  //         break;
  //       }
  //     }
  //   }
  //
  //   if (GetStorageHelper().getPrayersLanguageInEnglish() == "Syriac") {
  //     for (var element in holidaysNames) {
  //       if (element["en"] == holidayNameTMP) {
  //         holidayNameTMP = element["syr"];
  //         break;
  //       }
  //     }
  //   }
  //   // _prayerObject = await PrayersData().loadHolidayByName(prayerName);
  //   await Future.delayed(Duration.zero, () {
  //     Provider.of<PrayersData>(context, listen: false)
  //         .loadHolidayByName(holidayPrayer: holidayNameTMP);
  //   });
  //   _isLoading = false;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var textSizeProvider =
        Provider.of<ProviderTextSize>(context, listen: false);
    return Consumer<PrayersData>(builder: (context, prayerData, _) {
      return WillPopScope(
        onWillPop: () async =>
            Provider.of<ProviderGlobal>(context, listen: false).goBackAll(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.sizeOf(context).height,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 30.0),
                      !widget.isWeb
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: 25,
                              width: 25,
                              child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: () => Provider.of<ProviderGlobal>(
                                          context,
                                          listen: false)
                                      .goBackAll(),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  )
                                  // Image.asset(
                                  //   'Assets/Icons/menu.png',
                                  //   color: secondaryColor,
                                  // ),
                                  ),
                            ),
                    ],
                  ),
                  widget.isWeb
                      ? const SizedBox(height: 30)
                      : const SizedBox.shrink(),
                  SizedBox(
                      height: context.watch<ProviderTextSize>().textSize / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          Provider.of<ProviderGlobal>(context).holidayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: context.watch<ProviderTextSize>().textSize / 2),
                  prayerData.listOfPrayersByName == []
                      ? SizedBox.shrink()
                      : Expanded(
                          child: MediaQuery(
                            data: mediaQueryData.copyWith(
                                textScaleFactor: textSizeProvider.textSize),
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior()
                                  .copyWith(overscroll: false),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      prayerData.listOfPrayersByName.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Html(
                                          // data: DeltaToHTML.encodeJson(bibleData),
                                          data: DeltaToHTML.encodeJson(
                                              jsonDecode(prayerData
                                                  .listOfPrayersByName[index]
                                                  .itemDesc) as List),

                                          style: {
                                            "body": Style(
                                              fontSize: FontSize(18.0),
                                              // fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.color,
                                            ),
                                          },
                                          onLinkTap:
                                              (url, attributes, element) async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReferencePage(
                                                        param: url.toString()),
                                              ),
                                            );
                                          },
                                        ),
                                        Divider(
                                          thickness: 1.0,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                  // Expanded(
                  //   child: ScrollConfiguration(
                  //     behavior:
                  //         MyCustomScrollBehavior().copyWith(overscroll: false),
                  //     child: SingleChildScrollView(
                  //       child: Consumer<ProviderPrayers>(
                  //           builder: (context, providerPrayers, _) {
                  //         return Column(
                  //           children:
                  //               // providerPrayers.holidayPrayerItemChildren.isEmpty
                  //               //     ? [
                  //               //         const SizedBox(height: 60.0),
                  //               //         Center(
                  //               //           child: Text('No Item Found.',
                  //               //               textAlign: TextAlign.center,
                  //               //               style: Theme.of(context)
                  //               //                   .textTheme
                  //               //                   .headlineSmall),
                  //               //         ),
                  //               //       ]
                  //               //     : providerPrayers.holidayPrayerItemChildren
                  //               // []
                  //               [
                  //             HolidayPrayerItem(
                  //               prayerModel: PrayerModel(
                  //                 prayerId: '1',
                  //                 prayerTitle: 'Prayer1',
                  //                 prayerText: [
                  //                   '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna'''
                  //                 ],
                  //               ),
                  //             ),
                  //             //   HolidayPrayerItem(
                  //             //     prayerModel: PrayerModel(
                  //             //       prayerId: '2',
                  //             //       prayerTitle: 'Prayer2',
                  //             //       prayerText:
                  //             //       '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna''',
                  //             //     ),
                  //             //   ),
                  //           ],
                  //         );
                  //       }),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              _isLoading
                  ? Container(
                      height: MediaQuery.sizeOf(context).height,
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }

// _back() {
//   // // String tmp = globals.currentPage;
//   // // globals.previousPage = tmp;
//   //
//   // globals.holidayName = '';
//   // globals.isCalendar = 0;
//   // widget.setState();
// }
}
