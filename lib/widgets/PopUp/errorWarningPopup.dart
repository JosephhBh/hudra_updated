//import 'package:flutter/cupertino.dart'; //CupertinoIcons.checkmark_alt_circle,//Success Icon
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/utils/custom_colors.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

errorPopup(BuildContext context, String? text) {
  if (text == globals.errorToken) {
    Navigator.pushNamedAndRemoveUntil(context, '/intro_page', (route) => false);
    MotionToast(
      icon: Icons.error,
      primaryColor: CustomColors.red2,
      secondaryColor: CustomColors.red1,
      toastDuration: const Duration(seconds: 3),
      // backgroundType: BackgroundType.solid,
      title: const Text(
        'Error',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        text ?? 'Unexpected Error.',
      ),
      position: MotionToastPosition.bottom,
      animationType: AnimationType.fromRight,
      height: 100,
    ).show(context);
  } else {
    MotionToast(
      icon: Icons.error,
      primaryColor: CustomColors.red2,
      secondaryColor: CustomColors.red1,
      toastDuration: const Duration(seconds: 3),
      // backgroundType: BackgroundType.solid,
      title: const Text(
        'Error',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        text ?? 'Unexpected Error.',
      ),
      position: MotionToastPosition.bottom,
      animationType: AnimationType.fromRight,
      height: 100,
    ).show(context);
  }
}

warningPopup(BuildContext context, String? text) {
  MotionToast(
    icon: Icons.warning,
    primaryColor: CustomColors.yellow2,
    secondaryColor: CustomColors.yellow1,
    toastDuration: const Duration(seconds: 3),
    // backgroundType: BackgroundType.solid,
    title: const Text(
      'Warning',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    description: Text(
      text ?? 'Unexpected Warning.',
    ),
    position: MotionToastPosition.bottom,
    animationType: AnimationType.fromRight,
    height: 100,
  ).show(context);
}

successPopup(BuildContext context, String? text) {
  MotionToast(
    icon: cupertino.CupertinoIcons.checkmark_alt_circle,
    primaryColor: CustomColors.green2,
    secondaryColor: CustomColors.green1,
    toastDuration: const Duration(seconds: 3),
    // backgroundType: BackgroundType.solid,
    title: const Text(
      'Success',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    description: Text(
      text ?? 'Unexpected Success.',
    ),
    position: MotionToastPosition.bottom,
    animationType: AnimationType.fromRight,
    height: 100,
  ).show(context);
}
