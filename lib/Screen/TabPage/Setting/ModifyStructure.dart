import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:share_plus/share_plus.dart';

class ModifyStructure extends StatefulWidget {

  final String name;
  Function(bool result) refreshCallback;
  ModifyStructure({Key? key, required this.name, required this.refreshCallback}) : super(key: key);

  @override
  State<ModifyStructure> createState() => _ModifyStructureState();
}

class _ModifyStructureState extends State<ModifyStructure> with TickerProviderStateMixin {
  late AnimationController _animationController;

  bool modifica = false;
  late TextEditingController nomeC;
  String? dropdownValue = '';
  String uid = '';
  String type = '';

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    nomeC = TextEditingController(text: widget.name);
    super.initState();
    _getData2();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nomeC.dispose();
    super.dispose();
  }

  void _getData2() async {
    final databaseRef = FirebaseDatabase.instance.ref().child('structure/${widget.name}');
    final snapshot = await databaseRef.once();
    final data = snapshot.snapshot.value as Map;
    setState(() {
      uid = '${data['uid']}';
      type = '${data['type']}';
    });
  }

  void _renameStructureData() {
    final DatabaseReference db = FirebaseDatabase.instance.ref();
    db.child('${widget.name}').once().then((result) async {
      var yourData = result.snapshot.value;
      var response = await db.child('${nomeC.text.trim()}').set(yourData);
    });
  }

  List<String> typeList = ['Casa', 'Appartamento', 'Fienile', 'B&B', 'Baita', 'Casa Particular', 'Castello', 'Hotel', 'Trullo', 'Mulino'];

  bool _open = false;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color.fromARGB(255, 216, 179, 124), Color.fromARGB(255, 255, 112, 3)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        foregroundColor: textColor,
        elevation: 0,
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            widget.refreshCallback(true);
          },
        ),
        actions: [
          CupertinoButton(
              child: Icon(CupertinoIcons.share),
              onPressed: () {
                Share.share('Accedi anche tu alla struttura con questo codice: ${uid}', subject: 'Codice struttura');
                HapticFeedback.lightImpact();
              }),
          Visibility(
            visible: !modifica,
            child: CupertinoButton(
              child: Icon(
                CupertinoIcons.pencil,
              ),
              onPressed: () {
                setState(() {
                  modifica = true;
                });
              },
            ),
          ),
          Visibility(
            visible: modifica,
            child: CupertinoButton(
              child: Text('Fatto'),
              onPressed: () async {
                if (widget.name != nomeC.text.trim()) {
                  setState(() {
                    modifica = false;
                  });
                  await FirebaseDatabase.instance.ref().child('structure/${widget.name}').update({'name': nomeC.text.trim()});
                  Future.delayed(Duration(seconds: 2), () async {
                    FirebaseDatabase.instance.ref().child('structure').child('${widget.name}').once().then((DatabaseEvent event) async {
                      DataSnapshot snapshot = event.snapshot;
                      await FirebaseDatabase.instance.ref().child('structure/${nomeC.text.trim()}').set(snapshot.value).then((value) async {
                        await FirebaseDatabase.instance.ref().child('structure/${widget.name}').remove();
                      });
                      await FirebaseDatabase.instance
                          .ref()
                          .child('users/${FirebaseAuth.instance.currentUser!.uid}/structureGuest')
                          .update({'name': nomeC.text.trim()});
                    });
                  }).then((value) {
                    widget.refreshCallback(true);
                    Navigator.pop(context);
                  });
                } else {
                  setState(() {
                    modifica = false;
                  });
                }
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Column(
            children: [
              Text(
                'Stucture code is:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: textColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    uid == 'null' ? 'Loading...' : uid,
                    style: TextStyle(foreground: Paint()..shader = linearGradient, letterSpacing: 2.0, fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        'Nome struttura'.toUpperCase(),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
                      ),
                    ),
                    CupertinoTextField.borderless(
                      readOnly: !modifica,
                      maxLines: 1,
                      minLines: 1,
                      placeholderStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
                      controller: nomeC,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _open = !_open;
                    });
                  },
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.linear,
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: width,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity, // Espande il Text per coprire tutta la larghezza del Container
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Tipo struttura',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    dropdownValue == '' ? type : dropdownValue!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            firstChild: const SizedBox(),
                            secondChild: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: Container(
                                height: height * .2,
                                width: width,
                                child: CupertinoPicker(
                                  itemExtent: 32,
                                  onSelectedItemChanged: (int index) async {
                                    setState(() {
                                      dropdownValue = typeList[index];
                                    });
                                    await FirebaseDatabase.instance.ref().child('structure/${widget.name}').update({'type': typeList[index]});
                                  },
                                  children: typeList.map((String value) {
                                    return Center(
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Divider(
        height: 1,
      ),
    );
  }
}
