import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Setting/AdminListPage.dart';

class AddPage extends StatefulWidget {
  final DatabaseReference ref;
  final String lat;
  final String lng;
  final String image;
  final String name;
  final String website;
  final String phone;
  final String indirizzo;
  final List<String> photos;
  final List weekDay;
  const AddPage(
      {Key? key,
      required this.lat,
      required this.lng,
      required this.image,
      required this.name,
      required this.website,
      required this.phone,
      required this.indirizzo,
      required this.photos,
      required this.ref,
      required this.weekDay})
      : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    content: Row(
      children: [
        SizedBox(child: Icon(CupertinoIcons.doc_on_doc), height: 35, width: 35),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        )
      ],
    ),
    backgroundColor: Colors.white,
    //Color.fromARGB(255, 35, 34, 34),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class _AddPageState extends State<AddPage> {
  TextEditingController _fieldController = TextEditingController();
  List weekDayList = [];
  void _resetWeekDay() {
    for (int i = 0; i < widget.weekDay.length; i++) {
      weekDayList.add(widget.weekDay[i]);
    }
    setState(() {
      weekDayList = widget.weekDay;
    });
    print('week: $weekDayList');
  }

  @override
  void initState() {
    _resetWeekDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 252, 1),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            CupertinoButton(
                child: Text(
                  "Aggiungi",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  if (widget.photos.isEmpty) {
                    await widget.ref.child('${widget.name}').update({
                      'lat': widget.lat,
                      'lng': widget.lng,
                      //'image': place['icon'],
                      'name': widget.name,
                      'website': widget.website,
                      'phone': widget.phone,
                      'indirizzo': widget.indirizzo,
                      'description': _fieldController.text,
                      'weekDay': widget.weekDay
                    });
                  } else {
                    await widget.ref.child('${widget.name}').update({
                      'lat': widget.lat,
                      'lng': widget.lng,
                      //'image': wi,
                      'name': widget.name,
                      'website': widget.website,
                      'photos': widget.photos,
                      'phone': widget.phone,
                      'indirizzo': widget.indirizzo,
                      'description': _fieldController.text,
                      'weekDay': widget.weekDay!
                    });
                    Navigator.pop(context);
                  }
                })
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                    child: Text(
                      widget.name,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: widget.indirizzo));
                        HapticFeedback.heavyImpact();
                        showSnackBar(context, 'Copiato negli appunti');
                      },
                      child: Text(
                        widget.indirizzo,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: GestureDetector(
                          onTap: () {
                            launch(widget.website);
                          },
                          onLongPress: () async {
                            await Clipboard.setData(ClipboardData(text: widget.website));
                            HapticFeedback.heavyImpact();
                            showSnackBar(context, 'Copiato negli appunti');
                          },
                          child: Text(
                            widget.website != 'null'?widget.website:'',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueAccent),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.6,
            ),
            ExpansionTile(
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              collapsedTextColor: Colors.black,
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              textColor: Colors.black,
              initiallyExpanded: true,
              title: Text(
                "Immagini",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              children: [
                Container(
                  width: width,
                  height: height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.photos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            child: Image.network(widget.photos[index]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              color: Colors.white,
              //height: height * .1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoTextField.borderless(
                  controller: _fieldController,
                  placeholder: 'Tocca per aggiungere una descrizione',
                  placeholderStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  minLines: 1,
                  maxLines: 25,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: Icon(
                      CupertinoIcons.line_horizontal_3_decrease,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width,
              color: Colors.white,
              //height: height * .1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coordinate Geospaziali',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            '${widget.lat},${widget.lng}',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () async {
                            bool mappeLaunch = false;
                            bool googleMapsLaunch = false;
                            if (await canLaunch('https://maps.apple.com/?q=${widget.lat},${widget.lng}')) {
                              setState(() {
                                mappeLaunch = true;
                              });
                            }
                            if (await canLaunch('comgooglemaps://?q=${widget.lat},${widget.lng}')) {
                              setState(() {
                                googleMapsLaunch = true;
                              });
                            }
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                cancelButton: CupertinoActionSheetAction(
                                  /// This parameter indicates the action would be a default
                                  /// defualt behavior, turns the action's text to bold text.
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                actions: [
                                  Visibility(
                                    visible: mappeLaunch,
                                    child: Container(
                                      color: Colors.white,
                                      child: CupertinoActionSheetAction(
                                        onPressed: () {
                                          launch('https://maps.apple.com/?q=${widget.lat},${widget.lng}');
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Open with Mappe',
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: googleMapsLaunch,
                                    child: Container(
                                      color: Colors.white,
                                      child: CupertinoActionSheetAction(
                                        onPressed: () {
                                          launch('comgooglemaps://?q=${widget.lat},${widget.lng}');
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Open with Google Maps',
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              color: Colors.white,
              //height: height * .1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.phone_fill,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Numero di Telefono',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            widget.phone != 'null'?widget.phone:'',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: widget.indirizzo));
                            HapticFeedback.heavyImpact();
                            showSnackBar(context, 'Copiato negli appunti');
                          })
                    ],
                  )),
            ),
            SizedBox(height: 10),
            Container(
              width: width,
              color: Colors.white,
              //height: height * .1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.phone_fill,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Orari di Apertura',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: widget.indirizzo));
                            HapticFeedback.heavyImpact();
                            showSnackBar(context, 'Copiato negli appunti');
                          })
                    ],
                  )),
            )
          ],
        ));
  }
}
