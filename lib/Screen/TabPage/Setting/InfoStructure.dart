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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translator/translator.dart';

class InfoStructure extends StatefulWidget {
  final String name;
  Function(bool result) refreshCallback;
  InfoStructure({Key? key, required this.name, required this.refreshCallback}) : super(key: key);

  @override
  State<InfoStructure> createState() => _InfoStructureState();
}

class _InfoStructureState extends State<InfoStructure> with SingleTickerProviderStateMixin {
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
    _getData2();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nomeC.dispose();
    super.dispose();
  }

    GoogleTranslator translator = GoogleTranslator();

  void _getData2() async {
    final databaseRef = FirebaseDatabase.instance.ref().child('structure/${widget.name}');
    final snapshot = await databaseRef.once();
    final data = snapshot.snapshot.value as Map;
    translator.translate(data['type'], to: Localizations.localeOf(context).languageCode).then((value) {
          setState(() {
            type = value.text;
          });});
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
              })
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.codice_struttura,
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
                        AppLocalizations.of(context)!.nome_struttura.toUpperCase(),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
                      ),
                    ),
                    CupertinoTextField.borderless(
                      readOnly: false,
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
                                  AppLocalizations.of(context)!.tipo_struttura,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                    fontSize: 15,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  dropdownValue == ''
                                      ? type == 'null'
                                          ? 'Loading...'
                                          : type
                                      : dropdownValue!,
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
                        /*AnimatedCrossFade(
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
                                      dropdownValue = type[index];
                                    });
                                    await FirebaseDatabase.instance.ref().child('structure/${widget.name}').update({'type': type[index]});
                                  },
                                  children: type.map((String value) {
                                    return Center(
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.right,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            crossFadeState: _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          ),*/
                      ],
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
      padding: const EdgeInsets.only(left: 20),
      child: Divider(
        height: 1,
      ),
    );
  }
}
