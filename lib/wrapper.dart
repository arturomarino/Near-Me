import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:near_me/LoginSystem/SignUp.dart';
import 'package:near_me/Screen/TabPage/TabBar.dart';
import 'package:provider/provider.dart';

import 'data/services/auth_service.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String userState = '';
  final _database = FirebaseDatabase.instance.ref();
  var useruid = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _database.child('users/$useruid/state').onValue.listen((event) {
      final Object? uidState = event.snapshot.value;
      setState(() {
        userState = '$uidState';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    //print("questo è $userState");
    return StreamBuilder(
        stream: authService.user,
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            //final String? useruid = snapshot.data?.uid;
            final user = snapshot.data;

            /*if (user == null ) {
              authService.signOut();
              return LoginPage();
            } else {
              return MyTabBar();
            }*/
            return user == null ? SignUpPage() :  MyTabBar(currentIndex: 1, structure:'PROVA');
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
