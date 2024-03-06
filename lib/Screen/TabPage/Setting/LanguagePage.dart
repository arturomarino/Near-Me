import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_me/provider/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLanguagePage extends StatelessWidget {
  const SetLanguagePage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
      final Stream<QuerySnapshot> _prodottiStream =
      FirebaseFirestore.instance.collection('user').snapshots();
      var currentUser = FirebaseAuth.instance.currentUser!.uid;
     final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    // Obtain shared preferences.
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: textColor,
        title: Text(
          AppLocalizations.of(context)!.scegli_lingua,
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SettingsList(
          lightTheme: SettingsThemeData(
              settingsListBackground: background,
            
            dividerColor: Colors.grey,  settingsTileTextColor: textColor,
              settingsSectionBackground: buttonColor),
          darkTheme: SettingsThemeData(
            dividerColor: Colors.grey,
            settingsListBackground: background,
             settingsTileTextColor: textColor,
             settingsSectionBackground: buttonColor
          ),
          sections: [
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.scegli),
              tiles: <SettingsTile>[
                SettingsTile(
                  onPressed: ((context) async{
                    final provider =
                        Provider.of<LocaleProvider>(context, listen: false);
                    provider.setLocale(Locale("it"));
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('language', 'it');
                   
                  }),
                  leading: Icon(Icons.language),
                  trailing: AppLocalizations.of(context)!.language == "Italiano"
                      ? Icon(
                          CupertinoIcons.check_mark,
                          color: textColor,
                        )
                      : null,
                  title: Text('Italiano',style: TextStyle(color: textColor)),
                ),
                SettingsTile(
                  onPressed: ((context)async {
                    final provider =
                        Provider.of<LocaleProvider>(context, listen: false);
                    provider.setLocale(Locale("en"));

                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('language', 'en');
                    
                  }),
                  leading: Icon(Icons.language),
                  trailing: AppLocalizations.of(context)!.language == "English"
                      ? Icon(CupertinoIcons.check_mark, color: textColor)
                      : null,
                  title: Text('English',style: TextStyle(color: textColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
