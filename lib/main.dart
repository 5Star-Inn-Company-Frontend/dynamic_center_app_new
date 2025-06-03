// import 'dart:async';
// import 'package:dynamic_center/Screens/account/service/user_data_provider.dart';
// import 'package:dynamic_center/Screens/login/auth/login_auth.dart';
// import 'package:dynamic_center/Screens/login/state_mgt/login_logic.dart';
// import 'package:flutter/material.dart';
// import 'package:dynamic_center/constant/imports.dart';
// import 'package:get/get.dart';

// final _kShouldTestAsyncErrorOnInit = false;

// /// Create a [AndroidNotificationChannel] for heads up notifications
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   // 'This channel is used for important notifications.', // description
//   importance: Importance.max,
// );

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Toggle this for testing Crashlytics in your app locally.
// final _kTestingCrashlytics = true;
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   getdetails();
//   if (Platform.isAndroid || Platform.isIOS) {
//     await Firebase.initializeApp();
//     // Set the background messaging handler early on, as a named top-level function
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     /// Create an Android Notification Channel.
//     ///
//     /// We use this channel in the `AndroidManifest.xml` file to override the
//     /// default FCM channel to enable heads up notifications.
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     if (Platform.isIOS) {
//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//     runZonedGuarded(() {
//       Get.put(AuthController()..checkAuthentication());
//       Get.put(LoginLogic());
//       Get.put(UserDataProvider());
//       runApp(MyApp());
//     }, (error, stackTrace) {
//       print('runZonedGuarded: Caught error in my root zone.');
//       FirebaseCrashlytics.instance.recordError(error, stackTrace);
//     });
//   } else {
//     Get.put(AuthController()..checkAuthentication());
//     Get.put(LoginLogic());
//     Get.put(UserDataProvider());
//     // Get.put(TransactionDataProvider());
//     // Get.put(DataPurchaseClass());
//     // Get.put(ElecPurchaseClass());
//     // Get.put(TvPurchaseClass());
//     runApp(MyApp());
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Future<void> _initializeFlutterFireFuture;

//   Future<void> _testAsyncErrorOnInit() async {
//     Future<void>.delayed(const Duration(seconds: 2), () {
//       final List<int> list = <int>[];
//       print(list[100]);
//     });
//   }

//   // Define an async function to initialize FlutterFire
//   Future<void> _initializeFlutterFire() async {
//     // Wait for Firebase to initialize
//     await Firebase.initializeApp();

//     if (_kTestingCrashlytics) {
//       // Force enable crashlytics collection enabled if we're testing it.
//       await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//     } else {
//       // Else only enable it in non-debug builds.
//       // You could additionally extend this to allow users to opt-in.
//       await FirebaseCrashlytics.instance
//           .setCrashlyticsCollectionEnabled(!kDebugMode);
//     }

//     // Pass all uncaught errors to Crashlytics.
//     FlutterExceptionHandler? originalOnError = FlutterError.onError;
//     FlutterError.onError = (FlutterErrorDetails errorDetails) async {
//       await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
//       // Forward to original handler.
//       originalOnError!(errorDetails);
//     };

//     if (_kShouldTestAsyncErrorOnInit) {
//       await _testAsyncErrorOnInit();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid || Platform.isIOS) {
//       _initializeFlutterFireFuture = _initializeFlutterFire();
//     }
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//         builder: (context, widget) => ResponsiveBreakpoints.builder(
//             // BouncingScrollWrapper.builder(context, widget!),
//             // maxWidth: 1200,
//             // minWidth: 450,
//             // defaultScale: true,
//             child: widget!,
//             breakpoints: [
//               const Breakpoint(start: 0, end: 450, name: MOBILE),
//               const Breakpoint(start: 451, end: 800, name: TABLET),
//               const Breakpoint(start: 801, end: 1920, name: DESKTOP),
//               const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//             ],
//         ),
//             // background: Container(color: Colors.white)),
//         // onGenerateRoute: (RouteSettings settings) {
//         //   return Routes.fadeThrough(settings, (context) {
//         //     switch (settings.name) {
//         //       case Routes.home:
//         //         return ListPage();
//         //         break;
//         //       case Routes.post:
//         //         return PostPage();
//         //         break;
//         //       case Routes.style:
//         //         return TypographyPage();
//         //         break;
//         //       default:
//         //         return null;
//         //         break;
//         //     }
//         //   });
//         // },
//         // theme: Theme.of(context).copyWith(platform: TargetPlatform.android),
//         debugShowCheckedModeBanner: false,
//         title: 'Dynamic center',
//         theme: ThemeData(
//           primaryColor: Color(primarycolour),
//           platform: TargetPlatform.android,
//           scaffoldBackgroundColor: Color(scafoldcolour),
//           primarySwatch: Colors.blue,
//         ),
//         home: SplashScreen(),
//       );}
//     );
//   }
// }

// /// To verify things are working, check out the native platform logs.
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
//   final android1 = AndroidNotificationDetails('channel id', 'channel name',
//       // 'channel description',
//       priority: Priority.high,
//       importance: Importance.max);
//   final iOS = DarwinNotificationDetails(presentSound: true);
//   final platform = NotificationDetails(android: android1, iOS: iOS);
//   RemoteNotification? notification = message.notification;

//   await flutterLocalNotificationsPlugin.show(
//       notification.hashCode, // notification id
//       notification!.title,
//       notification.body,
//       platform);
//   AndroidNotification? android = message.notification?.android;
//   if (android != null) {
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,import 'package:flutter/services.dart';


//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             // channel.description,
//             // add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: 'launch_background',
//           ),
//         ));
//   }

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
// }




import 'package:dynamic_center/Screens/account/service/user_data_provider.dart';
import 'package:dynamic_center/Screens/login/auth/login_auth.dart';
import 'package:dynamic_center/Screens/login/state_mgt/login_logic.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: primarycolour,
  //     statusBarIconBrightness: Brightness.light,
  //   ),
  // );

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController()..checkAuthentication());
  Get.put(LoginLogic());
  Get.put(UserDataProvider());
  // Get.put(TransactionDataProvider());
  // Get.put(DataPurchaseClass());
  // Get.put(ElecPurchaseClass());
  // Get.put(TvPurchaseClass());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Dynamic Center',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0XFFF7F7F7),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          fallbackLocale: const Locale('en', 'US'),
          initialRoute: Routes.SPLASHSCREEN,
          getPages: AppPages.pages,
        );
      }
    );
  }
}