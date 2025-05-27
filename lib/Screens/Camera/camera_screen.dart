import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:dynamic_center/Screens/Camera/preview.dart';
import 'package:dynamic_center/Screens/ocr/firebasevision/rectangle.dart';
import 'package:dynamic_center/general/component/rounded_button.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

import '../../constant/doublebutton.dart';

class CameraScreen extends StatefulWidget {
  bool camerabutton, cameracenter;
  String cameraAppbar, card;
  final Rectangle validRectangle;
  final double traceMultiplier;
  CameraScreen(
      {Key? key,
      this.cameracenter = false,
      this.validRectangle =
          const Rectangle(width: 390, height: 270, color: Colors.transparent),
      this.cameraAppbar = "",
      this.traceMultiplier = 1.2,
      this.card = "",
      this.camerabutton = true})
      : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

enum AnimationState { search, barcodeNear, barcodeFound, endSearch }

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? cameraController;
  List cameras = [];
  int selectedCameraIndex = 0;
  String imgPath = "";
  bool _closeWindow = false;
  AnimationState _currentState = AnimationState.search;
  CustomPainter? _animationPainter;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  AnimationController? _animationController;
  int _animationStart = DateTime.now().millisecondsSinceEpoch;
  void _initAnimation(Duration duration) {
    setState(() {
      _animationPainter = null;
    });

    _animationController!.dispose();
    _animationController = AnimationController(duration: duration, vsync: this);
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  void _switchAnimationState(AnimationState newState) async {
    // hasLamp = await Lamp.hasLamp;
    if (newState == AnimationState.search) {
      _initAnimation(const Duration(milliseconds: 750));

      _animationPainter = RectangleOutlinePainter(
        animation: RectangleTween(
          Rectangle(
            width: widget.validRectangle.width,
            height: widget.validRectangle.height,
            color: Colors.white,
          ),
          Rectangle(
            width: widget.validRectangle.width * widget.traceMultiplier,
            height: widget.validRectangle.height * widget.traceMultiplier,
            color: Colors.transparent,
          ),
        ).animate(_animationController!),
      );

      _animationController!.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          Future<void>.delayed(const Duration(milliseconds: 1600), () {
            if (_currentState == AnimationState.search) {
              _animationController!.forward(from: 0);
            }
          });
        }
      });
    } else if (newState == AnimationState.barcodeNear ||
        newState == AnimationState.barcodeFound ||
        newState == AnimationState.endSearch) {
      double begin = 0.0;
      if (_currentState == AnimationState.barcodeNear) {
        begin = lerpDouble(0.0, 0.5, _animationController!.value)!;
      } else if (_currentState == AnimationState.search) {
        _initAnimation(const Duration(milliseconds: 500));
        begin = 0.0;
      }

      _animationPainter = RectangleTracePainter(
        rectangle: Rectangle(
          width: widget.validRectangle.width,
          height: widget.validRectangle.height,
          color: newState == AnimationState.endSearch
              ? Colors.transparent
              : Colors.white,
        ),
        animation: Tween<double>(
          begin: begin,
          end: newState == AnimationState.barcodeNear ? 0.5 : 1.0,
        ).animate(_animationController!),
      );

      if (newState == AnimationState.barcodeFound) {
        _animationController!.addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            Future<void>.delayed(const Duration(milliseconds: 300), () {
              if (_currentState != AnimationState.endSearch) {
                _switchAnimationState(AnimationState.endSearch);
                setState(() {});
                // _showBottomSheet();
              }
            });
          }
        });
      }
    }

    _currentState = newState;
    if (newState != AnimationState.endSearch) {
      _animationController!.forward(from: 0);
      _animationStart = DateTime.now().millisecondsSinceEpoch;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    cameraController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    if (cameraController!.value.hasError) {
      print('Camera Error ${cameraController!.value.errorDescription}');
    }

    try {
      await cameraController!.initialize();

      await Future.wait([
        cameraController!
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController!
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
      ]);
      onSetFlashModeButtonPressed(FlashMode.off);
    } catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Display camera preview

  Widget cameraPreview(context) {
    Size size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Text(
        'Loading',
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
    }

    return Transform.scale(
      scale: cameraController!.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: cameraController!.value.aspectRatio,
          child: CameraPreview(cameraController!),
        ),
      ),
    );
  }

  Widget cameraControl(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                onCapture(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget cameraToggle() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: DoubleButton(
          name:
              '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
          textcolor: Colors.white,
          press: () {
            onSwitchCamera();
          },
        ),
      ),
    );
  }

  onCapture(context) async {
    if (cameraController?.value.flashMode == FlashMode.auto ||
        cameraController?.value?.flashMode == FlashMode.always) {
      cameraController!.setFocusMode(FocusMode.locked);
    } else {
      cameraController!.setFocusMode(FocusMode.auto);
    }
    try {
      await cameraController!.takePicture().then((XFile value) {
        print('here');
        print(value.path);
        if (widget.card != null) {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   cameraController?.dispose();
          //   return DetailScreen(value.path, "camera");
          // }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            cameraController?.dispose();
            return PreviewScreen(
              imgPath: value.path,
              fileName: "$name.png",
            );
          }));
        }
      });
    } catch (e) {
      showCameraException(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        initCamera(cameras[selectedCameraIndex]).then((value) {});
      } else {
        print('No camera available');
      }
    }).catchError((e) {
      print('Error : ${e.code}');
    });

    _switchAnimationState(AnimationState.search);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
              heightFactor: size.height,
              alignment: Alignment.center,
              child: cameraPreview(context),
            ),
            Visibility(
              visible: widget.cameracenter,
              child: Container(
                constraints: const BoxConstraints.expand(),
                margin: EdgeInsets.only(bottom: 70),
                child: CustomPaint(
                  painter: WindowPainter(
                    windowSize: Size(widget.validRectangle.width,
                        widget.validRectangle.height),
                    outerFrameColor: Color(kShrineScrim),
                    closeWindow: _closeWindow,
                    innerFrameColor: _currentState == AnimationState.endSearch
                        ? Colors.transparent
                        : Color(kShrineFrameBrown),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.cameracenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 70),
                constraints: const BoxConstraints.expand(),
                child: CustomPaint(
                  painter: _animationPainter,
                ),
              ),
            ),
            Visibility(
              visible: widget.cameracenter,
              child: Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const <Color>[Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Spacer(),
                    Text(
                      widget.cameraAppbar,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.white),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.cameracenter,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/frame.png"),
                        Container(
                          height: 40,
                        ),
                        Text(
                          "Position your document inside the frame. Make sure that all the data is clearly visible.",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: (size.height - 250),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            _minAvailableExposureOffset.toString(),
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          Slider(
                            value: _currentExposureOffset,
                            min: _minAvailableExposureOffset,
                            max: _maxAvailableExposureOffset,
                            label: _currentExposureOffset.toString(),
                            onChanged: _minAvailableExposureOffset ==
                                    _maxAvailableExposureOffset
                                ? null
                                : setExposureOffset,
                          ),
                          Text(
                            _maxAvailableExposureOffset.toString(),
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    widget.camerabutton ? cameraToggle() : Spacer(),
                    widget.camerabutton
                        ? cameraControl(context)
                        : RoundedButton(
                            text: "Scan Now",
                            press: () {
                              onCapture(context);
                            },
                          ),
                    Spacer(),
                    IconButton(
                        icon: getFlashlight(cameraController?.value?.flashMode),
                        color: Colors.white,
                        onPressed: () {
                          switch (cameraController?.value?.flashMode) {
                            case FlashMode.off:
                              onSetFlashModeButtonPressed(FlashMode.auto);
                              return;
                            case FlashMode.auto:
                              onSetFlashModeButtonPressed(FlashMode.always);
                              return;
                            case FlashMode.always:
                              onSetFlashModeButtonPressed(FlashMode.torch);
                              return;
                            case FlashMode.torch:
                              onSetFlashModeButtonPressed(FlashMode.off);
                              return;
                            default:
                              onSetFlashModeButtonPressed(FlashMode.off);
                              return;
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  Widget getFlashlight(flashMode) {
    switch (flashMode) {
      case FlashMode.off:
        return Icon(Icons.flash_off);
      case FlashMode.auto:
        return Icon(Icons.flash_auto);
      case FlashMode.always:
        return Icon(Icons.flash_on);
      case FlashMode.torch:
        return Icon(Icons.highlight);
      default:
        return Icon(Icons.flash_off);
    }
  }

  onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    initCamera(selectedCamera);
  }

  showCameraException(e) {
    String errorText = 'Error ${e.code} \nError message: ${e.description}';
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setExposureOffset(double offset) async {
    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await cameraController!.setExposureOffset(offset);
    } on CameraException catch (e) {
      // _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await cameraController!.setFlashMode(mode);
    } on CameraException catch (e) {
      // _showCameraException(e);
      rethrow;
    }
  }
}
