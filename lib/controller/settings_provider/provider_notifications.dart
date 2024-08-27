import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hudra/api/my_session.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/firebase_options.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Notifications/notification_model.dart';
import 'package:hudra/remote/apis_model.dart';
import 'package:hudra/widgets/notifications_page/notifications_item.dart';

class ProviderNotifications extends ChangeNotifier {
  bool _isNotificationEnable = true;
  List<NotificationsItem> _notificationChildren = [];

  bool get isNotificationEnable => _isNotificationEnable;

  List<NotificationsItem> get notificationChildren => _notificationChildren;

  /// Notifications Page

  Future<List<NotificationsItem>> loadNotifications({String? condition}) async {
    List<NotificationsItem> notificationsItemListTmp = [];
    if (!await checkInternetConnection()) {
      /// load notifications from local db
      var data = await DatabaseHelper.queryAllNotifications();
      print("Loading notifications from local ${data.length}");
      if (data.isEmpty) {
        _notificationChildren = notificationsItemListTmp;
        notifyListeners();
        return notificationsItemListTmp;
      }
      for (int i = 0; i < data.length; i++) {
        notificationsItemListTmp.add(NotificationsItem(
            notificationModel: NotificationModel.fromJson(data[i])));
      }

      _notificationChildren = notificationsItemListTmp;
      notifyListeners();
      return notificationsItemListTmp;
    }
    List<NotificationModel> response =
        await APISModel().loadNotifications(condition: condition);

    for (NotificationModel notificationModel in response) {
      DatabaseHelper.insertNotifications(notificationModel);
      notificationsItemListTmp
          .add(NotificationsItem(notificationModel: notificationModel));
    }
    _notificationChildren = notificationsItemListTmp;
    notifyListeners();
    return notificationsItemListTmp;
  }

  /// Settings Notifications
  // Future<void> setNotification(bool value) async {
  //   _isNotificationEnable = value;
  //   await _changeFireTopics();
  //   notifyListeners();
  // }

  setInitNotification() async {
    try {
      if (GetStorageHelper().getPushNotifications() == true) {
        _isNotificationEnable = true;

        // notifyListeners();
      }

      if (GetStorageHelper().getPushNotifications() == false) {
        _isNotificationEnable = false;
        // notifyListeners();
      }
      await _changeFireTopics();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setNotificationAndSession(bool value) async {
    _isNotificationEnable = value;
    await _changeFireTopics();
    GetStorageHelper().setPushNotifications(notificationValue: value);
    notifyListeners();
  }

  Future<void> _changeFireTopics() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    if (_isNotificationEnable) {
      debugPrint('NOTIFICATION ON');
      await FirebaseMessaging.instance.subscribeToTopic('TestTopic');
    } else {
      debugPrint('NOTIFICATION OFF');
      await FirebaseMessaging.instance.unsubscribeFromTopic('TestTopic');
    }
  }

  ///
}
