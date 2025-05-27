// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:dynamic_center/Screens/deposit.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';
//
// class DetailScreen extends StatefulWidget {
//   final String imagePath;
//   final String method;
//   DetailScreen(this.imagePath, this.method);
//
//   @override
//   _DetailScreenState createState() => new _DetailScreenState();
// }
//
// class _DetailScreenState extends State<DetailScreen> {
//   Size? _imageSize;
//   List<TextElement> _elements = [];
//   File? imageFile;
//   String cardnumber = "";
//   String expire = "";
//   String cardname = "";
//
//   List<PlatformFile>? _paths;
//   void _initializeVision() async {
//     if (widget.method == "camera") {
//       imageFile = File(widget.imagePath);
//     } else {
//       _paths = (await FilePicker.platform.pickFiles(
//         type: FileType
//             .custom, //FileType.audio,  //FileType.image, FileType.video, FileType.media, FileType.any, FileType.custom,
//         allowedExtensions: ["pdf"],
//         allowMultiple: false,
//       ))
//           ?.files;
//
//       if (_paths == null) {
//         // print("image directory ${image}");
//         // final bytes = image.readAsBytesSync();
//         Navigator.of(context).pop();
//         // Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) {
//         //       return DetailScreen(image.toString(),"file");
//         //       // return PreviewScreen(imgPath: path, fileName: "$name.png",);
//         //     }
//         //     )
//         // );
//
//       } else {
//         imageFile = File(_paths![0].path!);
//       }
//       ;
//     }
//
//     if (imageFile != null) {
//       await _getImageSize(imageFile!);
//     }
//
//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(imageFile!);
//
//     final TextRecognizer textRecognizer =
//         FirebaseVision.instance.textRecognizer();
//     final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();
//     final VisionText visionText =
//         await textRecognizer.processImage(visionImage);
//
//     String pattern =
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
//
//     // RegExp regEx = RegExp(pattern);
//     RegExp regEx = RegExp(
//         r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))');
//     RegExp regEx1 = RegExp(r"^[0-9]+/");
//     RegExp regEx2 = RegExp(r"^[a-zA-Z]+[ ]");
//
//     for (TextBlock block in visionText.blocks) {
//       for (TextLine line in block.lines) {
//         if (regEx.hasMatch(line.text!)) {
//           cardnumber += "${line.text} \n";
//           for (TextElement element in line.elements) {
//             _elements.add(element);
//           }
//         }
//         if (regEx1.hasMatch(line.text!)) {
//           expire += "${line.text} \n";
//           for (TextElement element in line.elements) {
//             _elements.add(element);
//           }
//         }
//         if (regEx2.hasMatch(line.text!)) {
//           cardname += "${line.text} \n";
//           for (TextElement element in line.elements) {
//             _elements.add(element);
//           }
//         }
//       }
//     }
//
//     // Navigator.of(context).pop();
//   }
//
//   Future<void> _getImageSize(File imageFile) async {
//     final Completer<Size> completer = Completer<Size>();
//
//     final Image image = Image.file(imageFile);
//     image.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener((ImageInfo info, bool _) {
//         completer.complete(Size(
//           info.image.width.toDouble(),
//           info.image.height.toDouble(),
//         ));
//       }),
//     );
//
//     final Size imageSize = await completer.future;
//     setState(() {
//       _imageSize = imageSize;
//     });
//   }
//
//   @override
//   void initState() {
//     _initializeVision();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Card Details"),
//       ),
//       body: _imageSize != null
//           ? Stack(
//               children: <Widget>[
//                 Center(
//                   child: Container(
//                     width: double.maxFinite,
//                     color: Colors.black,
//                     child: CustomPaint(
//                       foregroundPainter:
//                           TextDetectorPainter(_imageSize!, _elements),
//                       child: AspectRatio(
//                         aspectRatio: _imageSize!.aspectRatio,
//                         child: Image.file(imageFile!),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Card(
//                     elevation: 8,
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: Text(
//                               "Identified card details",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             // height: 60,
//                             child: SingleChildScrollView(
//                               physics: ClampingScrollPhysics(),
//                               child: Text(
//                                 "Card number: $cardnumber",
//                               ),
//                             ),
//                           ),
//                           Container(
//                             // height: 60,
//                             child: SingleChildScrollView(
//                               physics: ClampingScrollPhysics(),
//                               child: Text(
//                                 "expire: $expire",
//                               ),
//                             ),
//                           ),
//                           Container(
//                             // height: 60,
//                             child: SingleChildScrollView(
//                               physics: ClampingScrollPhysics(),
//                               child: Text(
//                                 "card name: $cardname",
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: 20,
//                           ),
//                           Row(
//                             children: [
//                               Spacer(),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) {
//                                     return Deposit(
//                                       cardnumber: cardnumber,
//                                       carname: cardname,
//                                       expire: expire,
//                                     );
//                                     // return PreviewScreen(imgPath: path, fileName: "$name.png",);
//                                   }));
//                                 },
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     height: 40,
//                                     width: 100,
//                                     child: Text("Ok"),
//                                   ),
//                                 ),
//                               ),
//                               Spacer(),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : Container(
//               color: Colors.black,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//     );
//   }
// }
//
// class TextDetectorPainter extends CustomPainter {
//   TextDetectorPainter(this.absoluteImageSize, this.elements);
//
//   final Size absoluteImageSize;
//   final List<TextElement> elements;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     Rect scaleRect(TextContainer container) {
//       return Rect.fromLTRB(
//         container.boundingBox!.left * scaleX,
//         container.boundingBox!.top * scaleY,
//         container.boundingBox!.right * scaleX,
//         container.boundingBox!.bottom * scaleY,
//       );
//     }
//
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = Colors.red
//       ..strokeWidth = 2.0;
//
//     for (TextElement element in elements) {
//       canvas.drawRect(scaleRect(element), paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(TextDetectorPainter oldDelegate) {
//     return true;
//   }
// }
