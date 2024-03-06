import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart' as button;
import 'package:lottie/lottie.dart';
import 'package:near_me/LoginSystem/AddNameForApple.dart';
import 'package:near_me/LoginSystem/LoginPage.dart';
import 'package:near_me/LoginSystem/RegisterEmail.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:near_me/wrapper.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_player/video_player.dart';

import '../Screen/TabPage/Become Host/BecomeAHost1.dart';
import '../Screen/TabPage/TabBar.dart';
import '../data/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _zoom = false;
  @override
  void initState() {
    super.initState();
    _playVideo();
  }

  void _playVideo() async {
    //add delay till video is complite
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _zoom = true;
    });;
     await Future.delayed(const Duration(milliseconds: 600));
    // navigating to home screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Center(child: AnimatedContainer(duration: Duration(milliseconds: 600),width: _zoom==false?width* 0.5:width, child: Image.asset('assets/App Icon Dark.png'))));
  }
}
