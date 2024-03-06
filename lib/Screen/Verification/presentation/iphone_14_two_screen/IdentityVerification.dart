import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';

import '../../../DetailsView/core/utils/color_constant.dart';
import '../../../DetailsView/core/utils/size_utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../storage_service.dart';

class Verification extends StatefulWidget {
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int numberOfVerify = 0;
  String numberOfVerifyString = '';
  XFile? fotoScattata;
  XFile? imageFile;
  final _database = FirebaseDatabase.instance.ref();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  String numberOfGuest = '';
  final Storage storage = Storage();
  String name = '';
  String surname = '';

  int direction = 0;

  @override
  void initState() {
    startCamera(direction);
    _activateListeners();
    super.initState();
  }

  void _activateListeners() {
    _database.child('users/$currentUser/number').onValue.listen((event) {
      final Object? numberOfGuestOnDatabase = event.snapshot.value;
      setState(() {
        numberOfGuest = '$numberOfGuestOnDatabase';
      });
    });
    _database.child('users/$currentUser/name').onValue.listen((event) {
      final Object? nameOnDatabase = event.snapshot.value;
      setState(() {
        name = '$nameOnDatabase';
      });
    });

    _database.child('users/$currentUser/surname').onValue.listen((event) {
      final Object? surnameOnDatabase = event.snapshot.value;
      setState(() {
        surname = '$surnameOnDatabase';
      });
    });
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dHeight = MediaQuery.of(context).size.height;
    double dWidth = MediaQuery.of(context).size.width;
    final double _rectHeight = 0.0;
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
    final double _height = logicalSize.height;
    bool textScanning = false;
    String scannedText = '';

    void showSnackBarId(BuildContext context, String number) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Row(
          children: [
            Text(
              'Elemento inviato per la verifica ' + number,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            )
          ],
        ),
        backgroundColor: Colors.green,
        //Color.fromARGB(255, 35, 34, 34),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    /*void getRecognisedText(XFile image) async {
      final inputImage = InputImage.fromFilePath(image.path);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      RecognizedText recognisedText =
          await textDetector.processImage(inputImage);

      await textDetector.close();
      scannedText = "";

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText = scannedText + line.text + "\n";
        }
      }
      textScanning = false;
    }

    void getImage() async {
      try {
        if (fotoScattata != null) {
          textScanning = true;
          imageFile = fotoScattata;
          setState(() {});
          getRecognisedText(fotoScattata!);
        }
      } catch (e) {
        textScanning = false;
        imageFile = null;
        setState(() {});
        scannedText = 'Error';
      }
    }*/

    if (cameraController.value.isInitialized) {
      return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              if (fotoScattata != null)
                Image.file(
                  File(fotoScattata!.path),
                  height: dHeight,
                  width: dWidth,
                ),
              if (fotoScattata == null)
                Center(
                    child: Container(
                  child: CameraPreview(cameraController),
                )),

              /*Container(
                  child: CustomPaint(
                painter: Back(context),
              )),*/
              Container(
                child: CustomPaint(
                  size: Size(dWidth, dHeight),
                  painter: Screen(context),
                ),
              ),
              Container(
                color: Colors.transparent,
                width: size.width,
                padding: getPadding(
                  left: 36,
                  top: 46,
                  right: 36,
                  bottom: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Padding(
                      padding: getPadding(
                        top: 30,
                      ),
                      child: Text(
                        numberOfGuest != numberOfVerifyString
                            ? "Inquadra il tuo documento d’identità"
                            : 'Hai completato la verifica!\nGrazie!',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: numberOfGuest == numberOfVerifyString
                              ? Colors.green
                              : Colors.white,
                          fontSize: getFontSize(
                            16,
                          ),
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible:
                          numberOfGuest != numberOfVerifyString ? true : false,
                      child: Text(
                        '$numberOfVerify/$numberOfGuest',
                        style: TextStyle(
                          color: ColorConstant.whiteA700,
                          fontSize: getFontSize(
                            16,
                          ),
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: dHeight * .15,
                left: dWidth * 0.43,
                child: Row(
                  children: [
                    Visibility(
                      visible: fotoScattata != null ||
                              numberOfGuest == numberOfVerifyString
                          ? false
                          : true,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          fotoScattata = await cameraController.takePicture();
                          setState(() {});
                          storage.uploadFile2(
                              fotoScattata!.path,
                              '${name}_${surname}_${numberOfVerify + 1}',
                              'verifiche/${name} ${surname}');
                        },
                        child: Container(
                          height: getSize(
                            60.00,
                          ),
                          width: getSize(
                            60.00,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                30.00,
                              ),
                            ),
                            border: Border.all(
                              color: Colors.black,
                              width: getHorizontalSize(
                                4.00,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: fotoScattata != null ? true : false,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              if (numberOfVerify != numberOfGuest) {
                                numberOfVerify++;
                                numberOfVerifyString =
                                    numberOfVerify.toString();
                                setState(() {});
                                fotoScattata = null;
                                setState(() {});
                                showSnackBarId(
                                    context, '$numberOfVerify/$numberOfGuest');
                                if (numberOfGuest == numberOfVerifyString) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser)
                                      .update({'IDverified': true});
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.pop(context);
                                  });
                                }
                              } else {
                                print('terminato');
                              }
                            },
                            child: Container(
                              height: getSize(
                                60.00,
                              ),
                              width: getSize(
                                60.00,
                              ),
                              child: Icon(
                                CupertinoIcons.arrow_up,
                                color: fotoScattata != null
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              decoration: BoxDecoration(
                                color: fotoScattata != null
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  getHorizontalSize(
                                    30.00,
                                  ),
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                  width: getHorizontalSize(
                                    3.00,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: dWidth * 0.2),
                        Visibility(
                          visible: fotoScattata != null ? true : false,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              fotoScattata = null;
                              setState(() {});
                            },
                            child: Container(
                              height: getSize(
                                60.00,
                              ),
                              width: getSize(
                                60.00,
                              ),
                              child: Icon(
                                CupertinoIcons.refresh,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  getHorizontalSize(
                                    30.00,
                                  ),
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                  width: getHorizontalSize(
                                    3.00,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ));
      ;
    } else {
      return SizedBox();
    }
  }
}

class Back extends CustomPainter {
  final Color fillColor;
  final BuildContext context;
  Back(
    this.context, {
    this.fillColor = Colors.red,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var paint = Paint()..strokeCap = StrokeCap.round;

    var path = Path();
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(width / 2, height / 2),
                width: width,
                height: height),
            Radius.circular(20)),
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Rectangle extends CustomPainter {
  final Color fillColor;
  final BuildContext context;
  Rectangle(
    this.context, {
    this.fillColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var paint = Paint()..strokeCap = StrokeCap.round;

    var path = Path();

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(width * 0.5, height * 0.5),
                width: width * 0.78,
                height: height * 0.22),
            Radius.circular(20)),
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill
          ..strokeWidth = 5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Screen extends CustomPainter {
  final Color fillColor;
  final BuildContext context;
  Screen(
    this.context, {
    this.fillColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //all screen
    var rect1 = Path()
      ..addRect(
        Rect.fromCenter(
            center: Offset(width / 2, height / 2),
            width: size.width,
            height: size.height),
      );

    //rectangle
    var rect2 = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(width / 2, height / 2),
              width: width * 0.7,
              height: height * 0.2),
          Radius.circular(10)));
    canvas.drawPath(
        Path.combine(PathOperation.difference, rect1, rect2),
        Paint()
          ..color = Colors.black.withOpacity(0.6)
          ..style = PaintingStyle.fill
          ..strokeWidth = 5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
