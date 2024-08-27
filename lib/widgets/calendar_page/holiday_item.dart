import 'package:hudra/api/my_session.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/prayers_provider/provider_prayers.dart';
import 'package:hudra/data/data.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:flutter/material.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HolidayItem extends StatelessWidget {
  String holidayName;
  String? holidayNamePriority;
  String? holidayNameOnly;
  String? week;
  String? day;
  DateTime date;
  bool isWeb;

  HolidayItem({
    Key? key,
    required this.holidayName,
    this.holidayNamePriority,
    required this.holidayNameOnly,
    required this.week,
    required this.day,
    required this.date,
    required this.isWeb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () async {
        // globals.currentPage = 'CalendarPage';
        // globals.isCalendar = 1;
        // globals.holidayName = holidayName;
        // seState();
        // print("the holiday is $holidayName");
        Provider.of<ProviderGlobal>(context, listen: false)
            .gotoCalendarHoliday(holidayName);
        await Future.delayed(Duration.zero, () {
          String holidayNameTMP = holidayName;
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

          // Provider.of<ProviderPrayers>(context, listen: false).loadPrayers(
          //     condition:
          //         "Where `itemRelatedHoliday` = '$holidayNameTMP' AND `isSyriac` = '1'");
          // loadHolidayPrayer(holidayNameTMP);

          // print("day: $day, week: $week");
          if (Provider.of<ProviderDaily>(context, listen: false)
                      .isSebou3(holidayRelated: holidayNameOnly ?? '') !=
                  null &&
              week == null) {
            String language = GetStorageHelper().getLanguageInEnglish();
            String languageCode = language == "English" ? "en" : "ar";

            week = weeksNames[1][languageCode];
            day = daysNames[date.weekday][languageCode];
          }
          // print("day: $day, week: $week");

          String? condition;
          if (week != null && day != null) {
            condition = "where `itemRelatedHoliday` = '$holidayNameOnly'";
            condition += " AND `week` = '$week'";
            condition += " AND `day` = '$day'";
          }
          Provider.of<PrayersData>(context, listen: false).loadHolidayByName(
              context: context,
              holidayName: holidayNameTMP,
              condition: condition);
        });
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Container(
          // height: 63,
          width: 320,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: !isWeb ? CustomColors.brown1 : CustomColors.brown2,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 320,
                child: Text(
                  holidayNamePriority ??= holidayName,
                  style: TextStyle(
                      fontSize: 15,
                      color:
                          !isWeb ? CustomColors.brown2 : CustomColors.brown1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
