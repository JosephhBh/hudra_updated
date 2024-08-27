import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/loaded_data/rituals_data.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/controller/settings_provider/provider_notifications.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:hudra/data/data2.dart' as globals;

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    // TODO: implement initState
    _setThemeMode();
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      alignment: Alignment.center,
      child: Image.asset(
        Provider.of<ProviderTheme>(context).themeMode == 'dark'
            ? 'Assets/Images/crossDark.png'
            : 'Assets/Images/crossLight.png',
        height: 250,
        width: 250,
      ),
    );
  }

  Future<void> _setThemeMode() async {
    // _goHome();
    // if (await SessionManager().get('themeMode') == 'dark') {
    //   if (mounted) {
    //     Provider.of<ProviderTheme>(context, listen: false)
    //         .setInitThemeMode('dark');
    //   }
    // }
    //
    // if (await SessionManager().get('themeMode') == 'light') {
    //   if (mounted) {
    //     Provider.of<ProviderTheme>(context, listen: false)
    //         .setInitThemeMode('light');
    //   }
    // }

    /// Before Go Home
    Provider.of<ProviderTheme>(context, listen: false)
        .setInitThemeMode(context);

    if (mounted) {
      await BibleData.loadBibles();
      await PrayersData.loadPrayers();
      await RitualsData.loadPrayers();
      // Provider.of<ProviderNotification>(context, listen: false).setNotification(
      //     await SessionManager().get('pushNotifications') ?? true);
      Provider.of<ProviderNotifications>(context, listen: false)
          .setInitNotification();
    }

    if (mounted) {
      // Provider.of<ProviderTextSize>(context, listen: false)
      //     .setTextSize(await SessionManager().get('textSize') ?? 14.0);
      Provider.of<ProviderTextSize>(context, listen: false).setInitTextSize();
    }

    if (mounted) {
      Provider.of<ProviderLanguage>(context, listen: false).setInitLanguage();
    }

    if (mounted) {
      Provider.of<ProviderChurch>(context, listen: false)
          .setInitChurch(context);
    }

    if (mounted) {
      while (GetStorageHelper().getChurchName() != 'Syriac' &&
          GetStorageHelper().getChurchName() != 'Chaldean') {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    await _goHome();

    /// After Go Home
  }

  Future<void> _goHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/Home', (route) => false);
    }
  }
}
