import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Snackbar {
  static void showMessage(String message, GlobalKey<ScaffoldState> _scaffoldKey,
      [bool Tts = true, Duration duration = const Duration(seconds: 4)]) {
    if (Platform.isAndroid || Platform.isIOS) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      // if(Tts){
      //   speak(message);
      // }
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      // _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      //   content: new Text(message),
      //   duration: duration,
      //   action: new SnackBarAction(
      //       label: 'CLOSE',
      //       onPressed: () =>
      //           _scaffoldKey.currentState!()),
      // ));
    }
  }
  // static FlutterTts flutterTts;
  // static void initTts() {
  //   flutterTts = FlutterTts();
  //   flutterTts.setLanguage("en-US");
  //   if (!kIsWeb && Platform.isAndroid) {
  //     flutterTts
  //         .isLanguageInstalled("en-US");
  //   }
  //
  //   if (!kIsWeb && Platform.isAndroid) {
  //     _getEngines();
  //   }
  //
  //   // flutterTts.setStartHandler(() {
  //   //   setState(() {
  //   //     print("Playing");
  //   //     ttsState = TtsState.playing;
  //   //   });
  //   // });
  //   //
  //   // flutterTts.setCompletionHandler(() {
  //   //   setState(() {
  //   //     print("Complete");
  //   //     ttsState = TtsState.stopped;
  //   //   });
  //   // });
  //   //
  //   // flutterTts.setCancelHandler(() {
  //   //   setState(() {
  //   //     print("Cancel");
  //   //     ttsState = TtsState.stopped;
  //   //   });
  //   // });
  //   //
  //   // if (kIsWeb || Platform.isIOS) {
  //   //   flutterTts.setPauseHandler(() {
  //   //     setState(() {
  //   //       print("Paused");
  //   //       ttsState = TtsState.paused;
  //   //     });
  //   //   });
  //   //
  //   //   flutterTts.setContinueHandler(() {
  //   //     setState(() {
  //   //       print("Continued");
  //   //       ttsState = TtsState.continued;
  //   //     });
  //   //   });
  //   // }
  //   //
  //   // flutterTts.setErrorHandler((msg) {
  //   //   setState(() {
  //   //     print("error: $msg");
  //   //     ttsState = TtsState.stopped;
  //   //   });
  //   // });
  // }
  // static Future _getEngines() async {
  //   var engines = await flutterTts.getEngines;
  //   if (engines != null) {
  //     for (dynamic engine in engines) {
  //       // print("my engine "+engine);
  //     }
  //   }
  // }
  // static Future speak(String newVoiceText) async {
  //   await flutterTts.setVolume(1.0);
  //   await flutterTts.setSpeechRate(1.0);
  //   await flutterTts.setPitch(1.0);
  //
  //   if (newVoiceText != null) {
  //     if (newVoiceText.isNotEmpty) {
  //       await flutterTts.awaitSpeakCompletion(true);
  //       await flutterTts.speak(newVoiceText);
  //     }
  //   }
  // }

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd/MM/yyyy');
  static final String datenow = formatter.format(now);

  static String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
