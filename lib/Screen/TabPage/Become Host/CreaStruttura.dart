import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/TabPage/Become%20Host/StrutturaCreata.dart';
import 'package:near_me/Screen/TabPage/Setting/AdminListPage.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

import '../../DetailsView/core/utils/size_utils.dart';

class CreaStruttura extends StatefulWidget {
  final bool becomeHost;
   CreaStruttura({Key? key, required this.becomeHost}) : super(key: key);

  @override
  State<CreaStruttura> createState() => _CreaStrutturaState();
}

class _CreaStrutturaState extends State<CreaStruttura> {
  String typeStructure = 'Casa';
  String newUid = '';

  bool loading = false;
  bool servizi = true;
  bool addServizio = false;
  late TextEditingController _nameController;
  late TextEditingController _nameServizioController;
  late TextEditingController _prezzoServizioController;
  late TextEditingController _domandaController;
  late TextEditingController _rispostaController;
  late TextEditingController _wifiNameController;
  late TextEditingController _wifiPasswController;

  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  List<String> type = ['Casa', 'Villa', 'Appartamento', 'Fienile', 'B&B', 'Baita', 'Casa Particular', 'Castello', 'Hotel', 'Trullo', 'Mulino'];

  List<String> uidList = [];

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("structure");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String uid = values["uid"];
        uidList.add(uid);
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      _newUid();
    });
  }

  String generateUniqueUid(List<String> uidList) {
    int uidInt;
    String uid;
    do {
      // Genera un UID casuale di 6 cifre
      uidInt = Random().nextInt(900000) + 100000;
      uid = uidInt.toString();
      // Verifica che l'UID generato non sia presente nella lista esistente
    } while (uidList.contains(uid));

    return uid;
  }

  void _newUid() {
    setState(() {
      newUid = generateUniqueUid(uidList);
    });
    print('nuovo id:$newUid');
  }

  _loading() {
    setState(() {
      loading = !loading;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = !loading;
      });
    });
  }

  @override
  void initState() {
    _getData();
    _getName();
    _nameController = TextEditingController();
    _nameServizioController = TextEditingController();
    _prezzoServizioController = TextEditingController();
    _domandaController = TextEditingController();
    _rispostaController = TextEditingController();
    _wifiNameController = TextEditingController();
    _wifiPasswController = TextEditingController();
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameServizioController.dispose();
    _prezzoServizioController.dispose();
    _domandaController.dispose();
    _rispostaController.dispose();
    _wifiNameController.dispose();
    _wifiPasswController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  String name = '';
  String surname = '';

  void _getName() async {
    final name2 = await ref.child('users/${FirebaseAuth.instance.currentUser!.uid}/name').get();
    final surname2 = await ref.child('users/${FirebaseAuth.instance.currentUser!.uid}/surname').get();

    if (name2.exists && surname2.exists) {
      setState(() {
        name = name2.value.toString();
        surname = surname2.value.toString();
      });
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 48, 48, 48) : Colors.white;
    return Scaffold(
        backgroundColor: background,
        appBar:widget.becomeHost==false? AppBar(
          foregroundColor: textColor,
          elevation: 0,
          backgroundColor: background,
        ):null,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    SizedBox(
                      height:widget.becomeHost==false? height * 0.02:height * 0.18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Registra una\nnuova struttura',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 29, 134, 219), fontSize: 42)),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Container(
                      height: height,
                      width: width,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          Page1(),
                          Page2(),
                          Page3(),
                          Page4(),
                          Page5(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: 100,
                    width: width,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 25, right: 15),
                      child: Row(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                            },
                            child: Text(
                              'Indietro',
                              style: TextStyle(decoration: TextDecoration.underline, color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          CupertinoButton(
                            onPressed: () async {
                              _loading();
                              HapticFeedback.lightImpact();
                              FocusScope.of(context).nextFocus();
                              if (_pageController.page == 1) {
                                _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                                await FirebaseDatabase.instance
                                    .ref()
                                    .child('structure/${_nameController.text.trim()}')
                                    .update({'type': typeStructure});
                              }
                              if (_pageController.page == 2) {
                                if (servizi == false) {
                                  _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                                }
                                if (servizi == true && addServizio == true && _nameServizioController.text != '') {
                                  _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${_nameController.text.trim()}/servizi/${_nameServizioController.text.trim()}')
                                      .update(
                                          {'nome_servizio': _nameServizioController.text.trim(), 'prezzo': _prezzoServizioController.text.trim()});
                                }
                              }

                              if (_pageController.page == 3 && _formKey2.currentState!.validate()) {
                                if (_domandaController.text != '' && _rispostaController.text != '') {
                                  _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${_nameController.text.trim()}/faq/${_domandaController.text.trim()}')
                                      .update({'domanda': _domandaController.text.trim(), 'risposta': _rispostaController.text.trim()});
                                }
                              }
                              if (_pageController.page == 4 && _formKey3.currentState!.validate()) {
                                if (_wifiNameController.text != '' && _wifiPasswController.text != '') {
                                  _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${_nameController.text.trim()}/wifi')
                                      .update({'nome': _wifiNameController.text.trim(), 'password': _wifiPasswController.text.trim()});
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${_nameController.text.trim()}/IdMembers/${FirebaseAuth.instance.currentUser!.uid}')
                                      .update({'id': '${FirebaseAuth.instance.currentUser!.uid}', 'name': '$name $surname'});
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${_nameController.text.trim()}/members')
                                      .update({'001': true, '${FirebaseAuth.instance.currentUser!.uid}': true});
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StrutturaCreata(
                                              structure: _nameController.text.trim(),
                                            ),
                                        fullscreenDialog: true),
                                  );
                                }
                              }
                              if (_formKey.currentState!.validate()) {
                                _pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                                await FirebaseDatabase.instance
                                    .ref()
                                    .child('structure/${_nameController.text.trim()}')
                                    .update({'name': _nameController.text.trim(), 'uid': newUid});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                              height: 40,
                              width: 110,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                child: loading == true
                                    ? Center(
                                        child: SizedBox(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                        height: 15,
                                        width: 15,
                                      ))
                                    : Center(
                                        child: Text(
                                        'Avanti',
                                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                                      )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )
          ],
        ));
  }

  Column Page3() {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    return Column(
      children: [
        Text('Offri dei servizi presso il tuo alloggio?', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 19)),
        SizedBox(height: 5),
        Row(
          children: [
            CupertinoButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  servizi = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: servizi == true ? Colors.blue : Colors.white),
                height: 40,
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Center(
                      child: Text(
                    'Si',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            ),
            CupertinoButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  servizi = false;
                  addServizio = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: servizi == false ? Colors.blue : Colors.white),
                height: 40,
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Center(
                      child: Text(
                    'No',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: servizi,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                addServizio = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.8,
                  ),
                ),
                width: width,
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Crea un servizio e continua in seguito',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: addServizio == true && servizi == true ? true : false,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == '') {
                return 'Inserisci un nome valido';
              }
              return null;
            },
            cursorColor: Colors.black,
            controller: _nameServizioController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Nome del servizio',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: addServizio == true && servizi == true ? true : false,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              double number = double.parse(_prezzoServizioController.text.replaceAll(',', '.'));
              String prezzo = NumberFormat("#,##0.00", "it_IT").format(number);
              // print(prezzo);
            },
            cursorColor: Colors.black,
            controller: _prezzoServizioController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefix: Text('€ '),
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Prezzo del servizio (opzionale)',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }

  Form Page4() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aiuta i tuoi clienti con delle domande frequenti', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 19)),
          SizedBox(height: 5),
          Text('Aggiungi una domanda frequente e continua in seguito',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black38, fontSize: 13)),
          SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == '') {
                return 'Inserisci una domanda valida';
              }
              return null;
            },
            cursorColor: Colors.black,
            controller: _domandaController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Domanda',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == '') {
                return 'Inserisci una risposta valida';
              }
              return null;
            },
            cursorColor: Colors.black,
            controller: _rispostaController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Risposta',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form Page5() {
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Facilita la connettività ai tuoi ospiti', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 19)),
          SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == '') {
                return 'Inserisci un nome valida';
              }
              return null;
            },
            cursorColor: Colors.black,
            controller: _wifiNameController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Nome WiFi',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == '') {
                return 'Inserisci una password valida';
              }
              return null;
            },
            cursorColor: Colors.black,
            controller: _wifiPasswController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Password',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form Page1() {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Come si chiama il tuo alloggio?', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 19)),
          SizedBox(height: 25),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == '') {
                return 'Inserisci un nome valido';
              }
              return null;
            },
            cursorColor: textColor,
            controller: _nameController,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              labelText: 'Nome',
              contentPadding: EdgeInsets.only(bottom: 8.0),
              labelStyle: TextStyle(color: textColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column Page2() {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 83, 83, 83) : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Che tipo di alloggio possiedi?', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 19)),
        SizedBox(height: 10),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: type.length,
            itemBuilder: (context, index) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    typeStructure = type[index];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: typeStructure == type[index] ? Colors.blue : buttonColor,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.8,
                      ),
                    ),
                    width: width,
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            type[index],
                            style:
                                TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: typeStructure == type[index] ? Colors.white : textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }
}
