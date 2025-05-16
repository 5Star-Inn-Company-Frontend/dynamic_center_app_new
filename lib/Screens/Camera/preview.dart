import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_center/Screens/profile.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  PreviewScreen({this.imgPath = "", this.fileName = ""});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(scafoldcolour),
          elevation: 0.0,
          title: Text(
            "Document Verification",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
          ),
          leading: Backnavigation(),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black,
                  child: Center(
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return CameraScreen();
                            //     },
                            //   ),
                            // );
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                        // Spacer(),
                        // IconButton(
                        //   icon: Icon(Icons.share,color: Colors.white,),
                        //   onPressed: (){
                        //     getBytes().then((bytes) {
                        //       print('here now');
                        //       print(widget.imgPath);
                        //       print(bytes.buffer.asUint8List());
                        //       Share.file('Share via', widget.fileName, bytes.buffer.asUint8List(), 'image/path');
                        //     });
                        //   },
                        // ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Navigator.pop(context, '${widget.imgPath}');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Profile(
                                    imgpath: widget.imgPath,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future getBytes() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}
