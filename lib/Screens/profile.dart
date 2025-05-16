import 'dart:convert';
import 'dart:io';

import 'package:dynamic_center/Screens/Camera/camera_screen.dart';
import 'package:dynamic_center/Screens/PersonalInformation.dart';
import 'package:dynamic_center/Screens/document_verification.dart';
import 'package:dynamic_center/Screens/security.dart';
import 'package:dynamic_center/Screens/verify_phone_number.dart';
import 'package:dynamic_center/general/SizeConfig.dart';
import 'package:dynamic_center/general/component/Snacbar.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/component/custom_alert_dialog.dart';
import 'package:dynamic_center/general/component/loadingdialog.dart';
import 'package:dynamic_center/general/component/roundedmenu.dart';
import 'package:dynamic_center/general/constant.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Camera/preview.dart';

class Profile extends StatefulWidget {
  final String imgpath;
  Profile({Key? key, this.imgpath = ""}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int wallet = 0;
  String dialogtitle = "Upload Picture Error";
  String img64 = "";
  double addheight = -1;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    getData();
  }

  void getData() async {}
  @override
  void initState() {
    super.initState();
    if (widget.imgpath != null) {
      File image = File(widget.imgpath);
      final bytes = image.readAsBytesSync();

      img64 = base64Encode(bytes);
      print(img64.substring(0, 100));
      _uploaddp(img64);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.height);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Positioned(
            top: 50.0,
            child: Cardlayout(
              child: Container(
                width: size.width,
                height: cardheight(context: context, addheight: 0),
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      Roundedmenu(
                        text: Text(
                          "Personal information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PersonalInformation();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Roundedmenu(
                        text: Text(
                          "Phone number verification",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VerifyPhoneNumber();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Roundedmenu(
                        text: Text(
                          "My Document",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DocumentVerification();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Roundedmenu(
                        text: Text(
                          "Payment & Billing",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {},
                      ),
                      SizedBox(height: 30),
                      Text("     Settings"),
                      SizedBox(height: 30),
                      Roundedmenu(
                        text: Text(
                          "Security",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Security();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Roundedmenu(
                        text: Text(
                          "Help & Support",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {},
                      ),
                      SizedBox(height: 10),
                      Roundedmenu(
                        text: Text(
                          "Policy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.black),
                        ),
                        press: () {},
                      ),
                    ]),
              ),
            ),
          ),
          // Expanded(
          //   child:
          Positioned(
            child: Container(
                width: size.width,
                height: cardheight(context: context, addheight: 0),
                // child: GestureDetector(
                //     onTap: () {
                //       showAlertDialog(context);
                //     },
                child: Column(children: [
                  PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text("View Photo"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Take photo"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text("Upload photo"),
                      ),
                    ],
                    // initialValue: 3,
                    onCanceled: () {
                      print("You have canceled the menu.");
                    },
                    onSelected: (value) {
                      Topupselected(value);
                      print("value:$value");
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profile_path),
                      radius: 50,
                    ),
                  ),
                  Text(
                    first_name + " " + last_name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black),
                  )
                ])),
          ),
          // ),
        ]),
      ),
    );
  }

  Topupselected(int index) {
    switch (index) {
      case 1:
        _imgview();
        break;
      case 2:
        _imgfromcamera();
        break;
      // case 3:
      //   _imgFromGallery();
      //   break;

      default:
    }
  }

  void showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Choose the Options'),
      content: Container(
        child: Column(children: [
          Container(
            height: 20,
          ),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                  onTap: () {
                    _imgfromcamera();
                  },
                  child: Image(
                    image: AssetImage("assets/images/camera.png"),
                    height: 50,
                    width: 50,
                  )),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    // _imgFromGallery();
                  },
                  child: Image(
                    image: AssetImage("assets/images/gallery.png"),
                    height: 50,
                    width: 50,
                  )),
              Spacer(),
            ],
          ),
        ]),
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _imgview() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PreviewScreen(
        imgPath:
            "/data/user/0/com.a5starcompany.dynamic_center/cache/2020-11-22 23:01:31.749042.png",
        fileName: "2020-11-22 23:01:31.749042.png",
      );
    }));
    print(result);
    if (result != null) {
      File image = File(result);
      final bytes = image.readAsBytesSync();

      img64 = base64Encode(bytes);
      print(img64.substring(0, 100));
    }
  }

  _imgfromcamera() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraScreen(
            cameraAppbar: "Take a selfie of yourself",
          );
        },
        // /data/user/0/com.a5starcompany.dynamic_center/cache/2020-11-22 23:44:59.215347.png
        // /storage/emulated/0/Android/data/com.a5starcompany.dynamic_center/files/Pictures/scaled_image_picker3637864044906608300.jpg'
      ),
    );
  }

  File? _image;

  // List<PlatformFile>? _paths;
  // void _imgFromGallery() async {
  //   try {
  //     _paths = (await FilePicker.platform.pickFiles(
  //       type: FileType
  //           .custom, //FileType.audio,  //FileType.image, FileType.video, FileType.media, FileType.any, FileType.custom,
  //       allowedExtensions: ["pdf"],
  //       allowMultiple: false,
  //     ))
  //         ?.files;
  //     if (_paths != null) {
  //       File image = File(_paths![0].path!);
  //       final bytes = image.readAsBytesSync();

  //       String img64 = base64Encode(bytes);
  //       _uploaddp(img64);
  //       setState(() {
  //         _image = image;
  //       });
  //     }
  //   } on PlatformException catch (e) {}
  // }

  void _uploaddp(
    String email,
  ) async {
    // If the form is valid, display a snackbar. In the real world,
    // you'd often call a server or save the information in a database.

    loading();
    // if(token != null){
    //   headers.addAll({"Authorization" : "Bearer "+token});
    // }
    try {
      var json_body = {
        'image': "data:image/png;base64,$email",
      };
      http.Response response = await http.post(parseUrl("uploaddp"),
          body: json_body,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        String data = response.body;
        var cmddetails = jsonDecode(data);
        print(cmddetails);
        if (cmddetails['status'] == 1) {
          Snackbar.showMessage(cmddetails['message'], _scaffoldKey);
        } else {
          print(cmddetails);
          print(response.statusCode);
          var dialog = CustomAlertDialog(
              title: dialogtitle,
              message: cmddetails['message'] + "\n" + cmddetails['error'],
              // onPostivePressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) {
              //         // return JsonApiDropdown();
              //         return Login();
              //       },
              //     ),
              //   );
              // },
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue');
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        }
      } else {
        Navigator.of(context).pop();
        var dialog = CustomAlertDialog(
            title: dialogtitle,
            message: "Connection Error",
            // onPostivePressed: () {},
            // positiveBtnText: 'Continue',
            negativeBtnText: 'Continue');
      }
    } catch (Exception) {
      Navigator.of(context).pop();
      print(Exception);
      var dialog = CustomAlertDialog(
          title: dialogtitle,
          message: nonetwork,
          // onPostivePressed: () {},
          // positiveBtnText: 'Ok',
          negativeBtnText: 'Cancel');
      showDialog(context: context, builder: (BuildContext context) => dialog);
    }
    // Scaffold
    //     .of(context)
    //     .showSnackBar(SnackBar(content: Text('Processing Data')));
  }

  void loading() {
    var dialog = LoadingDialog();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }
}
