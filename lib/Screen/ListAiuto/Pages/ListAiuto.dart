import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:near_me/Screen/ListAiuto/Pages/AiutoPiscina.dart';
import 'package:near_me/Screen/ListAiuto/Pages/BlackoutPage.dart';
import 'package:near_me/Screen/ListAiuto/Pages/DifferenziataPage.dart';
import 'package:near_me/data/dataAiuto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListAiuto extends StatefulWidget {
  ListAiuto({Key? key}) : super(key: key);

  @override
  State<ListAiuto> createState() => _ListAiutoState();
}

class _ListAiutoState extends State<ListAiuto> {
  @override
  Widget build(BuildContext context) {
    final callButton = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 32, 82, 33) : Colors.green;
    final bwColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(236, 0, 0, 0) : Colors.white;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;

    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final shadowColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Colors.black;

    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    DataAiuto dataAiuto = DataAiuto();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    //SystemChrome.setSystemUIOverlayStyle(MediaQuery.of(context).platformBrightness ==Brightness.dark ? SystemUiOverlayStyle.light:SystemUiOverlayStyle.dark); // 1
    return Stack(
      children: [
        Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.white),
        Center(child: Lottie.asset('assets/gif.json')),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 75, right: 20, bottom: 25),
                    child: Row(
                      children: [
                        CupertinoButton(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.aiutoQuest,
                            style: TextStyle(foreground: Paint()..shader = linearGradient, fontWeight: FontWeight.bold, fontSize: 37)),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: shadowColor.withOpacity(0.20),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ], color: background.withOpacity(0.9), borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BlackoutPage()),
                          );
                        },
                        subtitle: Text(
                          AppLocalizations.of(context)!.problema,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: textColor),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        title: Text(
                          AppLocalizations.of(context)!.blackout,
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                        /*leading: CircleAvatar(backgroundImage: AssetImage("lib/background/coop.PNG")),*/
                        trailing: Icon(Icons.arrow_forward, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: shadowColor.withOpacity(0.20),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ], color: background.withOpacity(0.9), borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AiutoPiscina()),
                          );
                        },
                        subtitle: Text(
                          AppLocalizations.of(context)!.istruzioni_piscina,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: textColor),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        title: Text(
                          AppLocalizations.of(context)!.piscina,
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                        /*leading: CircleAvatar(backgroundImage: AssetImage("lib/background/coop.PNG")),*/
                        trailing: Icon(Icons.arrow_forward, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: shadowColor.withOpacity(0.20),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        ),
                      ], color: background.withOpacity(0.9), borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DifferenziataPage()),
                          );
                        },
                        subtitle: Text(
                          AppLocalizations.of(context)!.rivista,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: textColor),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        title: Text(
                          AppLocalizations.of(context)!.spazzatura,
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                        /*leading: CircleAvatar(backgroundImage: AssetImage("lib/background/coop.PNG")),*/
                        trailing: Icon(Icons.arrow_forward, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
