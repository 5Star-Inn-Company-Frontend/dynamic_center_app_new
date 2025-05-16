import 'dart:async';
import 'dart:io';

import 'package:dynamic_center/Screens/intro.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/device.dart';
import 'package:dynamic_center/general/component/deviceinfo.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:dynamic_center/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:package_info/package_info.dart';
import 'package:shimmer/shimmer.dart';

import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getsharepref();
    _mockCheckForSession().then((status) async {
      if (status) {
        if (Platform.isAndroid) {
          versionapp = appversion;
          device1 = androidId;
        } else if (Platform.isIOS) {
          versionapp = appversion;
          device1 = identifierForVendor;
        } else {
          // _device1 ="e444268bf5e74e06";
          device1 = "Desktop${Snackbar.getRandomString(9)}";
          versionapp = "5.2.0";
        }
        if (intro != null && intro) {
          _navigateToLogin();
        } else {
          _navigateToHome();
        }
      } else {
        _navigateToLogin();
      }
    });
  }

  getsharepref() async {
    if (deviceallow.allow()) {
      // if (Platform.isAndroid || Platform.isIOS) {
      //   PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      //     appName = packageInfo.appName;
      //     packageName = packageInfo.packageName;
      //     appversion = packageInfo.version;
      //     buildNumber = packageInfo.buildNumber;
      //   });
      // }
      initPlatformState();
      Firebase.initializeApp();
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        // if (message != null) {
        //   Navigator.pushNamed(context, '/message',
        //       arguments: MessageArguments(message, true));
        // }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  // channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      });

      // NotificationSettings settings = await FirebaseMessaging.instance
      //         .requestPermission(
      //       alert: true,
      //       announcement: true,
      //       badge: true,
      //       carPlay: true,
      //       criticalAlert: true,
      //       provisional: true,
      //       sound: true,
      //     );

      String? token = await FirebaseMessaging.instance.getToken();
      // print("FirebaseMessaging token: $token");
      if (logindetails != "") {
        FirebaseMessaging.instance.subscribeToTopic(logindetails);
      }
    }
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 6000), () {});

    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => Intro(),
    ));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => Login(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/SplashScreen.png"),
                fit: BoxFit.cover)),
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Opacity(
            //     opacity: 0.5,
            //     child:
            //     Image(
            //       image: AssetImage('assets/images/SplashScreen.png'),
            //       width: size.width,
            //       height: size.height,
            //     ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: size.width * 0.4,
                  height: size.height * 0.4,
                ),
                Shimmer.fromColors(
                  period: Duration(milliseconds: 1500),
                  baseColor: Color(0xff7f00ff),
                  highlightColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "DYNAMIC CENTER",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Pacifico',
                          shadows: <Shadow>[
                            Shadow(
                                blurRadius: 18.0,
                                color: Colors.black87,
                                offset: Offset.fromDirection(120, 12))
                          ]),
                    ),
                  ),
                ),
                Text(
                  "Business is Life",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
