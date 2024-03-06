import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);

    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;

    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: LottieBuilder.asset('assets/emergency2.json'),
            width: width * 0.7,
          ),
          Text(
            'Are you in danger?',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 25),
          ),
          SizedBox(height: height * 0.03),
          CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.phone), SizedBox(width: 10), Text('Call 112')],
                  )),
              onPressed: () {
                HapticFeedback.lightImpact();
                launch("tel://112");
              }),
          CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.phone), SizedBox(width: 10), Text('Call 115')],
                  )),
              onPressed: () {
                HapticFeedback.lightImpact();
                launch("tel://115");
              }),
          CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.phone), SizedBox(width: 10), Text('Call 118')],
                  )),
              onPressed: () {
                 HapticFeedback.lightImpact();
                launch("tel://118");
              })
        ],
      ),
    );
  }
}
