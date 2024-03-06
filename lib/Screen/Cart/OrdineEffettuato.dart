import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdineEffettuato extends StatefulWidget {
  const OrdineEffettuato({Key? key}) : super(key: key);

  @override
  State<OrdineEffettuato> createState() => _OrdineEffettuatoState();
}

class _OrdineEffettuatoState extends State<OrdineEffettuato> {
  @override
  Widget build(BuildContext context) {
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(198, 54, 51, 51)
            : Colors.white;
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 25, top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                    child: Icon(
                      CupertinoIcons.xmark,
                      color: textColor,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Text(
                 AppLocalizations.of(context)!.grazie,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45,color: textColor),
                )
              ],
            ),
            Lottie.asset('assets/tickOrder.json', repeat: false),
            Text(
              AppLocalizations.of(context)!.preparare,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: textColor),
            ),
            
          ],
        ),
      )),
    );
  }
}
