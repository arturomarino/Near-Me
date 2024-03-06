import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'storage_service.dart';

class ScriviRecensione extends StatefulWidget {
  const ScriviRecensione({Key? key}) : super(key: key);

  @override
  State<ScriviRecensione> createState() => _ScriviRecensioneState();
}

final Stream<QuerySnapshot> _prodottiStream =
    FirebaseFirestore.instance.collection('recensioni').snapshots();
final storageRef = FirebaseStorage.instance.ref();

final valuestar = ['-', '5', '4.5', '4', '3.5', '3', '2.5'];

final DateTime now1 = DateTime.now();
DateFormat formatterDatePickerIdeal = DateFormat('dd/MM/yyyy');
late String formattedDatePickerIdeal = formatterDatePickerIdeal.format(now1);

final LinearGradient gradient4 = LinearGradient(
  colors: <Color>[
    Color.fromARGB(255, 255, 236, 210),
    Color.fromARGB(255, 253, 184, 161)
  ],
);

String name = "";
String paese = "";
String title = "";
String mess = "";
String nameOfImage = "";
String urlImage = "";
bool isUploaded = false;

class _ScriviRecensioneState extends State<ScriviRecensione> {
  final Storage storage = Storage();

  //From Photo
  Future pickImageFromPhoto() async {
    try {
      final results =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (results == null) {
        return ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No File Selected")));
      }

      final path = results.path;
      final fileName = name;

      setState(() {
        nameOfImage = fileName;
      });
      //print(path);
      //print(fileName);

      if (path == null && fileName == null) {
        HapticFeedback.heavyImpact();
        return ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Annulled")));
      } else {
        storage.uploadFile(path, fileName).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("File Uploaded"))),
              setState(() {
                isUploaded = true;
              })
            });

        HapticFeedback.lightImpact();
      }
    } on PlatformException catch (e) {
      print("Failed: ($e)");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text("Error")));
    }
  }

  String imageUrl = "";
  //from Camera
  Future pickImageFromCamera() async {
    try {
      final results = await ImagePicker.platform.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (results == null) {
        return ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Image Selected")));
      }

      final path = results.path;
      final fileName = name;

      setState(() {
        nameOfImage = fileName;
      });

      if (path == null && fileName == null) {
        HapticFeedback.heavyImpact();
        return ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Annulled")));
      } else {
        if (isUploaded == false) {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
              backgroundColor: Colors.yellow, content: Row(
                children: [
                  Text("Loading...",style: TextStyle(color: Colors.black),),
                ],
              )));
        }
        storage.uploadFile(path, fileName).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("File Uploaded"))),
              setState(() {
                isUploaded = true;
              })
            });

        HapticFeedback.lightImpact();
      }
    } on PlatformException catch (e) {
      print("Failed: ($e)");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text("Error")));
    }
  }

  sendData() async {
    Reference ref = FirebaseStorage.instance.ref('userImage/$nameOfImage');
    String _myUrl = await ref.getDownloadURL();
    String urlImage = _myUrl.toString();

    FirebaseFirestore.instance.collection('recensioni').add({
      'cliente': name,
      'date': formattedDatePickerIdeal,
      'location': paese,
      'rating': valuestar[index],
      'title': title,
      'subtitle': mess,
      'dislikeCounter': 0,
      'likeCounter': 0,
      'like': {},
      'image': '$urlImage'
    });
  }

  void getUrl() async {
    Reference ref = FirebaseStorage.instance.ref('userImage/$nameOfImage');

    String imageUrl = await ref.getDownloadURL();

    setState(() {
      urlImage = imageUrl;
    });
    print("image url:$imageUrl");
    print('url image: $urlImage');
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(198, 54, 51, 51)
            : Colors.white;
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;

    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      CupertinoButton(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: textColor,
                            size: 27,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Container(
                        decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                            gradient: gradient4,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: CupertinoTextField.borderless(
                                        maxLength: 15,
                                        onChanged: (value) {
                                          name = value;
                                        },
                                        placeholder:
                                            AppLocalizations.of(context)!.nome,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17)),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "$formattedDatePickerIdeal",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.5)),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CupertinoButton(
                                      child: Text(
                                        AppLocalizations.of(context)!.valuta,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoActionSheet(
                                                  actions: [buildPicker()],
                                                  cancelButton:
                                                      CupertinoActionSheetAction(
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .seleziona),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ));
                                      }),
                                  Text(valuestar[index]),
                                  SizedBox(width: 5),
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    width: 150,
                                    child: CupertinoTextField.borderless(
                                        onChanged: (value) {
                                          paese = value;
                                        },
                                        textAlign: TextAlign.right,
                                        placeholder:
                                            AppLocalizations.of(context)!.paese,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 300,
                                      child: CupertinoTextField.borderless(
                                          onChanged: (value) {
                                            title = value;
                                          },
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .titolo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: 300,
                                      child: CupertinoTextField.borderless(
                                          onChanged: (value) {
                                            mess = value;
                                          },
                                          textAlign: TextAlign.start,
                                          textInputAction: TextInputAction.done,
                                          maxLines: 15,
                                          minLines: 1,
                                          placeholder:
                                              AppLocalizations.of(context)!
                                                  .mess,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CupertinoButton(
                                      child: Icon(
                                        CupertinoIcons.photo,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        if (name == "") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      "Inserisci prima tutti i campi"),
                                                  duration: Duration(
                                                      milliseconds: 700)));
                                        } else if (isUploaded == false) {
                                          pickImageFromPhoto();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      "Immagine già caricata"),
                                                  duration: Duration(
                                                      milliseconds: 700)));
                                        }
                                      }),
                                  CupertinoButton(
                                      child: Icon(
                                        CupertinoIcons.camera_fill,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        if (name == "") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "Inserisci prima tutti i campi"),
                                            duration:
                                                Duration(milliseconds: 700),
                                          ));
                                        } else if (isUploaded == false) {
                                          pickImageFromCamera();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      "Immagine già caricata"),
                                                  duration: Duration(
                                                      milliseconds: 700)));
                                        }
                                      }),
                                  Expanded(child: Container()),
                                  CupertinoButton(
                                      child: Text(
                                        AppLocalizations.of(context)!.pubblica,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13),
                                      ),
                                      onPressed: () {
                                        if (name == "" ||
                                            paese == "" ||
                                            valuestar[index] == "-" ||
                                            title == "" ||
                                            mess == "" ||
                                            isUploaded == false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .errorMess)));
                                        } else {
                                          sendData();
                                          /*Reference ref = FirebaseStorage
                                              .instance
                                              .ref('userImage/$nameOfImage');

                                          String imageUrl =
                                              ref.getDownloadURL().toString();
                                          print(imageUrl);
                                          FirebaseFirestore.instance
                                              .collection('recensioni')
                                              .add({
                                            'cliente': name,
                                            'date': formattedDatePickerIdeal,
                                            'location': paese,
                                            'rating': valuestar[index],
                                            'title': title,
                                            'subtitle': mess,
                                            'dislikeCounter': 0,
                                            'likeCounter': 0,
                                            'like': {},
                                            'image': imageUrl
                                          });*/

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .pubblicato)));
                                          setState(() {
                                            //urlImage = '';
                                            isUploaded = false;
                                          });
                                          if (mounted) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      })
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ))),
    );
  }

  Widget buildPicker() => Container(
      color: Colors.white,
      height: 200,
      child: CupertinoPicker(
          looping: true,
          itemExtent: 64,
          onSelectedItemChanged: (index) {
            setState(() => this.index = index);
            final item = valuestar[index];
          },
          children: valuestar
              .map((e) => Center(
                    child: Text(e),
                  ))
              .toList()));
}
