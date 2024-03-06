import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:near_me/Screen/TabPage/TabScreen/AccountSetPage.dart';
import 'package:near_me/Screen/TabPage/TabScreen/Page1.dart';
import 'package:near_me/Screen/TabPage/TabScreen/HomePage.dart';
import 'package:near_me/Screen/TabPage/TabScreen/prova.dart';
import 'HomePage.dart';
import 'LocationPage.dart';

class MyTabBar extends StatefulWidget {
  final int currentIndex;
  final String structure;
  MyTabBar({Key? key, required this.currentIndex, required this.structure}) : super(key: key);
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  @override
  void initState() {
    _getData();

    super.initState();
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int currentIndex = 0;
  final ref = FirebaseDatabase.instance.ref();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  String structure = '';
  String name = '';
  String surname = '';
  String email = '';
  String uid = '';
  String type = '';
  String host = '';
  String nameStructure = '';
  List<bool> hostsList = [];

  void _getData() async {
    Future.delayed(Duration(seconds: 1), () async {
      final structure2 = await ref.child('users/$currentUser/structureGuest/name').get();
      final name2 = await ref.child('users/$currentUser/name').get();
      final surname2 = await ref.child('users/$currentUser/surname').get();
      final email2 = await ref.child('users/$currentUser/email').get();

      if (structure2.exists && name2.exists && surname2.exists && email2.exists) {
        setState(() {
          structure = structure2.value.toString();
          name = name2.value.toString();
          surname = surname2.value.toString();
          email = email2.value.toString();
        });
      } else {
        print('No data available.');
      }
    });
    Future.delayed(Duration(seconds: 2), () {
      _getFaq();
    });

    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        Map<dynamic, dynamic> members = values["members"] as Map<dynamic, dynamic>;
        bool hostBool = members["$currentUser"] == null ? false : members["$currentUser"];
        hostsList.add(hostBool);
      });
      setState(() {});
    });
  }

  List<String> domandeList = [];
  List<String> risposteList = [];

  _getFaq() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/$structure/faq");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String domanda = values["domanda"];
        String risposta = values["risposta"];
        domandeList.add(domanda);
        risposteList.add(risposta);
      });
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {});
      print(domandeList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      //MyHomePage(),
      
      SettingPage(
        name: name,
        surname: surname,
        email: email,
        hostList: hostsList,
        structure: structure,
        idStructure: uid,
        typeStructure: type,
        nomeCognome: '$name $surname',
        refreshCallback: (bool result) {
          if (result == true) {
            _getData();
          }
        },
        domandeList: domandeList,
      ),

      //LocationPage(),
      // OrderPage(),
      Page1(structure: structure),
      AccountSetPage(
        name: name,
        surname: surname,
        email: email,
        hostList: hostsList,
        structure: structure,
        idStructure: uid,
        typeStructure: type,
        refreshCallback: (bool result) {
          if (result == true) {
            _getData();
          }
        },
      )
      /*HomePage(
        structure: structure,
        nomeCognome: '$name $surname',
      ),*/
    ];
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;
    final IconColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final IconColorUnselected = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white38 : Colors.black38;
    final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black;

    List<IconData> listOfIcons = [
      Icons.home_rounded,
      //CupertinoIcons.map_pin_ellipse,
      // CupertinoIcons.cart_fill,
      CupertinoIcons.creditcard,
      CupertinoIcons.settings_solid
    ];

    List<String> listOfStrings = ['Home', AppLocalizations.of(context)!.documenti, AppLocalizations.of(context)!.impostazioni];
    double displayWidth = MediaQuery.of(context).size.width;
    final tabColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 38, 38, 38).withOpacity(0.96) : Colors.white;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CupertinoTabBar(
        key: _bottomNavigationKey,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                CupertinoIcons.house_fill,
                size: 25,
                color: currentIndex == 0 ? Colors.blueAccent : Colors.grey,
              ),
              backgroundColor: IconColor),
          BottomNavigationBarItem(
              label: 'Documenti',
              icon: Icon(
                CupertinoIcons.creditcard_fill,
                size: 25,
                color: currentIndex == 1 ? Colors.blueAccent : Colors.grey,
              ),
              backgroundColor: IconColor),
          /*BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.placemark, size: 25),backgroundColor: IconColor),*/
          //BottomNavigationBarItem(icon: Icon(CupertinoIcons.cart, size: 25), backgroundColor: IconColor),
          BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(
                CupertinoIcons.gear,
                size: 25,
                color: currentIndex == 2 ? Colors.blueAccent : Colors.grey,
              ),
              backgroundColor: IconColor),
        ],
        //  fixedColor: IconColor,
        backgroundColor: background2,
      ),
      body: screens[currentIndex],
    );
  }
}
