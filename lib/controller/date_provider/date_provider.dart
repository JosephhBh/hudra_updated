import 'package:flutter/material.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:provider/provider.dart';

class DateProvider extends ChangeNotifier {
  int _year = DateTime.now().year.toInt();
  int _month = DateTime.now().month.toInt();

  // int _year = 1901;
  // int _year = 2022;
  // int _month = 1;

  int get year => _year;
  int get month => _month;

  goLeft(BuildContext context) {
    _month--;
    if (_month == 0) {
      _month = 12;
      _year--;
      Provider.of<GlobalProvider2>(context, listen: false)
          .getAllResults(context: context, currentYear: _year);
    }
    notifyListeners();
  }

  goRight(BuildContext context) {
    _month++;
    if (_month == 13) {
      _month = 1;
      _year++;
      Provider.of<GlobalProvider2>(context, listen: false)
          .getAllResults(context: context, currentYear: _year);
    }
    notifyListeners();
  }

  setYear(BuildContext context, int year) {
    _year = year;
    Provider.of<GlobalProvider2>(context, listen: false)
        .getAllResults(context: context, currentYear: _year);
    notifyListeners();
  }
}
