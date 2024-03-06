import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:translator/translator.dart';

class FaqPage extends StatefulWidget {
  final String structure;
  const FaqPage({Key? key, required this.structure}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<String> domandeList = [];
  List<String> risposteList = [];

  List<String?> domandeListTranslated = [];
  List<String?> risposteListTranslated = [];

  GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    _getData();
    // _translate();
    super.initState();
  }

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/faq");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String domanda = values["domanda"];
        String risposta = values["risposta"];
         translator.translate(domanda, to: Localizations.localeOf(context).languageCode).then((value) {
          domandeList.add(value.toString());
        });
         translator.translate(risposta, to: Localizations.localeOf(context).languageCode).then((value) {
          risposteList.add(value.toString());
        });
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  /*FlMlKitTranslateText translateText = FlMlKitTranslateText();
  Translator translator = Translator(from: ITALIAN, to: ENGLISH);

  void _translate() async {
    for (int i = 0; i < domandeList.length; i++) {
      String? domanda = await translateText.translate('ciao');
      //domandeListTranslated.add(domanda);

      print(domanda);
    }
    print('lista: $domandeListTranslated');
  }*/

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    final blueColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 6, 34, 58) : Color.fromARGB(255, 159, 204, 240);

    return Scrollbar(
      child: Scaffold(
        backgroundColor: background,
          body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            elevation: 0,
            backgroundColor: background,

            expandedHeight: height * 0.2,
            foregroundColor: textColor,
            title: Text(
              "Faq",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 24),
            ),
          ),
          SliverFillRemaining(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: domandeList.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    backgroundColor: blueColor,
                    childrenPadding: EdgeInsets.all(20),
                    title: Text(
                      //domandeListTranslated[index]!,
                      domandeList[index],
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                    ),
                    children: [Text(risposteList[index], style: TextStyle(color: textColor2, fontWeight: FontWeight.w500))],
                  );
                }),
          )
        ],
      )),
    );
  }
}

 //Text("Faq",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)