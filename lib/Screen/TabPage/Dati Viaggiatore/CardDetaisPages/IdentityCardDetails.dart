import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../DetailsView/core/utils/size_utils.dart';

class IdentityCardDetails extends StatefulWidget {
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

  const IdentityCardDetails(
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
  State<IdentityCardDetails> createState() => _IdentityCardDetailsState();
}

class _IdentityCardDetailsState extends State<IdentityCardDetails> {
  final ref = FirebaseDatabase.instance.ref();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  String inviato = '';
  @override
  void initState() {
    _getData('${widget.name} ${widget.cognome}');
    super.initState();
  }

  void _getData(String docName) async {
    final inviatoBool2 = await ref.child('users/$currentUser/documents/$docName/inviato').once();
    ;
    //print(inviatoBool2.snapshot.value.toString());
    if (inviatoBool2.snapshot.exists) {
      setState(() {
        inviato = inviatoBool2.snapshot.value.toString();
      });
    } else {
      print('No data available.');
    }
    print(inviato);
  }

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
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CupertinoTextField(
                          style: TextStyle(color: textColor),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214),
                              width: 0.7,
                            ),
                          ),
                          readOnly: true,
                          placeholder: widget.name,
                          placeholderStyle: TextStyle(color: textColor),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Cognome',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CupertinoTextField(
                          style: TextStyle(color: textColor),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214),
                              width: 0.7,
                            ),
                          ),
                          readOnly: true,
                          placeholder: widget.cognome,
                          placeholderStyle: TextStyle(color: textColor),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sesso',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.sess,
                                    style: TextStyle(color: textColor),
                                  ),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data di nascita',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.nascita,
                                    style: TextStyle(color: textColor),
                                  ),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Nazionalità',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                            width: width,
                            height: 35,
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Color.fromARGB(255, 214, 214, 214),
                                width: 0.7,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.naz,
                                style: TextStyle(color: textColor),
                              ),
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
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.tipoDoc,style: TextStyle(color: textColor),),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Numero documento',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CupertinoTextField(
                          style: TextStyle(color: textColor),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromARGB(255, 214, 214, 214),
                              width: 0.7,
                            ),
                          ),
                          readOnly: true,
                          placeholder: widget.nDoc,
                          placeholderStyle: TextStyle(color: textColor),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Paese',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.naz,style: TextStyle(color: textColor),),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data di emissione',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.emissioneDoc,style: TextStyle(color: textColor),),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Data di scadenza',
                        style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    width: 0.7,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.scadenza,style: TextStyle(color: textColor)),
                                ))),
                      ),
                      SizedBox(height: 20),
                      Visibility(
                          visible: inviato != 'true' ? false : true,
                          child: Text(
                            'I tuoi dati personali sono stati inviati all\'host, grazie!',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
                          )),
                      Visibility(
                        visible: inviato != 'true' ? true : false,
                        child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                              width: width,
                              height: 45,
                              child: Center(
                                  child: Text(
                                'Invia all\'host',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              )),
                            ),
                            onPressed: () async {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('structure/${widget.structure}/clienti/${widget.name} ${widget.cognome}')
                                  .update({
                                'name': widget.name,
                                'cognome': widget.cognome,
                                'paese': widget.paese,
                                'sess': widget.sess,
                                'naz': widget.naz,
                                'nascita': widget.nascita,
                                'scadenza': widget.scadenza,
                                'nDoc': widget.nDoc,
                                'emissioneDoc': widget.emissioneDoc,
                                'tipoDoc': widget.tipoDoc,
                              });
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('users/$currentUser/documents/${widget.name} ${widget.cognome}')
                                  .update({'inviato': true});
                              Future.delayed(Duration(seconds: 2), () {
                                _getData('${widget.name} ${widget.cognome}');
                                setState(() {});
                              });
                            }),
                      ),
                      SizedBox(height: height * 0.1),
                    ],
                  ))),
        ));
  }
}
