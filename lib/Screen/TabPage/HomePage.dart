import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/TabPage/FaqPage.dart';
import 'package:near_me/Screen/TabPage/HomeButtonPage.dart';
import 'package:near_me/Screen/TabPage/ListaServizi.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:near_me/data/dataCitta.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/services/auth_service.dart';
import '../../LoginSystem/LoginPage.dart';
import '../Cart/ListWelness.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_platform_interface/src/transaction.dart' as db_transaction;

class HomePage extends StatefulWidget {
  final String structure;
  final String nomeCognome;

  HomePage({Key? key, required this.structure, required this.nomeCognome}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  String userState = '';
  final _database = FirebaseDatabase.instance.ref();
  var useruid = FirebaseAuth.instance.currentUser?.uid;
  double? distanceInMeters = 0.0;
  DataCitta dataCitta = DataCitta();

  DatabaseReference ref = FirebaseDatabase.instance.ref("users/");

  void _activateListeners() {
    _database.child('users/$useruid/state').onValue.listen((event) {
      final Object? uidState = event.snapshot.value;
      setState(() {
        userState = '$uidState';
      });
    });
  }

  int selectedIndex = 0;
  String valueSelected = "";
  List options = ["Assemblea d'Istituto", "Prof assente"];
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void addData(String parameter) async {
    DateTime now = DateTime.now();

    // Formatta la data con il formato "monda"
    String formattedDate = DateFormat('EEE', 'en_US').format(now).toUpperCase();
    DatabaseReference dataRef = FirebaseDatabase.instance.ref("structure/${widget.structure}");
    DatabaseReference dataAnalytics = dataRef.child('analytics/$formattedDate');

    await dataAnalytics.update({'$parameter': 1,'day':formattedDate});
  }

  void _updateAnalytics(String parameter) async {
    DateTime now = DateTime.now();

    // Formatta la data con il formato "monda"
    String formattedDate = DateFormat('EEE', 'en_US').format(now).toUpperCase();
    //print(formattedDate);

    DatabaseReference dataRef = FirebaseDatabase.instance.ref("structure/${widget.structure}/analytics/$formattedDate");

    TransactionResult result = await dataRef.runTransaction((Object? data) {
      // Ensure a post at the ref exists.
      if (data == null) {
         addData(parameter);
        return db_transaction.Transaction.abort();
        
      }

      Map<String, dynamic> _data = Map<String, dynamic>.from(data as Map);
      if (_data["$parameter"] != null) {
        _data["$parameter"] = _data["$parameter"] + 1;
      } else {
        addData(parameter);
      }

      // Return the new data.
      return db_transaction.Transaction.success(_data);
    });
  }

  @override
  Widget build(BuildContext context) {
    List titoli = [AppLocalizations.of(context)!.storia, AppLocalizations.of(context)!.villa, AppLocalizations.of(context)!.premi];
    List sottoTitoli = [
      AppLocalizations.of(context)!.storia_desc,
      AppLocalizations.of(context)!.villa_desc,
      AppLocalizations.of(context)!.premi_desc
    ];
    List testo = [
      AppLocalizations.of(context)!.la_storia_text,
      AppLocalizations.of(context)!.la_villa_text,
      AppLocalizations.of(context)!.i_premi_text
    ];
    List link = ['https://www.ichiani.it/la-storia/', 'https://www.ichiani.it/la-villa/', ''];

    List url = [
      'https://firebasestorage.googleapis.com/v0/b/ichiani-flutter.appspot.com/o/images%2FimageStoria.jpg?alt=media&token=fd2e061d-dc8b-4fd3-a047-434539a63ace',
      'https://firebasestorage.googleapis.com/v0/b/ichiani-flutter.appspot.com/o/images%2FimageVilla.jpg?alt=media&token=f69062cd-d0c6-4244-ba95-49e7781abb03',
      'https://firebasestorage.googleapis.com/v0/b/ichiani-flutter.appspot.com/o/images%2FimagePremi.jpg?alt=media&token=225ccb05-5f3e-405f-ab14-c7c0a3fc40f6'
    ];

    final Stream<QuerySnapshot> _prodottiStream = FirebaseFirestore.instance.collection('traduzioni').snapshots();
    final authService = Provider.of<AuthService>(context);
    if (userState == "negato") {
      authService.signOut();
      return LoginPage();
    }
    DataCitta dataCitta = DataCitta();
    final _pageController = PageController(initialPage: 0);
    final backgroundCard = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(236, 0, 0, 0) : Colors.white;
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;
    final textColorCard = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;
    final cardColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    SystemChrome.setSystemUIOverlayStyle(
        MediaQuery.of(context).platformBrightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark); // 1
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color.fromARGB(195, 97, 131, 63), Color.fromARGB(197, 111, 184, 38)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    final Shader linearGradientDark = LinearGradient(
      colors: <Color>[Color.fromARGB(195, 149, 212, 86), Color.fromARGB(197, 88, 159, 18)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    final Shader linearGradientDicono = LinearGradient(
      colors: <Color>[Color.fromARGB(230, 255, 7, 214), Color.fromARGB(197, 6, 69, 108)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    final Shader linearGradientDiconoDark = LinearGradient(
      colors: <Color>[Color.fromARGB(246, 255, 7, 243), Color.fromARGB(197, 42, 168, 247)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    children: [
                      Text(
                          //widget.structure,
                          'NearMe',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38, color: Color.fromARGB(255, 29, 134, 219))),
                        
                      /*CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        onPressed: () {
                          
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ListAiuto()),
                          );*/
                        },
                        child: Icon(Icons.help_outline_sharp, size: 28, color: Colors.black),
                      ),*/
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.035),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.22,
                      ),
                      FastButton(
                        function: () async {
                          await FirebaseAnalytics.instance.logEvent(name: 'esplora_pressed');
                          _updateAnalytics('esplora_pressed');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeButtonPage(
                                      structure: widget.structure,
                                    )),
                          );
                        },
                        name: 'Esplora',
                        color: Color.fromARGB(255, 29, 134, 219),
                        child: Icon(
                          CupertinoIcons.map_pin_ellipse,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(child: Container()),
                      FastButton(
                          function: () async {
                            await FirebaseAnalytics.instance.logEvent(name: 'servizi_pressed');
                            _updateAnalytics('servizi_pressed');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListaServizi(
                                        structure: widget.structure,
                                        nomeCognome: widget.nomeCognome,
                                      )),
                            );
                          },
                          name: 'Servizi',
                          color: Color.fromARGB(255, 29, 134, 219),
                          child: Icon(
                            Icons.delivery_dining,
                            size: 25,
                            color: Colors.white,
                          )),
                      Expanded(child: Container()),
                      FastButton(
                          function: () async {
                            await FirebaseAnalytics.instance.logEvent(name: 'auto_pressed');
                            _updateAnalytics('auto_pressed');
                            
                          },
                          name: 'Auto',
                          color: Color.fromARGB(255, 29, 134, 219),
                          child: Image.asset(
                            'assets/carIcon.jpeg',
                            width: 27,
                          )),
                      SizedBox(
                        width: size.width * 0.22,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAnalytics.instance.logEvent(name: 'faq_pressed');
                    _updateAnalytics('faq_pressed');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FaqPage(structure: widget.structure,)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: height * .17,
                      width: height * .17,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: width * .1, child: Image.asset('assets/settingPage/question.png')),
                            SizedBox(height: 20),
                            Text(
                              'Faq',
                              style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /* Row(
                  children: [
                    CupertinoButton(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context)!.dicono,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  foreground: Paint()
                                    ..shader = MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? linearGradientDiconoDark
                                        : linearGradientDicono),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecensioniPage()),
                          );
                        })
                  ],
                ),*/
                /*Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    selectedIndex = index;
                                    valueSelected = options[selectedIndex];
                                    print(valueSelected);
                                  });
                                }),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 30),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      options[index],
                                      style: TextStyle(
                                          color: selectedIndex == index
                                              ? Colors.green
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          decoration: index == selectedIndex
                                              ? TextDecoration.underline
                                              : TextDecoration.none),
                                    ),
                                  ),
                                ),
                              )))),
                ),*/
                /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: MediaQuery.of(context).size.width * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        controller: _pageController,
                        clipBehavior: Clip.none,
                        itemCount: titoli.length,
                        itemBuilder: (context, index) {
                          return InformationCard(
                            url: url[index],
                            tag: 'cac',
                            function: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreenHome(
                                          image: url[index],
                                          testo: testo[index],
                                          titolo: titoli[index],
                                          url: link[index],
                                        )),
                              );
                            },
                            title: titoli[index],
                            subtitle: sottoTitoli[index],
                          );
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: Container()),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            dotColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.4),
                            activeDotColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),*/
                SizedBox(height: 10),
                /*Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(color: background2, borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.tendenza,
                                        style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                    ),
                                    FastButton(
                                      function: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ListAlimentari()),
                                        );
                                      },
                                      name: AppLocalizations.of(context)!.alimentari,
                                      color: Colors.amber,
                                      icon: Icon(
                                        Icons.shopping_basket,
                                        size: 35,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    FastButton(
                                        function: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ListRistoranti()),
                                          );
                                        },
                                        name: AppLocalizations.of(context)!.ristoranti,
                                        color: Colors.orange,
                                        icon: Icon(Icons.restaurant_menu_rounded, size: 35)),
                                    Expanded(child: Container()),
                                    FastButton(
                                        function: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ListShopping()),
                                          );
                                        },
                                        name: AppLocalizations.of(context)!.shopping,
                                        color: Colors.green,
                                        icon: Icon(Icons.shopping_bag, size: 35)),
                                    SizedBox(
                                      width: 35,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                    ),
                                    FastButton(
                                      function: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ListBenzine()),
                                        );
                                      },
                                      name: AppLocalizations.of(context)!.mobilita,
                                      color: Colors.blue,
                                      icon: Icon(Icons.electric_car, size: 35),
                                    ),
                                    Expanded(child: Container()),
                                    FastButton(
                                        function: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ListSalute()),
                                          );
                                        },
                                        name: AppLocalizations.of(context)!.salute,
                                        color: Colors.red,
                                        icon: Icon(CupertinoIcons.heart_fill, size: 35)),
                                    Expanded(child: Container()),
                                    FastButton(
                                        function: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ListAttivita()),
                                          );
                                        },
                                        name: AppLocalizations.of(context)!.attivita,
                                        color: Colors.purple,
                                        icon: Icon(CupertinoIcons.ticket_fill, size: 35)),
                                    SizedBox(
                                      width: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.23,
                          child: ListView.builder(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemCount: dataCitta.allCitta.length,
                              itemBuilder: (context, index) {
                                dataCitta.allCitta.sort((a, b) => a["distance"].compareTo(b["distance"]));
                                return GestureDetector(
                                  onTap: (() {}),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Container(
                                        height: 210,
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                                                child: Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("${dataCitta.allCitta[index]["name"]}",
                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: textColor)),
                                                            Expanded(child: Container()),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                var url = "${dataCitta.allCitta[index]['link']}";
                                                                launch(url);
                                                              },
                                                              child: Text(
                                                                AppLocalizations.of(context)!.vai_button,
                                                                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                elevation: 3,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                padding: EdgeInsets.all(8),
                                                                primary: buttonColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 75,
                                                  decoration: new BoxDecoration(
                                                      color: backgroundCard.withOpacity(0.5),
                                                      borderRadius: const BorderRadius.only(
                                                        bottomLeft: const Radius.circular(15.0),
                                                        bottomRight: const Radius.circular(15),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 9.0,
                                              spreadRadius: 0.0,
                                              offset: const Offset(0, 7), // shadow direction: bottom right
                                            )
                                          ],
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: const Radius.circular(15),
                                              bottomRight: const Radius.circular(15),
                                              topLeft: const Radius.circular(15),
                                              topRight: const Radius.circular(15)),
                                          image: DecorationImage(image: NetworkImage(dataCitta.allCitta[index]['url']), fit: BoxFit.cover),
                                        )),
                                  ),
                                );
                              }
                              /*ListView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          children: [
                            CardRistoranti(title: "$distanceInMeters km"),
                            CardRistoranti(title: "$distanceInMeters km"),
                          ],
                        ),*/
                              ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.social, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                            height: 50,
                            child: Row(
                              children: [CardInstagram(title: ""), CardFacebook(title: ""), CardYoutube(title: "")],
                            )),
                      ),
                      SizedBox(height: 100)
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FastButton extends StatelessWidget {
  const FastButton({
    required this.color,
    required this.name,
    required this.child,
    required this.function,
    Key? key,
  }) : super(key: key);
  final Color color;
  final String name;
  final Widget child;
  final Function function;

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    return Column(children: [
      CupertinoButton(
        onPressed: () {
          function();
        },
        child: child,
        color: Color.fromARGB(255, 29, 134, 219),
        padding: EdgeInsets.all(16.0), // Spaziatura interna del bottone
        borderRadius: BorderRadius.circular(30.0),
      ),
      SizedBox(
        height: 7,
      ),
      Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: textColor),
      )
    ]);
  }
}

