import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AiutoPiscina extends StatefulWidget {
  const AiutoPiscina({Key? key}) : super(key: key);

  @override
  _AiutoPiscinaState createState() => _AiutoPiscinaState();
}

class _AiutoPiscinaState extends State<AiutoPiscina> {
      final Shader linearGradient = LinearGradient(
      colors: <Color>[Color.fromARGB(255, 0, 153, 255), Color.fromARGB(255, 62, 97, 227)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: textColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.regole_piscina_titolo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 29,foreground: Paint()..shader = linearGradient,),),
                    SizedBox(height: 20,),
                    Text(AppLocalizations.of(context)!.regole_piscina_testo,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,height: 1.7,color: textColor),),
                    ],
                ),
              ),
            )));
  }
}
