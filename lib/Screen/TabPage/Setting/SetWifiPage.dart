import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetWifiPage extends StatefulWidget {
  final String structure;
  final String nameWifi;
  final String passWifi;
  const SetWifiPage({Key? key, required this.structure, required this.nameWifi, required this.passWifi}) : super(key: key);

  @override
  State<SetWifiPage> createState() => _SetWifiPageState();
}

class _SetWifiPageState extends State<SetWifiPage> {
  late TextEditingController nomeWifi;
  late TextEditingController password;

  String nameWifiData = '';
  String passwordWifiData = '';

  @override
  void initState() {
    nomeWifi = TextEditingController(text: widget.nameWifi);
    password = TextEditingController(text: widget.passWifi);
    super.initState();
  }

  @override
  void dispose() {
    nomeWifi.dispose();
    password.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        foregroundColor: textColor,
        backgroundColor: background,
        elevation: 0,
        actions: [
          CupertinoButton(
              child: Text("Salva"),
              onPressed: () async {
                if (nomeWifi.text != '' && password.text != '') {
                  await FirebaseDatabase.instance
                      .ref()
                      .child('structure/${widget.structure}/wifi')
                      .update({'nome': nomeWifi.text, 'password': password.text});
                  Navigator.pop(context);
                }
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Inserisci il nome del Wifi'.toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
            ),
          ),
          CupertinoTextField(
            maxLines: 5,
            clearButtonMode: OverlayVisibilityMode.editing,
            minLines: 1,
            placeholder: '\"iChiani-WiFi\" ',
            placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey),
            controller: nomeWifi,
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Inserisci una password'.toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
            ),
          ),
          CupertinoTextField(
            clearButtonMode: OverlayVisibilityMode.editing,
            maxLines: 5,
            minLines: 1,
            autocorrect: false,
            placeholder: '\"magiruma\" ',
            placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey),
            controller: password,
          )
        ]),
      ),
    );
  }
}
