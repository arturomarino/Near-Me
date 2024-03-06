import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../DetailsView/core/utils/size_utils.dart';


class IdCardDetailHost extends StatefulWidget {
  final String structure;
  final String name;
  final String cognome;
  final String paese;
  final String sess;
  final String naz;
  final String nascita;
  final String scadenza;
  final String nDoc;
  final String emissioneDoc;
  final String tipoDoc;

  const IdCardDetailHost(
      {Key? key,
      required this.name,
      required this.cognome,
      required this.paese,
      required this.sess,
      required this.naz,
      required this.nascita,
      required this.scadenza,
      required this.nDoc,
      required this.emissioneDoc,
      required this.tipoDoc,
      required this.structure})
      : super(key: key);

  @override
  State<IdCardDetailHost> createState() => _IdCardDetailHostState();
}

class _IdCardDetailHostState extends State<IdCardDetailHost> {

  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;
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
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              bottom: false,
              child: Padding(
                  padding: const EdgeInsets.only(top: 25, left: 20, bottom: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dati personali',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 29, 134, 219)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nome',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CupertinoTextField(
                          readOnly: true,
                          placeholder: widget.name,
                          placeholderStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Cognome',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CupertinoTextField(
                          readOnly: true,
                          placeholder: widget.cognome,
                          placeholderStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sesso',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.sess),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data di nascita',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.nascita),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nazionalità',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                            width: width,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Color.fromARGB(255, 214, 214, 214),
                                width: 0.7,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.naz),
                            )),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        height: 20,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Il documento di viaggio',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 29, 134, 219)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Tipo di documento',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.tipoDoc),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Numero documento',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CupertinoTextField(
                          readOnly: true,
                          placeholder: widget.nDoc,
                          placeholderStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Paese',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.naz),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data di emissione',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.emissioneDoc),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data di scadenza',
                        style: TextStyle(fontWeight: FontWeight.w700,color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.scadenza),
                                ))),
                      ),
                      SizedBox(height: height * 0.1),
                    ],
                  ))),
        ));
  }
}

