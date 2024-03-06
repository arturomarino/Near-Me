import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../DetailsView/core/utils/size_utils.dart';
import '../Dati Viaggiatore/CardDetaisPages/IdCardDetailHost.dart';
import '../Dati Viaggiatore/CardDetaisPages/IdentityCardDetails.dart';

class DocListPage extends StatefulWidget {
  final String structure;
  const DocListPage({Key? key, required this.structure}) : super(key: key);

  @override
  State<DocListPage> createState() => _DocListPageState();
}

class _DocListPageState extends State<DocListPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: true);
    _getData();
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

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/iChiani/clienti");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String nome = values["name"];
        String cognome = values["cognome"];
        String paese = values["paese"];
        String sesso = values["sess"];
        String nazionalita = values["naz"];
        String nascita = values["nascita"];
        String scadenza = values["scadenza"];
        String nDoc = values["nDoc"];
        String emissioneDoc = values["emissioneDoc"];
        String tipoDoc = values["tipoDoc"];

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
    final bar_e_text = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColorDark,
      ),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          foregroundColor: bar_e_text,
          backgroundColor: background,
          //backgroundColor: Colors.transparent,
          elevation: 0,
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
                        'I tuoi clienti',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: textColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 2,
                  color: textColor2,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    itemCount: nameList.length,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 2,
                        color: textColor2,
                      );
                    },
                    itemBuilder: (context, index) {
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IdCardDetailHost(
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
                      );
                    }),
                Divider(
                  height: 2,
                  color: textColor2,
                ),
              ],
            ),
          ),
        ),
      )),
      ),
    );
  }
}
