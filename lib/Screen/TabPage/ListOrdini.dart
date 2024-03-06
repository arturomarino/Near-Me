import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../DetailsView/core/utils/size_utils.dart';

class ListaOrdini extends StatefulWidget {
  final String structure;
  const ListaOrdini({Key? key, required this.structure}) : super(key: key);

  @override
  State<ListaOrdini> createState() => _ListaOrdiniState();
}

class _ListaOrdiniState extends State<ListaOrdini> {
  List<String> nomeOspiteList = [];
  List<String> prezzoList = [];
  List<String> nomeServizioList = [];
  List<bool> servizioCompletatoList = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/richiesteServizi");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String nomeOspite = values["ospite"];
        String prezzoServizio = values["orders"]["prezzo"] == null ? '' : values["orders"]["prezzo"];
        String nomeServizio = values["orders"]["servizio_richiesto"];
        bool servizioCompletato = values["orders"]["completato"] == null ? false : values["orders"]["completato"];
        nomeOspiteList.add(nomeOspite);
        prezzoList.add(prezzoServizio);
        nomeServizioList.add(nomeServizio);
        servizioCompletatoList.add(servizioCompletato);
      });
    });
    Future.delayed(Duration(milliseconds: 500), () {
      print(nomeOspiteList);
      print(prezzoList);
      print(nomeServizioList);
      print(servizioCompletatoList);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;

    final blueColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 16, 70, 114) : Color.fromARGB(255, 29, 134, 219);
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            actions: [
              CupertinoButton(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    nomeServizioList.clear();
                    prezzoList.clear();
                    nomeOspiteList.clear();
                    servizioCompletatoList.clear();
                    _getData();
                    setState(() {});
                  })
            ],
            elevation: 0,
            backgroundColor: blueColor,
            title: Text(
              "Ordini",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                SizedBox(height: 7),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: nomeServizioList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: width,
                        height: height * .14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: new TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(text: nomeOspiteList[index],style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                                      new TextSpan(text: ' requested ', style: new TextStyle(fontWeight: FontWeight.normal, color: textColor)),
                                      TextSpan(text: nomeServizioList[index],style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  prezzoList[index] != '' ? '${prezzoList[index]}' : 'Prezzo non disponibile',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: servizioCompletatoList[index] != true || servizioCompletatoList.isEmpty ? true : false,
                              child: CupertinoButton(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "Accept service request".toUpperCase(),
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black),
                                  )),
                                  height: 25,
                                  width: width * .4,
                                  decoration: BoxDecoration(color: Color.fromARGB(255, 140, 255, 144), borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${widget.structure}/richiesteServizi/${nomeOspiteList[index]}')
                                      .update({
                                    'ospite': nomeOspiteList[index],
                                    'orders': {'servizio_richiesto': nomeServizioList[index], 'prezzo': prezzoList[index], 'completato': true}
                                  });
                                  Future.delayed(Duration(seconds: 2), () {
                                    nomeServizioList.clear();
                                    prezzoList.clear();
                                    nomeOspiteList.clear();
                                    servizioCompletatoList.clear();
                                    _getData();
                                    setState(() {});
                                  });

                                  HapticFeedback.lightImpact();
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            Visibility(
                              visible: servizioCompletatoList[index] != true ? false : true,
                              child: CupertinoButton(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "Remove order".toUpperCase(),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                                  )),
                                  height: 25,
                                  width: width * .3,
                                  decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${widget.structure}/richiesteServizi/${nomeOspiteList[index]}')
                                      .remove();
                                  Future.delayed(Duration(seconds: 2), () {
                                    nomeServizioList.clear();
                                    prezzoList.clear();
                                    nomeOspiteList.clear();
                                    servizioCompletatoList.clear();
                                    _getData();
                                    setState(() {});
                                  });

                                  HapticFeedback.lightImpact();
                                },
                                padding: EdgeInsets.zero,
                              ),
                            )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                        color: textColor2,
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
