import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:near_me/Screen/TabPage/FaqPage.dart';
import 'package:near_me/Screen/TabPage/HomeButtonPage.dart';
import 'package:near_me/Screen/TabPage/Setting/EmergencyPage.dart';
import 'package:near_me/Screen/TabPage/Setting/RulePage.dart';
import 'package:near_me/Screen/TabPage/Setting/ServicePage.dart';
import 'package:near_me/Screen/TabPage/Setting/Strutture.dart';
import 'package:near_me/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_settings/open_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../DetailsView/core/utils/size_utils.dart';
import '../../DetailsView/presentation/iphone_14_one_screen/DetailsViewLuoghi.dart';
import '../../Theme.dart';
import '../../Verification/presentation/iphone_14_two_screen/IdentityVerification.dart';
import '../Dati Viaggiatore/Page0.dart';
import '../Dati Viaggiatore/Page3.dart';
import '../Setting/InfoStructure.dart';
import '../Setting/LanguagePage.dart';
import 'package:firebase_database_platform_interface/src/transaction.dart' as db_transaction;


class SettingPage extends StatefulWidget {
  final String name;
  final String surname;
  final String email;
  final String structure;
  final String idStructure;
  final String typeStructure;
  final List<bool> hostList;
  final List<String> domandeList;
  final String nomeCognome;

  Function(bool result) refreshCallback;

  SettingPage(
      {Key? key,
      required this.name,
      required this.surname,
      required this.email,
      required this.hostList,
      required this.structure,
      required this.idStructure,
      required this.typeStructure,
      required this.refreshCallback,
      required this.domandeList,
      required this.nomeCognome})
      : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String name = '';
  String surname = '';
  String numberOfGuest = '';
  String amm = '';
  String host = '';
  String uid = '';
  String type = '';

  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  var currentUserMail = FirebaseAuth.instance.currentUser!.email;
  TextEditingController _controller = TextEditingController();
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('structure/ristoranti');

  String struttura = '';
  @override
  void initState() {
    super.initState();
    _getData();

    _controller = new TextEditingController();
  }

