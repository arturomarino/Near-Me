import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class DifferenziataPage extends StatefulWidget {
  const DifferenziataPage({Key? key}) : super(key: key);

  @override
  _DifferenziataPageState createState() => _DifferenziataPageState();
}

class _DifferenziataPageState extends State<DifferenziataPage> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final statusBar =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.red
            : Colors.red;
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(236, 0, 0, 0)
            : Colors.grey[200];
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromRGBO(20, 20, 20, 1)
            : Colors.grey[200];

    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;

    Widget dismiss = ElevatedButton(
      style: ElevatedButton.styleFrom(),
      child: Text(AppLocalizations.of(context)!.ho_capito),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget scrivici = ElevatedButton(
      style: ElevatedButton.styleFrom(),
      child: Text(AppLocalizations.of(context)!.caricamento),
      onPressed: () {},
    );

    void _launchWhatsapp() async {
      const url = "https://wa.me/?text=Hey buddy, try this super cool new app!";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    showWifiDialog(BuildContext context) {
      final bwColor =
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color.fromARGB(255, 54, 52, 52)
              : Colors.white;
      final background =
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color.fromARGB(236, 0, 0, 0)
              : Colors.white;
      final buttonColor =
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color.fromARGB(255, 20, 20, 20)
              : Colors.white;

      final textColor =
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.white
              : Color.fromARGB(255, 30, 30, 30);

      Widget dismiss = ElevatedButton(
        style: ElevatedButton.styleFrom(),
        child: Text(AppLocalizations.of(context)!.ho_capito),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      void _launchWhatsapp() async {
        const url =
            "https://wa.me/+393456046302";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }

      Widget scrivici = ElevatedButton(
        style: ElevatedButton.styleFrom(),
        child: Text(AppLocalizations.of(context)!.scrivici),
        onPressed: () {
          _launchWhatsapp();
        },
      );

      

      // set up the AlertDialog
      AlertDialog alertWifi = AlertDialog(
        backgroundColor: bwColor,
        buttonPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        contentPadding: const EdgeInsets.all(23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          AppLocalizations.of(context)!.istruzioni_titolo,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "1.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textColor),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(AppLocalizations.of(context)!.separa,
                      style: TextStyle(color: textColor)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("2.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor)),
                  SizedBox(
                    width: 3,
                  ),
                  RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: AppLocalizations.of(context)!.riponi),
                        TextSpan(
                            text: AppLocalizations.of(context)!.organico,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            )),
                        TextSpan(text: AppLocalizations.of(context)!.e_il),
                        TextSpan(
                            text: AppLocalizations.of(context)!.non_riciclabile,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            )),
                        TextSpan(text: AppLocalizations.of(context)!.devono),
                      ],
                    ),
                  ),
                  //Text("Riponi la spazzatura nel \nrispettivo bidone colorato,\nRicorda che solo l'umido\ne il non riciclabile\ndevono essere inserito prima\nin un sacchetto di plastica\ne successivamente nel \nrispettivo bidone colorato"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "3.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    AppLocalizations.of(context)!.bidone,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "4.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textColor),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(AppLocalizations.of(context)!.bidoni,
                      style: TextStyle(color: textColor)),
                ],
              )
            ],
          ),
        ),
        actions: [scrivici, dismiss],
      );

      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alertWifi;
        },
      );
    }

    return Scaffold(
        backgroundColor: buttonColor,
        appBar: AppBar(
          systemOverlayStyle:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          foregroundColor: textColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 15),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.spazzatura,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: textColor),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                    child: Row(
                      children: [
                        CupertinoButton(
                            child: Text(
                              AppLocalizations.of(context)!.istruzioni_vedi,
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                            onPressed: () {
                              showWifiDialog(context);
                            }),
                        Expanded(child: Container())
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width,
                    child: PageView(
                      pageSnapping: true,
                      controller: _pageController,
                      children: [
                        Center(
                          child: ClipRRect(
                            child: Image.asset(AppLocalizations.of(context)!
                                        .language ==
                                    "English"
                                ? 'assets/differenziata/diff_inglese1.jpg'
                                : 'assets/differenziata/diff_italiano1.png'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                              child: Image.asset(AppLocalizations.of(context)!
                                          .language ==
                                      "English"
                                  ? 'assets/differenziata/diff_inglese2.jpg'
                                  : 'assets/differenziata/diff_italiano2.jpg'),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        dotColor: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.black.withOpacity(0.4),
                        activeDotColor:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black),
                  )
                ],
              )),
        ));
  }
}
