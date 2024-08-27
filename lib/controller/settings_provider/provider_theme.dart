import 'package:flutter/services.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:hudra/locale/get_storage_helper.dart';

class ProviderTheme extends ChangeNotifier {
  String _themeMode = 'dark'; //dark//light

  final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: CustomColors.brown2,
    // backgroundColor: CustomColors.brown7,
    primaryColorDark: CustomColors.brown7,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      // headline3: TextStyle(color: CustomColors.white),
      headlineSmall: TextStyle(color: CustomColors.white),
      // DrawerBackground
      // headline4: TextStyle(color: CustomColors.brown2),
      headlineMedium: TextStyle(color: CustomColors.brown2),
      // DrawerBackground
      // headline5: TextStyle(color: CustomColors.brown7),
      headlineLarge: TextStyle(color: CustomColors.brown7),
      // CalendarAppBar
      // headline6: TextStyle(color: CustomColors.brown1),
      bodySmall: TextStyle(color: CustomColors.brown1),
      // bodyText1: TextStyle(color: CustomColors.brown8),
      bodyMedium: TextStyle(color: CustomColors.brown8),
      //Date//
      // bodyText2: TextStyle(color: CustomColors.brown7), //John
      bodyLarge: TextStyle(color: CustomColors.brown7),
    ),
    iconTheme: IconThemeData(
      color: CustomColors.brown5, //navigationBar
      size: 22,
    ),
  );
  final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: CustomColors.brown2,
    primaryColorDark: CustomColors.brown1,
    primarySwatch: Colors.blue,
    textTheme: TextTheme(
      headlineSmall: TextStyle(color: CustomColors.brown2),
      headlineMedium: TextStyle(color: CustomColors.brown1),
      // DrawerBackground
      headlineLarge: TextStyle(color: CustomColors.brown2),
      // CalendarAppBar
      bodySmall: TextStyle(color: CustomColors.brown7),
      bodyMedium: TextStyle(color: CustomColors.brown8),
      //Date//
      bodyLarge: TextStyle(color: CustomColors.brown5), //John
    ),
    iconTheme: IconThemeData(
      color: CustomColors.brown5, //navigationBar
      size: 22,
    ),
  );

  String get themeMode => _themeMode;

  void setThemeMode() {
    if (_themeMode == 'light') {
      _themeMode = 'dark';
    } else {
      _themeMode = 'light';
    }
    GetStorageHelper().setThemeMode(themeMode: _themeMode);
    notifyListeners();
  }

  // setInitThemeMode(String themeMode) {
  //   _themeMode = themeMode;
  //   notifyListeners();
  // }

  void setInitThemeMode(BuildContext context) {
    try {
      if (GetStorageHelper().getThemeMode() == 'dark') {
        _themeMode = 'dark';
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: CustomColors.brown1,
        ));
        // notifyListeners();
        return;
      }

      if (GetStorageHelper().getThemeMode() == 'light') {
        _themeMode = 'light';
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: CustomColors.brown7,
        ));
        // notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ThemeData getThemeMode() {
    if (_themeMode == 'dark') {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   systemNavigationBarColor: globals.brown2,
      // ));
      return _darkTheme;
    } else {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   systemNavigationBarColor: globals.brown2,
      // ));
      return _lightTheme;
    }
  }
}
