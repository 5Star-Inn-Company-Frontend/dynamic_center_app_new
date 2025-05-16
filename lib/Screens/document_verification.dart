import 'package:dynamic_center/Screens/Camera/camera_screen.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/roundedmenu.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';

import 'Camera/camera_screen1.dart';

class DocumentVerification extends StatefulWidget {
  DocumentVerification({Key? key}) : super(key: key);

  @override
  _DocumentVerificationState createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text("Document Verification",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.06),
                Expanded(
                  child:
                Cardlayout(
                  child: Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                        children: [
                          Container(height: size.height*0.04,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child:Text(
                              "Your document photo helps us prove your identity. It should match your profile details.",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(height: size.height*0.1,),
                          Roundedmenu(
                            icon: Row(
                              children: [
                              Icon(
                              Icons.credit_card,
                              size: 20,
                              color: Color(0xffB5BBC9),
                            ),
                                SizedBox(width: 20,),
                              ],
                            ),
                            text: Text("National ID",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                            ),
                            press: (){
                              _imgfromcamera();
                            },
                          ),
                          SizedBox(height: 10),
                          Roundedmenu(
                            icon: Row(
                              children: [
                                Image.asset("assets/images/earth.png", width: 20, height: 20,),
                                SizedBox(width: 20,),
                              ],
                            ),
                            text: Text("Passport",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                            ),
                            press: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CameraScreen(
                                      cameraAppbar: "Scan Back Side",
                                      camerabutton: false,
                                      cameracenter: true,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Roundedmenu(
                            icon: Row(
                              children: [
                                // Image.asset("assets/images/earth.png"),
                                SizedBox(width: 40,),
                              ],
                            ),
                            text: Text("Driver’s Licence",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
                            ),
                            press: (){
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) {
                              //         return PersonalInformation();
                              //       },
                              //     ),
                              //   );
                            },
                          ),
                          Container(height: size.height*0.359,),
                        ]
                    ),
                  ),
                ),
                ),
              ]
          ),
        ),
      ),
    );
  }
  _imgfromcamera()async{
    final result = await
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraScreen(
            cameraAppbar: "Scan Front Side",
            camerabutton: false,
            cameracenter: true,
          );
        },
      ),
    );
    // final bytes = Io.File(result).readAsBytesSync();
    // final bytes = result.readAsBytesSync();

    // img64 = base64Encode(bytes);
    // img64 = base64Encode(result);
    // print(img64.substring(0, 100));
  }
}