  //final TextEditingController WiFiController =
  //    TextEditingController(text: "iChiani17");

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.copiato),
    ));
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _getData2() async {
    final databaseRef = FirebaseDatabase.instance.ref().child('structure/${widget.structure}');
    final snapshot = await databaseRef.once();
    final data = snapshot.snapshot.value as Map;
    setState(() {
      uid = '${data['uid']}';
      type = '${data['type']}';
    });
  }

  final ref = FirebaseDatabase.instance.ref();
  bool hostBool = false;
  List<bool> hostsList = [];
  GoogleTranslator translator = GoogleTranslator();
  void _getData() async {
    hostsList.clear();

    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        Map<dynamic, dynamic> members = values["members"] as Map<dynamic, dynamic>;
        bool hostBool = members["$currentUser"] == null ? false : members["$currentUser"];
        hostsList.add(hostBool);
      });

      print(hostsList);
      setState(() {});
    });
    Future.delayed(Duration(seconds: 2), () {
      _getWifiData();
      //etData2();
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    _getData();
    _getData2();
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    HapticFeedback.heavyImpact();
    _refreshController.refreshCompleted();
  }

  String nameWifi = '';
  String password = '';

  void _getWifiData() async {
    final databaseRef = FirebaseDatabase.instance.ref().child('structure/${widget.structure}/wifi');
    final snapshot = await databaseRef.once();
    final wifiData = snapshot.snapshot.value as Map;
    setState(() {
      nameWifi = '${wifiData['nome']}';
      password = '${wifiData['password']}';
    });
  }

  String checkIn = '';
  String checkOut = '';

  void addData(String parameter) async {
    DateTime now = DateTime.now();

    // Formatta la data con il formato "monda"
    String formattedDate = DateFormat('EEE', 'en_US').format(now).toUpperCase();
    DatabaseReference dataRef = FirebaseDatabase.instance.ref("structure/${widget.structure}");
    DatabaseReference dataAnalytics = dataRef.child('analytics/$formattedDate');

    await dataAnalytics.update({'$parameter': 1, 'day': formattedDate});
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
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final cardColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;

    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 =
        MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 157, 157, 157) : Color.fromARGB(255, 157, 157, 157);
    //FlutterStatusbarcolor.setStatusBarColor(textColor);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        top: true,
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: width,
                    height: height * 0.085,
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.02, left: width * 0.06, right: width * 0.06),
                      child: Row(
                        children: [
                          Container(
                              height: 40,
                              width: 4,
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                              child: SizedBox()),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.ciao} 👋🏼 ciao',
                                style: TextStyle(color: textColor2, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                '${widget.name} ${widget.surname} ',
                                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              /*Text(
                                    widget.email,
                                    style: TextStyle(color: textColor2, fontWeight: FontWeight.w600, fontSize: 12),
                                  ),*/
                            ],
                          ),
                          Spacer(),
                          CupertinoButton(
                              child: Icon(
                                CupertinoIcons.info,
                                size: 25,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => InfoStructure(
                                          name: widget.structure,
                                          refreshCallback: (bool result) {
                                            if (result == true) {
                                              widget.refreshCallback(true);
                                            }
                                          },
                                        ),
                                    fullscreenDialog: true));
                              }),
                        ],
                      ),
                    )),
                Visibility(
                  visible: widget.hostList.contains(true),
                  child: CupertinoButton(
                    padding: EdgeInsets.only(bottom: 5, left: 20, right: 20, top: 10),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StrutturePage(
                                  name: widget.structure,
                                  type: type,
                                  uid: uid,
                                  refreshCallback: (bool result) {
                                    if (result == true) {
                                      widget.refreshCallback(true);
                                    }
                                  },
                                )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                          child: Row(
                            children: [
                              Container(
                                height: 27,
                                width: 27,
                                child: Icon(
                                  Icons.bed,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(7)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.manage,
                                      maxLines: 1,
                                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.da_sapere.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 232, 82, 48), fontSize: 18),
                              ),
                              Spacer(),
                              Container(
                                width: width * .4,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  widget.structure,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              ButtonsWidget(
                                textColor: textColor,
                                color: Colors.yellow,
                                text: AppLocalizations.of(context)!.wifi,
                                showTick: true,
                                function: () async {
                                  await FirebaseAnalytics.instance.logEvent(name: 'setWifi-pressed');
                                  showModalBottomSheet(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SetWifiSheet(
                                        nameWifi: nameWifi,
                                        password: password,
                                      );
                                    },
                                  );
                                },
                                icon: Icons.wifi,
                              ),
                              ButtonsWidget(
                                showTick: true,
                                textColor: textColor,
                                color: Colors.blue,
                                text: AppLocalizations.of(context)!.orario_checkIn,
                                function: () async {
                                  final databaseRef = FirebaseDatabase.instance.ref().child('structure/${widget.structure}/checkInOut');
                                  final snapshot = await databaseRef.once();
                                  final data = snapshot.snapshot.value as Map;
                                  setState(() {
                                    checkIn = '${data['checkIn']}';
                                    checkOut = '${data['checkOut']}';
                                  });
                                  showModalBottomSheet(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CheckInSheets(
                                        checkIn: checkIn,
                                        checkOut: checkOut,
                                      );
                                    },
                                  );
                                },
                                icon: Icons.time_to_leave,
                              ),
                              ButtonsWidget(
                                textColor: textColor,
                                color: Colors.red,
                                text: AppLocalizations.of(context)!.numero_di_emergenza,
                                showTick: true,
                                function: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmergencyPage()));
                                },
                                icon: Icons.phone,
                              ),
                              ButtonsWidget(
                                textColor: textColor,
                                color: Colors.green,
                                text: AppLocalizations.of(context)!.regole_della_casa,
                                showTick: true,
                                function: () async {
                                  await FirebaseAnalytics.instance.logEvent(name: 'rules_pressed');
                                  _updateAnalytics('rules_pressed');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RulePage(
                                            structure: widget.structure,
                                          )));
                                },
                                icon: Icons.rule,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseAnalytics.instance.logEvent(name: 'faq_pressed');
                      _updateAnalytics('faq_pressed');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.faq_della_casa.toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 232, 82, 48), fontSize: 15),
                                ),
                              ],
                            ),
                            Container(
                              width: width,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  ButtonsWidget(
                                    textColor: textColor,
                                    color: Colors.yellow,
                                    text: widget.domandeList.isEmpty ? 'L\'host non ha ancora pubblicato faq per questa casa' : 'How work the house?',
                                    showTick: false,
                                    function: () async {
                                      await FirebaseAnalytics.instance.logEvent(name: 'faq_pressed');
                                      _updateAnalytics('faq_pressed');

                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => FaqPage(
                                                structure: widget.structure,
                                              )));
                                    },
                                    icon: Icons.wallet,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.mostra_di_piu,
                                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                                        ),
                                        Icon(
                                          CupertinoIcons.chevron_right,
                                          size: 13,
                                        )
                                      ],
                                    ),
                                    onPressed: () async {
                                      await FirebaseAnalytics.instance.logEvent(name: 'faq_pressed');
                                      _updateAnalytics('faq_pressed');

                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => FaqPage(
                                                structure: widget.structure,
                                              )));
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Container(
                            height: height * 0.16,
                            width: height * 0.16,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                        height: height * 0.111,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [LottieBuilder.asset('assets/explore.json',repeat: false,animate: false,)],
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppLocalizations.of(context)!.esplora,
                                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () async {
                          await FirebaseAnalytics.instance.logEvent(name: 'servizi_pressed');
                          _updateAnalytics('servizi_pressed');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServicePage(
                                      structure: widget.structure,
                                      nomeCognome: widget.nomeCognome,
                                    )),
                          );
                        },
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: height * 0.16,
                          width: height * 0.16,
                          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.spa,
                                      size: 30,
                                    )
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.altri_servizi,
                                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 20),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.2,
                )

                /*GridView.builder(
                    shrinkWrap: true,
                    itemCount: widget.hostList.contains(true) ? functionHost.length : function.length,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: widget.hostList.contains(true) ? functionHost[index] : function[index],
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            height: height * .06,
                            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: width * .1, child: Image.asset(widget.hostList.contains(true) ? imagesHost[index] : images[index])),
                                SizedBox(height: 20),
                                Text(
                                  widget.hostList.contains(true) ? nameButtonHost[index] : nameButton[index],
                                  style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckInSheets extends StatelessWidget {
  final String checkIn;
  final String checkOut;
  const CheckInSheets({
    super.key,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      height: height * .3,
      width: width,
      decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.grey,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Time Check-in/out',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
              ),
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Check-in:',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
                  children: <TextSpan>[
                    TextSpan(text: ' $checkIn', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Check-out:',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
                  children: <TextSpan>[
                    TextSpan(text: ' $checkOut', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}

class ButtonsWidget extends StatelessWidget {
  final Color color;
  final String text;
  final bool showTick;
  final IconData icon;
  final Function()? function;
  ButtonsWidget({
    Key? key,
    required this.textColor,
    required this.color,
    required this.text,
    required this.showTick,
    required this.function,
    required this.icon,
  }) : super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          child: Row(
            children: [
              Visibility(
                visible: this.showTick,
                child: Container(
                    height: 30, width: 4, decoration: BoxDecoration(color: this.color, borderRadius: BorderRadius.circular(10)), child: SizedBox()),
              ),
              Visibility(visible: this.showTick, child: SizedBox(width: 2)),
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Row(
                    children: [
                      Visibility(
                        visible: this.showTick,
                        child: Icon(
                          icon,
                          color: textColor,
                          size: 18,
                        ),
                      ),
                      Visibility(visible: this.showTick, child: SizedBox(width: 5)),
                      Expanded(child: Text(this.text, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.normal))),
                    ],
                  ),
                ),
                decoration: showTick ? BoxDecoration(color: color.withOpacity(0.3), borderRadius: BorderRadius.circular(3)) : null,
              ))
            ],
          ),
        ),
        onPressed: function);
  }
}

void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetLanguagePage()));
}
/*ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: Text("Esci"))*/

