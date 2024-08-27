// import 'package:fimber/fimber.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:meraky_store/locale/get_storage_helper.dart';
//
// class PushMessaging {
//   static final PushMessaging _singleton = PushMessaging._internal();
//
//   factory PushMessaging() {
//     return _singleton;
//   }
//
//   PushMessaging._internal();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   void setOnReceive() {}
//
//   init() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       Fimber.d("onMessage: $message");
//
//       manipulateNotification(message.data);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       Fimber.d("onMessage: $message");
//
//       manipulateNotification(message.data, isLaunch: true);
//     });
//
//     final NotificationSettings settings = await _firebaseMessaging
//         .requestPermission(sound: true, badge: true, alert: true);
//     Fimber.d("Settings registered: ${settings.toString()}");
//
//     generateRegToken();
//   }
//
//   void generateRegToken() {
//     _firebaseMessaging.getToken().then((String token) {
//       if (token != null) {
//         subscribe('global');
//         Fimber.d("Reg Token: $token");
//         GetStorageHelper().saveRegToken(token);
//         _submitRegToken();
//       } else {
//         generateRegToken();
//       }
//     });
//   }
//
//   void subscribe(String topic) {
//     Fimber.d("FCM subscribe to: $topic");
//     _firebaseMessaging.subscribeToTopic(topic);
//   }
//
//   void unsubscribe(String topic) {
//     Fimber.d("FCM unsubscribe to: $topic");
//     _firebaseMessaging.unsubscribeFromTopic(topic);
//   }
//
//   void _submitRegToken() async {
//     if ((await GetStorageHelper().getProfile()) == null) return;
//     Fimber.d('Submit Reg Token');
//
//     UserViewModel()
//         .saveRegToken((await GetStorageHelper().getRegToken()))
//         .then((message) => Fimber.d(message));
//   }
//
//   void manipulateNotification(Map<String, dynamic> message,
//       {bool isLaunch = false}) {
//     Fimber.d('notification received');
//   }
// }
