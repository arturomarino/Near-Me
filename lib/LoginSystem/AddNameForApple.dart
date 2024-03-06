import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../Screen/TabPage/TabBar.dart';

class AddNameForApple extends StatefulWidget {
  final String structure;
  final String email;
  const AddNameForApple({Key? key, required this.structure, required this.email}) : super(key: key);

  @override
  State<AddNameForApple> createState() => _AddNameForAppleState();
}

class _AddNameForAppleState extends State<AddNameForApple> {
  late TextEditingController nameC;
  late TextEditingController surnameC;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameC = TextEditingController();
    surnameC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    surnameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Color.fromARGB(255, 29, 134, 219),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.xmark),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
        ),
        actions: [
          CupertinoButton(
              child: Text(
                'Fatto',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (nameC.text != '' && surnameC.text != '') {
                    await FirebaseDatabase.instance.ref().child('users/${FirebaseAuth.instance.currentUser!.uid}').update({
                      'name': nameC.text.trim(),
                      'surname': surnameC.text.trim(),
                    });
                    await FirebaseDatabase.instance
                        .ref()
                        .child('users/${FirebaseAuth.instance.currentUser!.uid}/structureGuest')
                        .update({'name': widget.structure});
                    String? token = await FirebaseMessaging.instance.getToken();
                    await FirebaseDatabase.instance
                        .ref()
                        .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                        .update({'deviceTokens': token, 'email': '${widget.email}'}).then((value) {
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
                }
              })
        ],
        title: Text(
          'Benvenuto 👋🏼',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 29, 134, 219),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == '') {
                    return 'Inserisci un nome valido';
                  }
                  return null;
                },
                cursorColor: Colors.white,
                controller: nameC,
                style: TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.yellow),
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == '') {
                    return 'Inserisci un cognome valido';
                  }
                  return null;
                },
                cursorColor: Colors.white,
                controller: surnameC,
                style: TextStyle(fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.yellow),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  labelText: 'Cognome',
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
