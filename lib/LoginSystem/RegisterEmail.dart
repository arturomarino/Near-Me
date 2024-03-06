import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:near_me/Screen/TabPage/Become%20Host/CreaStruttura.dart';
import 'package:near_me/Screen/TabPage/TabBar.dart';
import 'package:provider/provider.dart';
import '../Screen/DetailsView/core/utils/size_utils.dart';
import '../data/services/auth_service.dart';

class RegisterEmailPage extends StatefulWidget {
  final bool becomeHost;
  const RegisterEmailPage({Key? key, required this.becomeHost}) : super(key: key);

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController nome;
  late TextEditingController cognome;
  late PageController _pageController;

  late TextEditingController unoC;
  late TextEditingController dueC;
  late TextEditingController treC;
  late TextEditingController quattroC;
  late TextEditingController cinqueC;
  late TextEditingController seiC;

  String code = '';

  bool checkCode(String value) {
    RegExp regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(value) && !value.contains(' ') && !value.contains(RegExp(r'[a-zA-Z]'));
  }

  int _currentPage = 0;

  @override
  void initState() {
    unoC = TextEditingController();
    dueC = TextEditingController();
    treC = TextEditingController();
    quattroC = TextEditingController();
    cinqueC = TextEditingController();
    seiC = TextEditingController();

    email = TextEditingController();
    password = TextEditingController();
    nome = TextEditingController();
    cognome = TextEditingController();
    _pageController = PageController(initialPage: 0);
    _getData();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
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

    email.dispose();
    password.dispose();
    nome.dispose();
    cognome.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _passwordObscured = true;
  bool loading = false;
  bool campoVuotoBool = false;
  bool noStrutturaoBool = false;
  String campoVuoto = 'Devi inserire un codice struttura';
  String noStruttura = 'Questo codice non corrisponde a nessuna struttura';

  List<String> uidList = [];
  List<String> nameList = [];
  String structure = '';

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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textFieldColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87;
    final fieldColors = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 25, 25, 25) : Colors.white;
    final placeholder = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.grey : Colors.grey;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 29, 134, 219),
      appBar:widget.becomeHost==false? AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 29, 134, 219),
      ):null,
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('NearMe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white)),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: width,
                height: height * 0.25,
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                            controller: email,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            validator: (email) => email != null && !EmailValidator.validate(email)
                                                ? 'Inserisci una mail valida: example@google.com'
                                                : null,
                                            //autocorrect: false,
                                            style: TextStyle(color: Colors.black),
                                            keyboardAppearance: Brightness.dark,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration.collapsed(
                                                hintText: 'Email',
                                                hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey)),
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
                            ], color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                          ),
                          Divider(
                            color: Colors.grey,
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
                                            controller: password,
                                            obscureText: _passwordObscured,
                                            autocorrect: false,
                                            style: TextStyle(color: Colors.black),
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
                                                hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    offset: Offset(0, 5),
                                    blurRadius: 20,
                                    spreadRadius: 0.7,
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 45,
                            child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  if (email.text != '' && password.text != '') {
                                    //authService.signUpUser(email.text, password.text);
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    );
                                    /*authService.signInWithEmailAndPassword(email.text, password.text).then((value) => {
                                      if (value != null)
                                        {
                                          Future.delayed(Duration(seconds: 1), () async {
                                            /* await FirebaseDatabase.instance
                                          .ref()
                                          .child('users/${FirebaseAuth.instance.currentUser!.uid}/structureGuest')
                                          .update({'name': structure});*/
                                            HapticFeedback.lightImpact();
                                          })
                                        }
                                    });*/
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Registrati',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 29, 134, 219), fontSize: 15),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                            child: Text(
                              'nome'.toUpperCase(),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                            ),
                          ),
                          CupertinoTextField(
                            maxLines: 1,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            minLines: 1,
                            placeholder: 'Mario',
                            placeholderStyle: TextStyle(fontSize: 17, color: Colors.grey),
                            controller: nome,
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                            child: Text(
                              'cognome'.toUpperCase(),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                            ),
                          ),
                          CupertinoTextField(
                            maxLines: 1,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            minLines: 1,
                            placeholder: 'Rossi ',
                            placeholderStyle: TextStyle(fontSize: 17, color: Colors.grey),
                            controller: cognome,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: _currentPage == 1 ? true : false,
                                  child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                                      }),
                                ),
                                Spacer(),
                                Visibility(
                                    visible: _currentPage == 1 ? true : false,
                                    child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                            child: Text(
                                              'Avanti',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(255, 29, 134, 219),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (nome.text != '' && cognome.text != '') {
                                            _pageController.nextPage(
                                              duration: Duration(milliseconds: 200),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        }))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      child: Form(
                          child: Column(
                        children: [
                          Visibility(
                            visible: !widget.becomeHost,
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
                            ),
                          ),
                          Visibility(
                            visible: widget.becomeHost,
                            child: Text(
                              'Hai quasi finito! Adesso devi creare la tua struttura.',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: _currentPage == 2 ? true : false,
                                  child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        unoC.clear();
                                        dueC.clear();
                                        treC.clear();
                                        quattroC.clear();
                                        cinqueC.clear();
                                        seiC.clear();
                                        _pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                                      }),
                                ),
                                Visibility(
                                    visible: _currentPage == 2 ? true : false,
                                    child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                            child: Text(
                                              'Registrati',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(255, 29, 134, 219),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (widget.becomeHost == false) {
                                            int searchIndex = uidList.indexOf(code);
                                            setState(() {
                                              structure = nameList[searchIndex];
                                            });
                                            //CODE FOR REGISTER
                                            String? token = await FirebaseMessaging.instance.getToken();

                                            if (checkCode(code) == true && nameList.contains(structure)) {
                                              setState(() {
                                                campoVuotoBool = false;
                                              });
                                              _loading();
                                              print(structure);
                                            }
                                            if (!nameList.contains(structure)) {
                                              setState(() {
                                                noStrutturaoBool = true;
                                              });
                                            }
                                            if (nome.text != '' && cognome.text != '' && password != '') {
                                              authService.signUpUser(email.text, password.text).then((value) {
                                                if (value != null) {
                                                  Future.delayed(Duration(seconds: 1), () async {
                                                    await FirebaseDatabase.instance
                                                        .ref()
                                                        .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                                        .set({
                                                      'email': email.text.trim(),
                                                      'name': nome.text.trim(),
                                                      'surname': cognome.text.trim(),
                                                      'password': password.text.trim(),
                                                      'structureGuest': {'name': '$structure'},
                                                      'deviceTokens': token
                                                    });

                                                    HapticFeedback.lightImpact();
                                                  }).then((value) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => MyTabBar(
                                                                currentIndex: 0,
                                                                structure: '',
                                                              )),
                                                    );
                                                  });
                                                }
                                              });
                                            }
                                          } else {
                                            String? token = await FirebaseMessaging.instance.getToken();

                                            if (nome.text != '' && cognome.text != '' && password != '') {
                                              authService.signUpUser(email.text, password.text).then((value) {
                                                if (value != null) {
                                                  Future.delayed(Duration(seconds: 1), () async {
                                                    await FirebaseDatabase.instance
                                                        .ref()
                                                        .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                                        .set({
                                                      'email': email.text.trim(),
                                                      'name': nome.text.trim(),
                                                      'surname': cognome.text.trim(),
                                                      'password': password.text.trim(),
                                                      //'structureGuest': {'name': '$structure'},
                                                      'deviceTokens': token
                                                    });

                                                    HapticFeedback.lightImpact();
                                                  }).then((value) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => CreaStruttura(becomeHost: widget.becomeHost,)),
                                                    );
                                                  });
                                                }
                                              });
                                            }
                                          }
                                        })),
                                if (loading == true)
                                  SizedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                    width: 17,
                                    height: 17,
                                  )
                                else
                                  Container(
                                    height: 17,
                                    width: 17,
                                  )
                                /* Visibility(
                                    visible: loading == true ? true : false,
                                    child: SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                  width: 17,
                                  height: 17,
                                ))*/
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
