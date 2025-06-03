import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login.dart';

class Intro extends StatefulWidget {
  Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Login()),
    );
  }

  initstate() {}

  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = GoogleFonts.poppins(fontSize: 14.0);
    final pageDecoration = PageDecoration(
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: Color(primarycolour1)),
      bodyTextStyle: body,
      // descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "All in one Place",
          body: "Manage all your business assets, its simple and easy",
          image: _buildImage('desktop'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Sell Faster",
          body:
              "Sell airtime, data and other commodity to clients including money transfer",
          image: _buildImage('social'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Safety",
          body:
              "Our top-notch security features will keep you completely safe.  Your Safety is Our Top Priority",
          image: _buildImage('mobile'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      // skipFlex: 0,
      nextFlex: 0,
      skip:  Text('Skip',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Color(primarycolour1),
          )),
      next:  Text('Next',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Color(primarycolour1),
          )),
      done: Text('Done',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Color(primarycolour1),
          )),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
