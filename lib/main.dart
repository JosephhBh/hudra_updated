import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hudra/controller/date_provider/date_provider.dart';
import 'package:hudra/controller/global_provider2/global_provider2.dart';
import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/controller/daily_provider/provider_daily.dart';
import 'package:hudra/controller/saved_verses_provider/provider_saved_verses.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/prayers_provider/provider_prayers.dart';
import 'package:hudra/controller/settings_provider/book_mode_provider.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/controller/settings_provider/provider_notifications.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/l10n/l10n.dart';
import 'package:hudra/model/prayer_model.dart';
import 'package:hudra/utils/MaterialLocalizationsDelegate/syrMaterialLocalizationsDelegate.dart';
import 'package:hudra/view/bible_page.dart';
import 'package:hudra/view/fist_page.dart';
import 'package:hudra/view/home_page.dart';
import 'package:hudra/view/info_view.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbols.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart' as intl_helpers;

import 'firebase_options.dart';

// String? arg; //initial value
// /// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // debugPrint("Handling a background message: ${message.messageId}");
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    FullScreenWindow.setFullScreen(false);
  }
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.);

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  // debugPaintSizeEnabled=true;
  await GetStorage.init("localStorage");
  if (!kIsWeb) {
    await DatabaseHelper.initDatabase();
  }
  // MazmourData.loadAllMazmourData();
  // await BibleData.loadBibles();
  // await PrayersData.loadPrayers();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  // static final ValueNotifier<ThemeMode> themeNotifier =
  //     ValueNotifier(ThemeMode.light);

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // var newToken = await messaging.getToken();
    // try {
    //   await _firestore.collection('token').doc().set({
    //     'deviceToken': newToken,
    //   });
    // } catch (e) {
    //   print('updating token error : $e');
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                icon: "launch_background",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Future.delayed(Duration.zero, () {
      //   _navigationService.navigateTo(name: SignUpPageViewRoute);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<ThemeMode>(
    //     valueListenable: themeNotifier,
    //     builder: (_, ThemeMode currentMode, __) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PrayersData()),
        ChangeNotifierProvider(create: (context) => ProviderGlobal()),
        ChangeNotifierProvider(create: (context) => ProviderTextSize()),
        ChangeNotifierProvider(create: (context) => ProviderNotifications()),
        ChangeNotifierProvider(create: (context) => ProviderTheme()),
        ChangeNotifierProvider(create: (context) => ProviderLanguage()),
        ChangeNotifierProvider(create: (context) => ProviderPrayers()),
        ChangeNotifierProvider(create: (context) => ProviderDaily()),
        ChangeNotifierProvider(create: (context) => ProviderChurch()),
        ChangeNotifierProvider(create: (context) => BookModeProvider()),
        ChangeNotifierProvider(create: (context) => ProviderSavedVerses()),
        ChangeNotifierProvider(create: (context) => GlobalProvider2()),
        ChangeNotifierProvider(create: (context) => DateProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          title: 'Hudra',
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ProviderTheme>(context).getThemeMode(),
          initialRoute: '/FirstPage',
          routes: {
            '/FirstPage': (context) => const FirstPage(),
            '/Home': (context) => const HomePage(),
            // '/Home': (context) => Scaffold(
            //       body: Center(
            //         child: ElevatedButton(
            //           child: Text("results"),
            //           onPressed: () async {
            //             print(
            // Provider.of<GlobalProvider2>(context, listen: false)
            //     .getAllResults(
            //         context: context, currentYear: 2024));
            //           },
            //         ),
            //       ),
            //     ),
          },
          locale: Provider.of<ProviderLanguage>(context).currentLanguage,
          supportedLocales: L10n.all,
          // const [
          //   Locale('en'),
          //   Locale('ar'),
          //   Locale('fa'),
          // ],
          localizationsDelegates: const [
            AppLocalizations.delegate,

            /// add the new delegate for your language
            // syrMaterialLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      },
    );
    // });
  }
}

//Session:
//themeMode => light/dark
//language => en/ar
//prayersLanguage => English/عربي/Française/ܠܫܢܐ ܣܘܪܝܝܐ
//pushNotifications => true/false
//textSize => 14.0 -> 30.0
//bookMode => true/false
//last10Search => ["", "", ..., ""]
