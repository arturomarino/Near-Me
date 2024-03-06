import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

import '../../Theme.dart';

class AdminListPage extends StatefulWidget {
  final DatabaseReference ref;
  final String structure;
  const AdminListPage({Key? key, required this.ref, required this.structure}) : super(key: key);

  @override
  State<AdminListPage> createState() => AdminListPageState();
}

final ref = FirebaseDatabase.instance.ref();

class AdminListPageState extends State<AdminListPage> {
  List adminsSnapshot = [];
  List admins = [];
  List<String> uidList = [];
  List<String> nameList = [];
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String uid = values["id"].toString();
        String nomeUtente = values["name"].toString();
        uidList.add(uid);
        nameList.add(nomeUtente);
      });
      //print(nameList); // stampa la lista degli uid
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
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
          actions: [
            CupertinoButton(
                child: Icon(
                  Icons.add,
                  size: 28,
                ),
                onPressed: () async {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      //enableDrag: false,
                      isDismissible: false,
                      builder: (context) => AddUser(
                            structure: widget.structure,
                          ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)));
                })
          ],
          title: Text('Membri', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19)),
          elevation: 0,
          backgroundColor: background,
          foregroundColor: textColor),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Container(
            decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
            child: FirebaseAnimatedList(
                query: widget.ref,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, snapshot, animation, index) {
                  Map data = snapshot.value as Map;
                  data['key'] = snapshot.key;
                  return Column(
                    children: [
                      CupertinoButton(
                        pressedOpacity: 0.1,
                        padding: EdgeInsets.zero,
                        onPressed: () {

                          if(data['id'] != currentUser){
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CupertinoTheme(
                                    data: MediaQuery.of(context).platformBrightness == Brightness.dark
                                        ? MyThemeDark.darkTheme
                                        : MyThemeLight.lightTheme,
                                    child: CupertinoActionSheet(
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.annulla,
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      message: Text(data['name']),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            await FirebaseDatabase.instance
                                                .ref()
                                                .child('structure/${widget.structure}/members/${data['id']}')
                                                .remove();

                                            await FirebaseDatabase.instance
                                                .ref()
                                                .child('structure/${widget.structure}/IdMembers/${data['id']}')
                                                .remove();
                                            HapticFeedback.lightImpact();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Remove from structure',
                                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                          }
                          
                        },
                        child: Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                              child: Row(
                                children: [
                                  Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(150),
                                      child: Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[500],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.person_fill,
                                            color: Colors.white,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: (Colors.grey[500])!,
                                          width: 3.0,
                                        ),
                                      ),
                                      child: SizedBox(),
                                    ),
                                  ]),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      data['id'] == currentUser ? 'Tu' : data['name'],
                                      maxLines: 1,
                                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
                                    ),
                                  ),
                                  Spacer(),
                                  Visibility(
                                    visible:data['id'] == currentUser ? false : true ,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Icon(
                                        CupertinoIcons.chevron_right,
                                        color: Colors.grey,
                                        size: 17,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Divider(
                          height: 1,
                        ),
                      )
                    ],
                  );
                  /*return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 34,
                      color: textColor,
                    ),
                    title: Text(
                      data['name'],
                      style: TextStyle(fontWeight: FontWeight.w400,color: textColor),
                    ),
                    subtitle: Text(
                       data['id'] == currentUser ? 'Sei tu' : '',
                      style: TextStyle(fontWeight: FontWeight.w400,color: textColor),
                    ),
                    onTap: () {},
                  ),
                ],
              );*/
                }),
          ),
        ),
        CupertinoButton(
            child: Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Text(
                  "Abbandona struttura",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                ))),
            onPressed: () async {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoTheme(
                        data: MediaQuery.of(context).platformBrightness == Brightness.dark ? MyThemeDark.darkTheme : MyThemeLight.lightTheme,
                        child: CupertinoActionSheet(
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.annulla,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                await FirebaseDatabase.instance.ref().child('structure/${widget.structure}/members/$currentUser').remove();

                                await FirebaseDatabase.instance.ref().child('structure/${widget.structure}/IdMembers/$currentUser').remove();
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.abbandona,
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ));
            })
      ]),
    );
  }
}