class TextFieldContainerUnder extends StatelessWidget {
  final Widget child;
  final double alt;
  final double larg;

  const TextFieldContainerUnder({
    Key? key,
    required this.child,
    required this.alt,
    required this.larg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;

    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: alt,
        width: size.width * larg,
        decoration: BoxDecoration(color: background2, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: child);
  }
}

class ContainerTile extends StatelessWidget {
  const ContainerTile({Key? key, required this.funzione}) : super(key: key);
  final Function funzione;

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;

    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 300,
        width: size.width * 0.87,
        decoration: BoxDecoration(color: background2, borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            ListTile(
                dense: true,
                title: Text(
                  "Imposta WiFi",
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                trailing: Icon(
                  Icons.wifi,
                  color: textColor,
                ),
                onTap: () {
                  funzione;
                }),
            Divider(indent: 0, color: textColor.withOpacity(0.2), thickness: 0.5),
            ListTile(
              dense: true,
              onTap: (() {
                _navigateToNextScreen(context);
              }),
              title: Text("Lingua", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
              trailing: Icon(
                Icons.language,
                color: textColor,
              ),
            ),
            Divider(indent: 0, color: textColor.withOpacity(0.2), thickness: 0.5),
            ListTile(
              dense: true,
              onTap: () {
                const url = "https://www.ichiani.it/termini-e-condizioni/";
                launch(url);
              },
              title: Text("Termini e Condizioni", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
              trailing: Icon(
                Icons.rule,
                color: Colors.red,
              ),
            ),
            Divider(indent: 0, color: textColor.withOpacity(0.2), thickness: 0.5),
          ],
        ));
  }
}

class SetWifiSheet extends StatefulWidget {
  final String nameWifi;
  final String password;
  const SetWifiSheet({
    Key? key,
    required this.nameWifi,
    required this.password,
  }) : super(key: key);

