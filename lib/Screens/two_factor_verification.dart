import 'dart:typed_data';

import 'package:dynamic_center/Screens/two_factor_verification2.dart';
import 'package:dynamic_center/general/SizeConfig.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qrscan/qrscan.dart' as scanner;

class TwoFactorVerification extends StatefulWidget {
  TwoFactorVerification({Key? key}) : super(key: key);

  @override
  _TwoFactorVerificationState createState() => _TwoFactorVerificationState();
}

class _TwoFactorVerificationState extends State<TwoFactorVerification> {
  Uint8List bytes = Uint8List(0);
  String quote = "3M8w2knJKsr3jqMatYiyuraxVvZAmuZy24lK8";

  @override
  void initState() {
    super.initState();
    // _generateBarCode(quote);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text(
          "Two-Factor Verification",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: cardheight(context: context),
          // height: 1000,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Scan the QR code or enter the code manually in your auth app e.g Google Authenticator",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 120),
                Expanded(
                  child: Cardlayout(
                    child: Container(
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        SizedBox(
                          height: 50,
                        ),
                        // bytes.isEmpty
                        //     ? Image(
                        //         image: AssetImage("assets/images/qrcode.png"),
                        //         height: 300,
                        //         width: 300,
                        //       )
                        //     //   : Image(
                        //     //   image: MemoryImage(bytes),
                        //     //   height: 300,
                        //     //   width: 300,
                        //     // )
                        //     : QrImage(
                        //         data: quote,
                        //         version: QrVersions.auto,
                        //         size: 320,
                        //         gapless: false,
                        //         embeddedImage:
                        //             AssetImage('assets/images/logo.jpg'),
                        //         embeddedImageStyle: QrEmbeddedImageStyle(
                        //           size: Size(80, 80),
                        //         ),
                        //       ),
                        SizedBox(height: 20),
                        Text(quote),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: quote));
                          },
                          child: Text(
                            'Copy',
                            style: TextStyle(
                                color: Color(primarycolour),
                                fontWeight: FontWeight.bold,
                                fontSize: 19),
                          ),
                        ),
                        SizedBox(height: 50),
                        RoundedButton(
                          text: "Continue",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TwoFactorVerification2(),
                                ));
                          },
                        ),
                      ]),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
  // Future _scan() async {
  //   String barcode = await scanner.scan();
  //   if (barcode == null) {
  //     print('nothing return.');
  //   } else {
  //     // this._outputController.text = barcode;
  //     print(barcode);
  //   }
  // }

  // Future _scanPhoto() async {
  //   String barcode = await scanner.scanPhoto();
  //   print(barcode);
  //   // this._outputController.text = barcode;
  // }
  //
  // Future _scanPath(String path) async {
  //   String barcode = await scanner.scanPath(path);
  //   print(barcode);
  //   // this._outputController.text = barcode;
  // }
  //
  // Future _scanBytes() async {
  //   File file = await ImagePicker.pickImage(source: ImageSource.camera);
  //   Uint8List bytes = file.readAsBytesSync();
  //   String barcode = await scanner.scanBytes(bytes);
  //   print(barcode);
  //   // this._outputController.text = barcode;
  // }

  // Future _generateBarCode(String inputCode) async {
  //   Uint8List result = await scanner.generateBarCode(inputCode);
  //   this.setState(() => this.bytes = result);
  // }
}
