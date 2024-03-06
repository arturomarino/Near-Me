import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart' as button;
import 'package:near_me/LoginSystem/AddNameForApple.dart';
import 'package:near_me/LoginSystem/LoginPage.dart';
import 'package:near_me/LoginSystem/RegisterEmail.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../Screen/TabPage/Become Host/BecomeAHost1.dart';
import '../Screen/TabPage/TabBar.dart';
import '../data/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController unoC;
  late TextEditingController dueC;
  late TextEditingController treC;
  late TextEditingController quattroC;
  late TextEditingController cinqueC;
  late TextEditingController seiC;



  late TextEditingController codiceStruttura;
  bool campoVuotoBool = false;
  bool noStrutturaoBool = false;
  String campoVuoto = 'Devi inserire un codice struttura';
  String noStruttura = 'Questo codice non corrisponde a nessuna struttura';

  List<String> uidList = [];
  List<String> nameList = [];
  bool loading = false;

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

  String structure = '';

  @override
  void initState() {
    unoC = TextEditingController();
    dueC = TextEditingController();
    treC = TextEditingController();
    quattroC = TextEditingController();
    cinqueC = TextEditingController();
    seiC = TextEditingController();

    _getData();
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

  String firstName1 = '';
  String lastName1 = '';
  String code = '';

  bool checkCode(String value) {
    RegExp regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(value) && !value.contains(' ') && !value.contains(RegExp(r'[a-zA-Z]'));
  }

  bool _host = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 29, 134, 219),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: height,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('NearMe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white)),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Vivi la tua vacanza come non hai mai fatto prima.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                          value: _host,
                          splashRadius: 1,
                          shape: CircleBorder(),
                          onChanged: (value) {
                            setState(() {
                              _host = value!;
                            });
                          }),
                      Text(
                        'Voglio diventare un host',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _host = !_host;
                    });
                  },
                ),
                SizedBox(height: height * 0.07),
                Visibility(
                  visible: !_host,
                  child: Column(
                    children: [
                      Text(
                        'Inserisci il Codice Struttura',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                    ],
                  ),
                ),
                Spacer(),
                CupertinoButton(
                  onPressed: () {
                    if (_host == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BecomeAHost1(
                                  fromLoginPage: true, host: _host,
                                ),
                            fullscreenDialog: true),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterEmailPage(
                                  becomeHost: _host,
                                ),
                            fullscreenDialog: true),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                      width: width,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Registrati con e-mail",
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54, fontSize: 15),
                          ),
                        ],
                      )),
                ),
                Visibility(
                    visible: !_host,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: width,
                            height: 40,
                            child: button.SignInButton(
                              button.Buttons.Google,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              onPressed: () async {
                                //print('OTP Code: ${unoC.text}${dueC.text}${treC.text}${quattroC.text}${cinqueC.text}${seiC.text}');
                                //print(code);
                                int searchIndex = uidList.indexOf(code);
                                setState(() {
                                  structure = nameList[searchIndex];
                                });
                                String? token = await FirebaseMessaging.instance.getToken();
                                if (checkCode(code) == true && nameList.contains(structure)) {
                                  print('true');
                                  setState(() {
                                    campoVuotoBool = false;
                                  });
                                  _loading();
                                  AuthService().signInWithGoogle().then((value) => {
                                        if (value != null)
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyTabBar(
                                                        currentIndex: 0,
                                                        structure: '',
                                                      )),
                                            ),
                                            Navigator.pop(context),
                                            Future.delayed(Duration(seconds: 1), () async {
                                              User? user = FirebaseAuth.instance.currentUser;

                                              if (user != null) {
                                                String? displayName = user.displayName;
                                                List<String> nameParts = displayName!.split(" ");
                                                /*setState(() {
                                           firstName1 = nameParts[0];  
                                           lastName1 = nameParts[1];
                                          });*/
                                                String firstName1 = nameParts[0];
                                                String lastName1 = nameParts[1];

                                                await FirebaseDatabase.instance
                                                    .ref()
                                                    .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                                    .update({
                                                  'name': firstName1,
                                                  'surname': lastName1,
                                                });

                                                // print("First name: $firstName1");
                                                // print("Last name: $lastName1");
                                              }

                                              await FirebaseDatabase.instance
                                                  .ref()
                                                  .child('users/${FirebaseAuth.instance.currentUser!.uid}/structureGuest')
                                                  .update({'name': structure});

                                              await FirebaseDatabase.instance
                                                  .ref()
                                                  .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                                  .update({'deviceTokens': token, 'email': '${user!.email?.trim().toString()}'});

                                              HapticFeedback.selectionClick();
                                            })
                                          }
                                      });
                                }
                                if (code == '') {
                                  setState(() {
                                    campoVuotoBool = true;
                                  });
                                }
                                if (!nameList.contains(code)) {
                                  setState(() {
                                    noStrutturaoBool = true;
                                  });
                                }
                              },
                              //onPressed: _isLoading ? null : () => _registerWithApple(context),
                              text: 'Accedi con Google',
                            ),
                          ),
                        ),
                        Visibility(
                          visible: Platform.isIOS,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            child: SignInWithAppleButton(
                              onPressed: () async {
                                print(code);
                                int searchIndex = uidList.indexOf(code);
                                setState(() {
                                  structure = nameList[searchIndex];
                                });
                                String? token = await FirebaseMessaging.instance.getToken();
                                if (checkCode(code) == true && nameList.contains(structure)) {
                                  print('true');
                                  setState(() {
                                    campoVuotoBool = false;
                                  });
                                  _loading();

                                  AuthService().signInWithApple(context).then((value) => {
                                       /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddNameForApple(
                                                    structure: structure,
                                                    email: FirebaseAuth.instance.currentUser!.email.toString(),
                                                  ),
                                              fullscreenDialog: true),
                                        ),*/
                                        if (value != null)
                                          {
                                            Future.delayed(Duration(seconds: 2), () async {
                                              Navigator.pop(context);
                                              User? user = FirebaseAuth.instance.currentUser;

                                              if (user != null) {
                                                String? displayName = user.displayName;
                                                List<String> nameParts = displayName!.split(" ");
                                                /*setState(() {
                                           firstName1 = nameParts[0];  
                                           lastName1 = nameParts[1];
                                          });*/
                                                String firstName1 = nameParts[0];
                                                String lastName1 = nameParts[1];

                                                await FirebaseDatabase.instance
                                                    .ref()
                                                    .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                                    .update({
                                                  'name': firstName1,
                                                  'surname': lastName1,
                                                });

                                                // print("First name: $firstName1");
                                                // print("Last name: $lastName1");
                                              }

                                              await FirebaseDatabase.instance
                                                  .ref()
                                                  .child('users/${FirebaseAuth.instance.currentUser!.uid}/structureGuest')
                                                  .update({'name': structure});

                                              await FirebaseDatabase.instance
                                                  .ref()
                                                  .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                                                  .update({'deviceTokens': token, 'email': '${user!.email?.trim().toString()}'});

                                              HapticFeedback.selectionClick();
                                            })
                                          }
                                      });
                                }
                                if (code == '') {
                                  setState(() {
                                    campoVuotoBool = true;
                                  });
                                }
                                if (!nameList.contains(code)) {
                                  setState(() {
                                    noStrutturaoBool = true;
                                  });
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    )),
                CupertinoButton(
                    child: RichText(
                      text: TextSpan(
                        text: 'Sei già registrato? ',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Accedi',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true),
                      );
                    }),
                SizedBox(height: 20)

                /*SizedBox(height: 20),
                  Container(
                    width: width * 0.6,
                    height: 40,
                    child: SignInButton(
                      Buttons.AppleDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: () {},
                      //onPressed: _isLoading ? null : () => _registerWithApple(context),
                      text: 'Registrati con Apple',
                    ),
                  )*/
              ],
            ),
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
/* TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CupertinoButton(child: Text('Sign Up'), onPressed: () {} //_isLoading ? null : () => _registerWithEmail(context),
                  ),*/
              /*GoogleSignInButton(
                onPressed: _isLoading ? null : () => _registerWithGoogle(context),
                darkMode: true,
                borderRadius: 8.0,
                text: 'Sign Up with Google',
              ),
              SizedBox(height: 16.0),
              SignInButton(
                Buttons.Apple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                onPressed: () {},
                //onPressed: _isLoading ? null : () => _registerWithApple(context),
                text: 'Sign Up with Apple',*/
