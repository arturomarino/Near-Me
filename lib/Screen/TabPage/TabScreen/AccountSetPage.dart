import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_me/Screen/TabPage/Setting/LanguagePage.dart';
import 'package:near_me/Screen/TabPage/Dati%20Viaggiatore/Page0.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';

import '../../Theme.dart';
import '../Become Host/BecomeAHost1.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSetPage extends StatefulWidget {
  final String name;
  final String surname;
  final String email;
  final String structure;
  final String idStructure;
  final String typeStructure;
  final List<bool> hostList;
  Function(bool result) refreshCallback;

   AccountSetPage({Key? key, required this.hostList, required this.name, required this.surname, required this.email, required this.structure, required this.idStructure, required this.typeStructure, required this.refreshCallback}) : super(key: key);

  @override
  State<AccountSetPage> createState() => _AccountSetPageState();
}

class _AccountSetPageState extends State<AccountSetPage> {
  List<String> titles = [
    'Prova',
    'Prova',
  ];
  List<String> subTitles = ['jjj', 'kkk'];

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.026),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35,color: textColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Container(
                  decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Buttons(
                        title:  AppLocalizations.of(context)!.i_miei_dati,
                        color: Colors.blue,
                        subtitle: 'prova',
                        icon: Icons.credit_card,
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Page0(
                                    structure: widget.structure,
                                  )));
                        },
                      ),
                      MyDivider(),
                      Buttons(
                        title:  AppLocalizations.of(context)!.imposta_lingua,
                        color: Colors.blue,
                        subtitle: '',
                        icon: Icons.language,
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SetLanguagePage(
                                  )));
                        },
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoTheme(
                            data: MediaQuery.of(context).platformBrightness == Brightness.dark ? MyThemeDark.darkTheme : MyThemeLight.lightTheme,
                            child: CupertinoActionSheet(
                              title: Text(
                                AppLocalizations.of(context)!.sicuro,
                                style: TextStyle(color: textColor, fontWeight: FontWeight.normal),
                              ),
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
                                    FirebaseAuth.instance.signOut();
                                    HapticFeedback.lightImpact();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.esci,
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: buttonColor,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                      child: Row(
                        children: [
                          Container(
                            height: 27,
                            width: 27,
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 20,
                            ),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(7)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.esci,
                                  maxLines: 1,
                                  style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            Visibility(
              visible: widget.hostList.contains(true) ? false : true,
              child: CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            child: Image.asset('assets/star.png'),
                            height: 23,
                          ),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.diventa_un_host,
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          Spacer(),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              child: Text(
                                'New'.toUpperCase(),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color.fromARGB(255, 203, 50, 231)),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BecomeAHost1(
                              fromLoginPage: false,
                              host: true,
                            ),
                        fullscreenDialog: true));
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Divider(
        height: 1,
        color: textColor,
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Function() function;
  const Buttons({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: function,
      child: Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            child: Row(
              children: [
                Container(
                  height: 27,
                  width: 27,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    color: Colors.grey,
                    size: 17,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
