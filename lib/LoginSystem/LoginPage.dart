// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:near_me/LoginSystem/SignUp.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:near_me/data/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final number = "+393456046302";

  String campoVuoto = 'Devi inserire un codice struttura';
  String noStruttura = 'Questo codice non corrisponde a nessuna struttura';
  bool campoVuotoBool = false;
  bool noStrutturaoBool = false;

  final ref = FirebaseDatabase.instance.ref().child('structure');
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  List<String> uidList = [];
  List<String> nameList = [];
  String structureFromSheets = '';

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("structure");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String uid = values["uid"];
        String nomeStruttura = values["name"];
        uidList.add(uid);
        nameList.add(nomeStruttura);
      });
      //
      //  print(uidList);
      // stampa la lista degli uid
    });
  }

  _loading() {
    setState(() {
      loading = !loading;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loading = !loading;
      });
    });
  }

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController codiceStruttura;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    codiceStruttura = TextEditingController();
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    codiceStruttura.dispose();
    super.dispose();
  }

  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final Shader linearGradient = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 71, 160, 73),
        Color.fromARGB(255, 74, 201, 79),
      ],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    final backColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final placeholder = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.grey : Colors.grey;
    final textFieldColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87;
    final fieldColors = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 25, 25, 25) : Colors.white;
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: background, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.15, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Text(
              "NearMe",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 46, color: Color.fromARGB(255, 29, 134, 219)),
            ),
            SizedBox(height: 20),
            Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                            child: TextFormField(
                              controller: emailController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (email) =>
                                  email != null && !EmailValidator.validate(email) ? 'Inserisci una mail valida: example@google.com' : null,
                              //autocorrect: false,
                              style: TextStyle(color: textFieldColor),
                              keyboardAppearance: Brightness.dark,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Email', hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: placeholder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: Offset(0, 5),
                  blurRadius: 20,
                  spreadRadius: 0.7,
                )
              ], color: fieldColors, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            ),
            Divider(
              color: placeholder,
              height: 0.1,
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _passwordObscured,
                              //autocorrect: false,
                              style: TextStyle(color: textFieldColor),
                              keyboardAppearance: Brightness.dark,

                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordObscured ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordObscured = !_passwordObscured;
                                      });
                                    },
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: placeholder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: Offset(0, 5),
                  blurRadius: 20,
                  spreadRadius: 0.7,
                )
              ], color: fieldColors, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
            ),

            SizedBox(height: 15),
            CupertinoButton(
              child: Row(
                children: [
                  Text(
                    "Inserisci il Codice struttura",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 18,
                  )
                ],
              ),
              onPressed: () {
                print(nameList);
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  context: context,
                  builder: (BuildContext context) {
                    return OTPSheets(
                      nameL: nameList,
                      uidL: uidList,
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      structureFromSheets = value;
                    });
                  }
                });
                ;
              },
              padding: EdgeInsets.only(left: 10, bottom: 10),
            ),
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Text(
                'Codice struttura'.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Container(
                    width: width * 0.4,
                    child: CupertinoTextField(
                      onChanged: (value) {
                        int searchIndex = uidList.indexOf(value);
                        setState(() {
                          structure = nameList[searchIndex];
                        });
                      },
                      controller: codiceStruttura,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                      ],
                      style: TextStyle(
                        color: textFieldColor,
                        fontSize: 13,
                      ),
                      decoration: BoxDecoration(color: fieldColors, borderRadius: BorderRadius.circular(5)),
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.number,
                      //textInputAction: TextInputAction.done,
                      placeholder: 'Ex: 32435',
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: placeholder),
                    ),
                  ),
                  SizedBox(width: 10),
                  Visibility(
                      visible: loading == true ? true : false,
                      child: Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey,
                        ),
                        width: 10,
                        height: 10,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                noStrutturaoBool == true
                    ? noStruttura
                    : campoVuotoBool == true
                        ? campoVuoto
                        : '',
                style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),*/

            // ignore: sized_box_for_whitespace
            Container(
              width: double.infinity,
              height: 45,
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    String? token = await FirebaseMessaging.instance.getToken();
                    if (nameList.contains(structureFromSheets) && structureFromSheets!='<<<   ') {
                      setState(() {
                        campoVuotoBool = false;
                      });
                      _loading();
                      authService.signInWithEmailAndPassword(emailController.text, passwordController.text).then((value) => {
                            if (value != null)
                              {
                                Future.delayed(Duration(seconds: 1), () async {
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('users/${FirebaseAuth.instance.currentUser!.uid}/structureGuest')
                                      .update({'name': structureFromSheets});
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                      .update({'deviceTokens': token});
                                  HapticFeedback.lightImpact();
                                }),
                                 Navigator.pop(context)
                              }

                          });
                    }
                    if (codiceStruttura.text == '') {
                      setState(() {
                        campoVuotoBool = true;
                      });
                    }
                    if (!nameList.contains(structureFromSheets)) {
                      setState(() {
                        noStrutturaoBool = true;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(color: Color.fromARGB(255, 29, 134, 219), borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.accedi,
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Non sei registrato? ',
                  style: TextStyle(color: textColor),
                ),
                CupertinoButton(
                  child: Text(
                    "Crea un accout",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  padding: EdgeInsets.zero,
                ),
              ],
            ),

            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class OTPSheets extends StatefulWidget {
  final List<String> nameL;
  final List<String> uidL;

  OTPSheets({
    Key? key,
    required this.nameL,
    required this.uidL,
  }) : super(key: key) {}

  @override
  State<OTPSheets> createState() => _OTPSheetsState();
}

class _OTPSheetsState extends State<OTPSheets> {
  late TextEditingController unoC;
  late TextEditingController dueC;
  late TextEditingController treC;
  late TextEditingController quattroC;
  late TextEditingController cinqueC;
  late TextEditingController seiC;

  @override
  void initState() {
    unoC = TextEditingController();
    dueC = TextEditingController();
    treC = TextEditingController();
    quattroC = TextEditingController();
    cinqueC = TextEditingController();
    seiC = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    unoC.dispose();
    dueC.dispose();
    treC.dispose();
    quattroC.dispose();
    cinqueC.dispose();
    seiC.dispose();

    super.dispose();
  }

  String code = '';

  bool checkCode(String value) {
    RegExp regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(value) && !value.contains(' ') && !value.contains(RegExp(r'[a-zA-Z]'));
  }

  bool loading = false;

  _loading() {
    setState(() {
      loading = !loading;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loading = !loading;
      });
    });
  }

  String structure = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 29, 134, 219),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  width: 80,
                  height: 5,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                'Inserisci il Codice struttura',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Form(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 48,
                    width: 44,
                    child: TextFormField(
                      controller: unoC,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: Decorator('0'),
                      onSaved: (pin1) {},
                      onChanged: (value) {
                        setState(() {
                          code = '${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}';
                        });
                        HapticFeedback.selectionClick();

                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 44,
                    child: TextFormField(
                      controller: dueC,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: Decorator('0'),
                      onSaved: (pin1) {},
                      onChanged: (value) {
                        setState(() {
                          code = '${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}';
                        });
                        HapticFeedback.selectionClick();
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 44,
                    child: TextFormField(
                      controller: treC,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: Decorator('0'),
                      onSaved: (pin1) {},
                      onChanged: (value) {
                        setState(() {
                          code = '${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}';
                        });
                        HapticFeedback.selectionClick();
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 44,
                    child: TextFormField(
                      controller: quattroC,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: Decorator('0'),
                      onSaved: (pin1) {},
                      onChanged: (value) {
                        setState(() {
                          code = '${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}';
                        });
                        HapticFeedback.selectionClick();
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 44,
                    child: TextFormField(
                      controller: cinqueC,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: Decorator('0'),
                      onSaved: (pin1) {},
                      onChanged: (value) {
                        setState(() {
                          code = '${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}';
                        });
                        HapticFeedback.selectionClick();
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 44,
                    child: TextFormField(
                      controller: seiC,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                      decoration: Decorator('0'),
                      onSaved: (pin1) {},
                      onChanged: (value) {
                        setState(() {
                          code = '${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}';
                        });
                        HapticFeedback.selectionClick();
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              )),
            ),
            CupertinoButton(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Container(
                    width: width,
                    height: 40,
                    child: Center(
                        child: Text(
                      "Fatto",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  //print(widget.nameL);

                  int searchIndex = widget.uidL.indexOf(code);
                  setState(() {
                    structure = widget.nameL[searchIndex];
                  });
                  if (checkCode(code) == true && widget.nameL.contains(structure)) {
                    print(structure);
                    Navigator.pop(context, structure);
                  }
                })
          ],
        ),
      ),
    );
  }

  InputDecoration Decorator(String hint) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 18, color: Colors.black26, fontWeight: FontWeight.w600),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: Color.fromARGB(255, 116, 185, 241));
  }
}