  @override
  State<SetWifiSheet> createState() => _SetWifiSheetState();
}

class _SetWifiSheetState extends State<SetWifiSheet> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.password);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: controller.text));
    setState(() {
      _copied = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _copied = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      height: height * .3,
      width: width,
      decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('Chiudi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              'Set Wi-Fi - ${widget.nameWifi}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CupertinoTextField(
                controller: controller,
                obscureText: true,
                readOnly: true,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffix: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _copied
                            ? Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: CupertinoColors.systemGreen,
                                size: 20,
                              )
                            : Icon(
                                CupertinoIcons.doc_on_doc,
                                color: CupertinoColors.systemGrey,
                                size: 20,
                              ),
                        SizedBox(width: 5.0),
                        Text(
                          _copied ? 'Copied!' : 'Copy',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _copyToClipboard();
                    HapticFeedback.heavyImpact();
                  },
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                    width: width,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Center(
                        child: Text(
                      'Open Setting',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ))),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                })
          ],
        ),
      ),
    );
  }
}






      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        foregroundColor: Colors.black,
        title: Text("Settings"),
      ),
      body: SafeArea(
        bottom: false,
        child: SettingsList(
          sections: [
            SettingsSection(
                title: Text("Dati Personali"),
                tiles: <SettingsTile>[
                  SettingsTile(
                    title: Text('$name $surname' == 'null null'
                        ? "Check Internet Connection"
                        : '$name $surname'),
                    leading: Icon(Icons.person),
                  ),
                  SettingsTile(
                    title: Text("$currentUserMail"),
                    leading: Icon(Icons.mail),
                  ),
                ]),
            SettingsSection(
              title: Text("Settings"),
              tiles: <SettingsTile>[
                SettingsTile(
                  onPressed: ((context) {
                    showAlertDialog(context);
                  }),
                  leading: Icon(Icons.wifi),
                  title: Text(
                    'Imposta WiFi',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SettingsTile.navigation(
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetLanguagePage()),
                    );
                  },
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  value: Text('English'),
                ),

                /*SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: Icon(Icons.format_paint),
              title: Text('Enable custom theme'),
            ),*/

                SettingsTile(
                  onPressed: (context) {
                    const url = "https://www.ichiani.it/termini-e-condizioni/";
                    launch(url);
                  },
                  leading: Icon(Icons.mail, color: Colors.blue),
                  title: const Text(
                    'Contatta lo sviluppatore',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SettingsTile(
                  onPressed: (context) {
                    const url = "https://www.ichiani.it/termini-e-condizioni/";
                    launch(url);
                  },
                  leading: Icon(Icons.rule, color: Colors.black),
                  title: const Text(
                    'Termini e Condizioni',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SettingsTile(
                  onPressed: ((context) {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }),
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            SettingsSection(
                title: Text("CIS (Codice di Identificazione Struttura)"),
                tiles: [SettingsTile(title: Text("LE07502891000006160"))])
          ],
        ),
      ),*/