class InformationCard extends StatelessWidget {
  InformationCard({required this.title, required this.subtitle, required this.url, required this.function, required this.tag});
  final String title;
  final String subtitle;
  final String url;
  final Function function;
  final Object tag;

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(236, 0, 0, 0) : Colors.white;
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: GestureDetector(
          onTap: (() {
            function();
          }),
          child: Hero(
            tag: tag,
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Image.network(url, fit: BoxFit.cover, height: double.infinity, width: double.infinity),
                      Column(
                        children: [
                          Container(
                            height: 100,
                            color: background.withOpacity(0.6),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27, color: textColor)),
                            SizedBox(height: 4),
                            Text(subtitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textColor))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class CardInstagram extends StatelessWidget {
  const CardInstagram({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        const url = "https://www.instagram.com/_ichiani_/";
        launch(url);
      }),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 50,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Center(
                  child: Image.asset("assets/logoInsta.png", fit: BoxFit.contain, height: double.infinity, width: double.infinity),
                )),
          )),
    );
  }
}

class CardFacebook extends StatelessWidget {
  const CardFacebook({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        const url = "https://www.facebook.com/ichiani.salento/";
        launch(url);
      }),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 0),
        child: Container(
          width: 50,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Center(
              child: Icon(
                Icons.facebook,
                size: 33,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardYoutube extends StatelessWidget {
  const CardYoutube({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        const url = "https://www.youtube.com/channel/UCrh3za-mpm65R3JwmpnibAg/videos";
        launch(url);
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 80,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Center(child: Image.asset("assets/logoYoutube.png", fit: BoxFit.contain, height: double.infinity, width: double.infinity)),
          ),
        ),
      ),
    );
  }
}
