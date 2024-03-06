import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_me/Screen/TabPage/TabBar.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

class StrutturaCreata extends StatefulWidget {
  final String structure;
  const StrutturaCreata({Key? key, required this.structure}) : super(key: key);

  @override
  State<StrutturaCreata> createState() => _StrutturaCreataState();
}

class _StrutturaCreataState extends State<StrutturaCreata> {
  List<String> uidList = [];
  List<String> nameList = [];

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String uid = values["uid"];
        String nomeStruttura = values["name"];
        uidList.add(uid);
        nameList.add(nomeStruttura);
      });
      // print(nameList);
      //  print(uidList);
      // stampa la lista degli uid
    });
  }

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 70),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Nuova struttura\ncreata!',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 29, 134, 219), fontSize: 40)),
                ],
              ),
              Spacer(),
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: width,
                    height: 40,
                    child: Center(
                        child: Text(
                      "Continua",
                      style: TextStyle(color: Colors.white),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 29, 134, 219),
                    ),
                  ),
                  onPressed: () {
                    Future.delayed(Duration(seconds: 1), () async {
                      await FirebaseDatabase.instance.ref().child('users/${FirebaseAuth.instance.currentUser!.uid}').update({
                        'structureGuest': {'name': '${widget.structure}'},
                      });

                      HapticFeedback.lightImpact();
                    }).then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTabBar(
                                  currentIndex: 0,
                                  structure: '',
                                )),
                      );
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
