import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

class ListaServizi extends StatefulWidget {
  final String nomeCognome;
  final String structure;
  const ListaServizi({Key? key, required this.structure, required this.nomeCognome}) : super(key: key);

  @override
  State<ListaServizi> createState() => _ListaServiziState();
}

class _ListaServiziState extends State<ListaServizi> {
  List<String> nomeServizioList = [];
  List<String> prezzoServizioList = [];


  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/servizi");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String nomeServizio = values["nome_servizio"];
        String prezzoServizio = values["prezzo"] == null ? '' : values["prezzo"];
        print(prezzoServizio);
        nomeServizioList.add(nomeServizio);
        prezzoServizioList.add(prezzoServizio);
      });
    });
    Future.delayed(Duration(milliseconds: 500), () {
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
                    prezzoServizioList.clear();
                    _getData();
                    setState(() {});
                  })
            ],
            elevation: 0,
            backgroundColor: blueColor,
            title: Text(
              "Servizi",
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
                        height: height * .1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    nomeServizioList[index],
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: textColor),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    prezzoServizioList[index] != '' ? '€ ${prezzoServizioList[index]}' : 'Prezzo non disponibile',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
                                  ),
                                ],
                              ),
                              CupertinoButton(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "Richiedi",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  )),
                                  height: 25,
                                  width: width * .2,
                                  decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      //enableDrag: false,
                                      isDismissible: false,
                                      builder: (context) => _bottomSheets(
                                            servizio: nomeServizioList[index],
                                            prezzo: prezzoServizioList[index],
                                            structure: widget.structure,
                                            nomeCognome: widget.nomeCognome,
                                          ),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)));
                                },
                                padding: EdgeInsets.zero,
                              )
                            ],
                          ),
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

class _bottomSheets extends StatefulWidget {
  final String nomeCognome;
  final String structure;
  final String servizio;
  final String prezzo;
  const _bottomSheets({Key? key, required this.servizio, required this.prezzo, required this.structure, required this.nomeCognome}) : super(key: key);

  @override
  State<_bottomSheets> createState() => _bottomSheetsState();
}

class _bottomSheetsState extends State<_bottomSheets> {
  void _showSnackBarRichiesta(BuildContext context) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      content: Row(
        children: [
          Text(
            'Grazie per la tua richiesta, a tra poco!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ),
      backgroundColor: Colors.blue,
      //Color.fromARGB(255, 35, 34, 34),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
     final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      height: height * .3,
      color: background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CupertinoButton(
                child: Text("Annulla"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: width * .12,
            ),
            
            Text(
              "Conferma richiesta",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,color: textColor),
            ),
            Spacer()
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              widget.servizio,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              'L\'host riceverà la richiesta e ti contatterà.\nPuoi annullare la richiesta semplicemente contattando l\'host',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              widget.prezzo != '' ? '€' + widget.prezzo : '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  child: Center(child: Text("Richiedi servizio", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
                  width: width,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  await FirebaseDatabase.instance.ref().child('structure/${widget.structure}/richiesteServizi/${widget.nomeCognome}').update({
                    'ospite': widget.nomeCognome,
                    'orders': {'servizio_richiesto': widget.servizio, 'prezzo': '€${widget.prezzo}'}
                  });
                  Navigator.pop(context);
                  _showSnackBarRichiesta(context);
                  HapticFeedback.lightImpact();
                }),
          )
        ],
      ),
    );
  }
}
