
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:near_me/Screen/TabPage/Dati%20Viaggiatore/InfoAccount.dart';
import 'package:near_me/Screen/TabPage/TabScreen/Page1.dart';
import 'package:near_me/wrapper.dart';
import '../../DetailsView/core/utils/size_utils.dart';
import '../../Theme.dart';

class Page0 extends StatefulWidget {
  final String structure;
  const Page0({Key? key, required this.structure}) : super(key: key);

  @override
  State<Page0> createState() => _Page0State();
}

class _Page0State extends State<Page0> {
  
  

  bool loading = false;
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
    List<String> nameButton = [ AppLocalizations.of(context)!.informazioni_account,  AppLocalizations.of(context)!.dati_del_viaggiatore,  AppLocalizations.of(context)!.elimina_dati_account];

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    
    List<Color> colorButton = [textColor, textColor, Colors.red];

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Imposta il colore della barra di stato
    ));
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final bar_e_text = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    List function = [
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoAccount()),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Page1(
                    structure: widget.structure,
                  )),
        );
      },
      () => showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoTheme(
                data: MediaQuery.of(context).platformBrightness == Brightness.dark ? MyThemeDark.darkTheme : MyThemeLight.lightTheme,
                child: CupertinoActionSheet(
                  title: Text(
                    AppLocalizations.of(context)!.sicuro_eliminare,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  message: Text(
                    AppLocalizations.of(context)!.no_recuperarlo,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.annulla,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ),
                  actions: [
                    Container(
                      color: Colors.transparent,
                      child: CupertinoActionSheetAction(
                        onPressed: () async {
                          _loading();
                          HapticFeedback.heavyImpact();
                          await FirebaseDatabase.instance.ref().child('users/$currentUserId').remove();
                          //Navigator.pop(context);
                          FirebaseAuth.instance.currentUser!.delete();

                          FirebaseAuth.instance.signOut();
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (route) => false);
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.definitivamente,
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                      ),
                    )
                  ],
                ),
              ))
    ];
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: bar_e_text,
        elevation: 0,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                     AppLocalizations.of(context)!.i_miei_dati,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,color: textColor),
                  ),
                  SizedBox(height: height * 0.05),
                  Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: nameButton.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CupertinoButton(
                        onPressed: function[index],
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: width,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              children: [
                                Text(
                                  nameButton[index],
                                  style: TextStyle(color: colorButton[index], fontSize: 16),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.chevron_right_outlined,
                                  color: textColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 2,
                        color: Colors.grey,
                      );
                    },
                  ),
                  Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                ],
              ))),
    );
  }
}
