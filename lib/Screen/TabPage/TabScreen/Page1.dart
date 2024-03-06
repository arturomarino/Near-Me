import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_me/Screen/TabPage/Dati%20Viaggiatore/CardDetaisPages/IdentityCardDetails.dart';
import 'package:near_me/Screen/TabPage/Dati%20Viaggiatore/Page2.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'Page1.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Page1 extends StatefulWidget {
  final String structure;
  const Page1({Key? key, required this.structure}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  List<String> nameList = [];
  List<String> surnameList = [];
  List<String> paeseList = [];
  List<String> sessoList = [];
  List<String> nazionalitaList = [];
  List<String> nascitaList = [];
  List<String> scadenzaDocList = [];
  List<String> nDocList = [];
  List<String> emissioneDocList = [];
  List<String> tipoDocList = [];
  List<bool> sendList = [];

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("users/$currentUser/documents");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String nome = values["nome"];
        String cognome = values["cognome"];
        String paese = values["paese"];
        String sesso = values["sesso"];
        String nazionalita = values["nazionalita"];
        String nascita = values["dataNascita"];
        String scadenza = values["dataScadenza"];
        String nDoc = values["nDoc"];
        String emissioneDoc = values["dataEmissione"];
        String tipoDoc = values["tipoDoc"];
        bool send = values["inviato"] == null ? false : values["inviato"];
        print('send $send');

        nameList.add(nome);
        surnameList.add(cognome);
        paeseList.add(paese);
        sessoList.add(sesso);
        nazionalitaList.add(nazionalita);
        nascitaList.add(nascita);
        scadenzaDocList.add(scadenza);
        nDocList.add(nDoc);
        emissioneDocList.add(emissioneDoc);
        tipoDocList.add(tipoDoc);
        sendList.add(send);
        print(sendList);
        
      });
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    nameList.clear();
    surnameList.clear();
    paeseList.clear();
    sessoList.clear();
    nazionalitaList.clear();
    nascitaList.clear();
    scadenzaDocList.clear();
    nDocList.clear();
    emissioneDocList.clear();
    tipoDocList.clear();
    sendList.clear();
    _getData();
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    HapticFeedback.heavyImpact();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: textColor,
        elevation: 0,
        actions: [
          CupertinoButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Page2(
                            structure: widget.structure,
                          )),
                );
              })
        ],
      ),
      body: SafeArea(
          child: SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
          child: Container(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.i_tuoi_documenti,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          AppLocalizations.of(context)!.questi_dati,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: nameList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CupertinoButton(
                                pressedOpacity: 0.1,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => IdentityCardDetails(
                                              name: nameList[index],
                                              cognome: surnameList[index],
                                              paese: paeseList[index],
                                              sess: sessoList[index],
                                              naz: nazionalitaList[index],
                                              nascita: nascitaList[index],
                                              scadenza: scadenzaDocList[index],
                                              nDoc: nDocList[index],
                                              emissioneDoc: emissioneDocList[index],
                                              tipoDoc: tipoDocList[index],
                                              structure: widget.structure,
                                            )),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                                      child: Row(
                                        children: [
                                          Stack(children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(150),
                                              child: Container(
                                                width: 42,
                                                height: 42,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[500],
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    CupertinoIcons.person_fill,
                                                    color: Colors.white,
                                                    size: 48,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: (Colors.grey[500])!,
                                                  width: 3.0,
                                                ),
                                              ),
                                              child: SizedBox(),
                                            ),
                                          ]),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  nameList[index],
                                                  maxLines: 1,
                                                  style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      sessoList[index],
                                                      style: TextStyle(color: textColor2, fontSize: 12, fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(' - ', style: TextStyle(color: textColor2, fontSize: 12, fontWeight: FontWeight.w500)),
                                                    Text(
                                                      nascitaList[index],
                                                      style: TextStyle(color: textColor2, fontSize: 12, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Visibility(
                                              visible: sendList[index],
                                              child: Icon(
                                                CupertinoIcons.paperplane_fill,
                                                color: Colors.green,
                                                size: 15,
                                              )),
                                          SizedBox(width: 3),
                                          Visibility(
                                            visible: sendList[index],
                                            child: Text(
                                              AppLocalizations.of(context)!.inviato,
                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green, fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0),
                                            child: Icon(
                                              CupertinoIcons.chevron_right,
                                              color: Colors.grey,
                                              size: 17,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Divider(
                                  height: 1,
                                ),
                              )
                            ],
                          );
                          /*return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IdentityCardDetails(
                                          name: nameList[index],
                                          cognome: surnameList[index],
                                          paese: paeseList[index],
                                          sess: sessoList[index],
                                          naz: nazionalitaList[index],
                                          nascita: nascitaList[index],
                                          scadenza: scadenzaDocList[index],
                                          nDoc: nDocList[index],
                                          emissioneDoc: emissioneDocList[index],
                                          tipoDoc: tipoDocList[index],
                                          structure: widget.structure,
                                        )),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Container(
                                height: height * .08,
                                decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 30,
                                        color: textColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            nameList[index],
                                            style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                sessoList[index],
                                                style: TextStyle(color: textColor2, fontSize: 12, fontWeight: FontWeight.w500),
                                              ),
                                              Text(' - ', style: TextStyle(color: textColor2, fontSize: 12, fontWeight: FontWeight.w500)),
                                              Text(
                                                nascitaList[index],
                                                style: TextStyle(color: textColor2, fontSize: 12, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: textColor,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );*/
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