class AddUser extends StatefulWidget {
  final String structure;
  const AddUser({Key? key, required this.structure}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late TextEditingController usernameController;
  final _focusNode = FocusNode();
  bool loading = false;
  String name = '';
  String surname = '';
  bool errorUidBool = false;
  String errorUidText = 'Utente non esistente o errato';

  showLoading(BuildContext context) {
    _focusNode.unfocus();
    setState(() {
      loading = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  void showSnackBarAdd(BuildContext context) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      content: Row(
        children: [
          Text(
            '$name $surname aggiunto alla struttura',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          )
        ],
      ),
      backgroundColor: Colors.blue,
      //Color.fromARGB(255, 35, 34, 34),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _getData() async {
    final name2 = await ref.child('users/${usernameController.text.trim()}/name').get();
    final surname2 = await ref.child('users/${usernameController.text.trim()}/surname').get();

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
    final textFieldColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87;
    final placeholder = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.grey : Colors.grey;
    String currentUser = FirebaseAuth.instance.currentUser!.uid;

    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      color: buttonColor,
      height: height * .95,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CupertinoButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Text(
              "Aggiungi membro",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textColor),
            ),
            CupertinoButton(
                child: loading == true
                    ? CupertinoActivityIndicator(
                        color: textColor,
                      )
                    : Text("Cerca", style: TextStyle(fontWeight: FontWeight.w500, color: usernameController.text == '' ? Colors.grey : Colors.blue)),
                onPressed: () {
                  if (usernameController.text != "") {
                    _getData();
                    showLoading(context);
                    print('nome: $name');
                    print('cognome: $surname');

                    /* Future.delayed(Duration(seconds: 3), () async {
                      if (name != '' && surname != '') {
                        print('nome: $name');
                        print('cognome: $surname');
                        await FirebaseDatabase.instance
                            .ref()
                            .child('structure/${widget.structure}/members')
                            .update({'${usernameController.text.trim()}': true});
                        await FirebaseDatabase.instance
                            .ref()
                            .child('structure/${widget.structure}/IdMembers/${usernameController.text.trim()}')
                            .update({'id': '${usernameController.text.trim()}', 'name': '$name $surname'}).then((value) => showSnackBarAdd(context));
                        //await FirebaseDatabase.instance.ref().child('users/${usernameController.text.trim()}').update({'host': true});
                      }
                    });*/
                  }
                })
          ]),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                height: 40,
                width: width,
                child: CupertinoSearchTextField(
                  controller: usernameController,
                  focusNode: _focusNode,
                  //autocorrect: false,
                  style: TextStyle(color: textFieldColor),
                  keyboardType: TextInputType.text,
                  placeholderStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 17, color: placeholder),
                  placeholder: 'Inserisci ID utente',
                  padding: EdgeInsets.zero,
                ),
              )),
          Visibility(
            visible: errorUidBool,
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                errorUidBool == true ? errorUidText : '',
                style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Divider(
            height: 2,
            thickness: 1,
          ),
          Visibility(
            visible: name != '' ? true : false,
            child: Column(
              children: [
                Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                      child: Row(
                        children: [
                          Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[500],
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.person_fill,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: (Colors.grey[500])!,
                                  width: 3.0,
                                ),
                              ),
                              child: SizedBox(),
                            ),
                          ]),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              name + ' ' + surname,
                              maxLines: 1,
                              style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                          Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showLoading(context);
                              Future.delayed(Duration(seconds: 3), () async {
                                if (name != '' && surname != '') {
                                  
                                  print('nome: $name');
                                  print('cognome: $surname');
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${widget.structure}/members')
                                      .update({'${usernameController.text.trim()}': true});
                                  await FirebaseDatabase.instance
                                      .ref()
                                      .child('structure/${widget.structure}/IdMembers/${usernameController.text.trim()}')
                                      .update({'id': '${usernameController.text.trim()}', 'name': '$name $surname'}).then(
                                          (value) => showSnackBarAdd(context));
                                  //await FirebaseDatabase.instance.ref().child('users/${usernameController.text.trim()}').update({'host': true});
                                }
                                usernameController.clear();
                                setState(() {
                                  name = '';
                                  surname = '';
                                });
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: loading == true
                                    ? CupertinoActivityIndicator(
                                        color: textColor,
                                      )
                                    : Text("Aggiungi")),
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Divider(
                    height: 1,
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
