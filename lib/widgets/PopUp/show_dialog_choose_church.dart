import 'package:flutter/material.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/date_provider/date_provider.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Church Name
void showDialogChooseChurch(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            title: Center(
                child: Text(
              'Choose Church',

              /// TODO: "Choose Church"
              // AppLocalizations.of(context)!.chooseChurch,
              style: TextStyle(color: CustomColors.brown9),
            )),
            content: Wrap(
              children: [
                TextButton(
                  onPressed: () {
                    Provider.of<ProviderChurch>(context, listen: false)
                        .setChurchName("Syriac", false);
                    Navigator.pop(context);
                  },
                  child: Text(
                    // 'Syriac Church',
                    AppLocalizations.of(context)!.churchSyriac,
                    style: TextStyle(color: CustomColors.brown9),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<ProviderChurch>(context, listen: false)
                        .setChurchName("Chaldean", false);
                    Navigator.pop(context);
                  },
                  child: Text(
                    // 'Chaldean Church',
                    AppLocalizations.of(context)!.churchChaldean,
                    style: TextStyle(color: CustomColors.brown9),
                  ),
                ),
              ],
            ),
          ));
}

class YearPicker extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int> onChanged;

  YearPicker({required this.selectedYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    int initialItemIndex = selectedYear - 1901;
    FixedExtentScrollController controller =
        FixedExtentScrollController(initialItem: initialItemIndex);
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 60, // Height of each item
      diameterRatio: 1.5, // The diameter of the scroll view
      physics: FixedExtentScrollPhysics(), // Snaps to each item
      onSelectedItemChanged: (index) {
        onChanged(1901 + index); // Correct for the year starting at 1901
      },
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) => Center(child: Text('${1901 + index}')),
        childCount:
            3000 - 1901 + 1, // Calculate the count of years from 1901 to 3000
      ),
    );
  }
}

void showYearPicker(BuildContext context, int _selectedYear) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Center(
                child: Text(
              'Choose Year',
              style: TextStyle(color: CustomColors.brown9),
            )),
            content: Wrap(
              children: [
                Container(
                  // Define a fixed height for the wheel scroll view
                  height: 200,
                  child: YearPicker(
                    selectedYear: _selectedYear,
                    onChanged: (year) {
                      // var dateProver =
                      //     Provider.of<DateProvider>(context, listen: false);
                      Provider.of<DateProvider>(context, listen: false)
                          .setYear(context, year);
                      Provider.of<GlobalProvider2>(context, listen: false)
                          .getAllResults(context: context, currentYear: year);
                      // Provider.of<ProviderDaily>(context, listen: false)
                      //     .checkIfEidElSalibIsEarly(context,
                      //         DateTime(dateProver.year, dateProver.month));
                    },
                  ),
                )
              ],
            ),
          ));
}
