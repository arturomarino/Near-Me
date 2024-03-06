import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyFaq extends StatefulWidget {
  final String structure;
  const MyFaq({Key? key, required this.structure}) : super(key: key);

  @override
  State<MyFaq> createState() => _MyFaqState();
}

class _MyFaqState extends State<MyFaq> {
  @override
  Widget build(BuildContext context) {
     final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    final blueColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 6, 34, 58) : Color.fromARGB(255, 159, 204, 240);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        actions: [
          CupertinoButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddFaq(
                            structure: widget.structure,
                          )),
                );
              })
        ],
        elevation: 2,
        title: Text(
          "My Faq",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: background,
        foregroundColor: textColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: FirebaseDatabase.instance.ref().child('structure/${widget.structure}/faq'),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, snapshot, animation, index) {
                  Map data = snapshot.value as Map;
                  data['key'] = snapshot.key;
                  return GestureDetector(
                    onLongPress: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => CupertinoActionSheet(
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
                                    onPressed: () {
                                      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/faq').child(data['domanda']).remove();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Elimina',
                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ));
                    },
                    child: ExpansionTile(
                      backgroundColor: blueColor,
                      childrenPadding: EdgeInsets.all(15),
                      title: Text(
                        data['domanda'],
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                      ),
                      children: [Text(data['risposta'],style: TextStyle(color: textColor, fontWeight: FontWeight.w500),)],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class AddFaq extends StatefulWidget {
  final String structure;
  AddFaq({Key? key, required this.structure}) : super(key: key);

  @override
  State<AddFaq> createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  late TextEditingController domanda;

  late TextEditingController risposta;

    @override
  void initState() {
    domanda = TextEditingController();
    risposta = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    domanda.dispose();
    risposta.dispose();
    super.dispose();
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
              child: Text("Fatto"),
              onPressed: () async {
               if(domanda.text!=''&&risposta.text!=''){
                 await FirebaseDatabase.instance
                    .ref()
                    .child('structure/${this.widget.structure}/faq/${domanda.text}')
                    .update({'domanda': domanda.text, 'risposta': risposta.text});
                Navigator.pop(context);
               }
              })
        ],
        elevation: 2,
        title: Text(
          "Aggiungi Faq",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: background,
        foregroundColor: textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Inserisci una domanda'.toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
            ),
          ),
          CupertinoTextField(
            maxLines: 5,
            clearButtonMode: OverlayVisibilityMode.editing,
            minLines: 1,
            placeholder: 'Ex: Quali sono gli orari del check-in e del check-out? ',
            placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey),
            controller: domanda,
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Inserisci una risposta'.toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor2),
            ),
          ),
          CupertinoTextField(
            clearButtonMode: OverlayVisibilityMode.editing,
            maxLines: 5,
            minLines: 1,
            placeholder: 'Ex: Il check-in è dalle ore 14:00, mentre il check-out è entro le ore 12:00. ',
            placeholderStyle: TextStyle(fontSize: 14, color: Colors.grey),
            controller: risposta,
          )
        ]),
      ),
    );
  }
}
