import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:near_me/Screen/DetailsView/presentation/iphone_14_one_screen/DetailsViewLuoghi.dart';
import 'package:near_me/Screen/TabPage/Add%20Restaurant/SearchLcoation/SearchLocationScreen.dart';
import 'package:near_me/Screen/TabPage/ListOrdini.dart';
import 'package:near_me/Screen/TabPage/Setting/AdminListPage.dart';
import 'package:near_me/Screen/TabPage/Setting/Chart/ChartPage.dart';
import 'package:near_me/Screen/TabPage/Setting/DocsListPage.dart';
import 'package:near_me/Screen/TabPage/Setting/MyFaq.dart';
import 'package:near_me/Screen/TabPage/Setting/SetMyService.dart';
import 'package:near_me/Screen/TabPage/Setting/SetChekIn.dart';
import 'package:near_me/Screen/TabPage/Setting/SetRulePage.dart';
import 'package:near_me/Screen/TabPage/Setting/SetWifiPage.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_settings/open_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Verification/presentation/iphone_14_two_screen/IdentityVerification.dart';
import '../Become Host/CreaStruttura.dart';
import 'LanguagePage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'ModifyStructure.dart';

class StrutturePage extends StatefulWidget {
  final String type;
  final String uid;
  final String name;
  Function(bool result) refreshCallback;

  StrutturePage({Key? key, required this.type, required this.uid, required this.name, required this.refreshCallback}) : super(key: key);

  @override
  _StrutturePageState createState() => _StrutturePageState();
}

class _StrutturePageState extends State<StrutturePage> {
  String name = '';
  String surname = '';
  String email = '';
  String structureSelected = '';
  String numberOfGuest = '';
  String amm = '';
  bool refresh = false;

  String nameWifiData = '';
  String passwordWifiData = '';

  final _database = FirebaseDatabase.instance.ref();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  var currentUserMail = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    super.initState();
    _getData();
    _getData2();
    //_getWifiData();
  }

  void _getWifiData() async {
    final databaseRef = FirebaseDatabase.instance.ref().child('structure/$structureSelected/wifi');
    final snapshot = await databaseRef.once();
    final wifiData = snapshot.snapshot.value as Map;
    setState(() {
      nameWifiData = '${wifiData['nome']}';
      passwordWifiData = '${wifiData['password']}';
    });
    print(nameWifiData);
    print(passwordWifiData);
  }

  List<bool> hostsList = [];
  List<String> hostAppartenenteList = [];
  String nomeStruttura = '';

  void _getData2() async {
    hostsList.clear();
    hostAppartenenteList.clear();

    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String nomeStruttura = values["name"];
        Map<dynamic, dynamic> members = values["members"] as Map<dynamic, dynamic>;
        bool hostBool = members["$currentUser"] == null ? false : members["$currentUser"];
        if (hostBool == true) {
          hostAppartenenteList.add(nomeStruttura);
        }
      });
      print(hostAppartenenteList);
      setState(() {});
    });

    final structureSelected2 = await ref.child('users/$currentUser/structureSelected').get();

    if (structureSelected2.exists) {
      setState(() {
        nomeStruttura = structureSelected2.value.toString();
      });
    } else {
      print('No data available.');
    }
    Future.delayed(Duration(seconds: 1), () async {
      if (!hostAppartenenteList.contains(nomeStruttura)) {
        await FirebaseDatabase.instance.ref().child('users/$currentUser').update({'structureSelected': hostAppartenenteList[0]});
      }
    });
    setState(() {});
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final ref = FirebaseDatabase.instance.ref();
  void _getData() async {
    final email2 = await ref.child('users/$currentUser/email').get();
    final structureSelected2 = await ref.child('users/$currentUser/structureSelected').get();

    if (structureSelected2.exists) {
      setState(() {
        email = email2.value.toString();
        structureSelected = structureSelected2.value.toString();
      });
    } else {
      print('No data available.');
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    _getData();
    _getData2();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 100));
    // if failed,use refreshFailed()
    HapticFeedback.heavyImpact();
    _refreshController.refreshCompleted();
  }

  List<bool> openContainer = [
    false,
    false,
    false,
  ];

  List<double> turns = [
    0.0,
    0.0,
    0.0,
  ];
  bool formOpenFlag = false;

  String checkIn = '';
  String checkOut = '';

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);

    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;

    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final divider = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromARGB(255, 157, 157, 157);
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 157, 157, 157) : Colors.black;
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;
    //FlutterStatusbarcolor.setStatusBarColor(textColor);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> nameButton = ['Ristoranti', 'Spiagge', 'Charge', 'Shop', 'Bar', 'Discoteche'];
    List<MaterialColor> colorIcon = [
      Colors.orange,
      Colors.green,
      Colors.blue,
    ];

    List<DatabaseReference> refs = [
      FirebaseDatabase.instance.ref().child('structure/$structureSelected/ristoranti'),
      FirebaseDatabase.instance.ref().child('structure/$structureSelected/spiagge'),
      FirebaseDatabase.instance.ref().child('structure/$structureSelected/charge'),
      FirebaseDatabase.instance.ref().child('structure/$structureSelected/shop'),
      FirebaseDatabase.instance.ref().child('structure/$structureSelected/bar'),
      FirebaseDatabase.instance.ref().child('structure/$structureSelected/disco'),
    ];

    List<IconData> iconButton = [Icons.restaurant, Icons.health_and_safety, Icons.water, Icons.logout];
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SmartRefresher(
          enablePullUp: false,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CupertinoButton(
                          child: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.only(left: 15),
                        ),
                        CupertinoButton(
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Le mie strutture', style: TextStyle(color: textColor2, fontWeight: FontWeight.w600, fontSize: 14)),
                                          Text(structureSelected,
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 19))
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Icon(
                                      CupertinoIcons.arrow_up_down,
                                      color: textColor2,
                                      size: 21,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      enableDrag: true,
                                      isDismissible: false,
                                      builder: (context) => MyBottomSheet(
                                          email: email,
                                          structure: structureSelected,
                                          refreshCallback: (bool result) {
                                            if (result == true) {
                                              widget.refreshCallback(true);
                                            }
                                          },
                                          type: widget.type,
                                          uid: widget.uid),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
                                  .then((value) {
                                if (value == true) {
                                  _getData();
                                  setState(() {
                                    formOpenFlag = false;
                                  });
                                }
                                print('$refresh');
                              });
                            }),
                        Spacer(),
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.graph_square,
                            size: 27,
                            color: textColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChartPage(
                                        structure: structureSelected,
                                      )),
                            );
                          },
                          padding: EdgeInsets.only(right: 25),
                        ),
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.creditcard,
                            size: 27,
                            color: textColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DocListPage(
                                        structure: structureSelected,
                                      )),
                            );
                          },
                          padding: EdgeInsets.only(right: 25),
                        ),
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.person_2,
                            size: 27,
                            color: textColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminListPage(
                                        ref: FirebaseDatabase.instance.ref().child('structure/${structureSelected}/IdMembers'),
                                        structure: structureSelected,
                                      ),
                                  fullscreenDialog: true),
                            );
                          },
                          padding: EdgeInsets.only(right: 25),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Container(
                          decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Buttons(
                                title: 'Faq of my structure',
                                color: Colors.green,
                                subtitle: 'prova',
                                icon: CupertinoIcons.question_circle_fill,
                                function: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyFaq(
                                              structure: structureSelected,
                                            )),
                                  );
                                },
                              ),
                              MyDivider(),
                              Buttons(
                                title: 'Time Che-in/out',
                                color: Colors.blue,
                                subtitle: '',
                                icon: Icons.door_back_door,
                                function: () async {
                                  final databaseRef = FirebaseDatabase.instance.ref().child('structure/$structureSelected/checkInOut');
                                  final snapshot = await databaseRef.once();
                                  final data = snapshot.snapshot.value as Map;
                                  setState(() {
                                    checkIn = '${data['checkIn']}';
                                    checkOut = '${data['checkOut']}';
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SetCheckIn(
                                              structure: structureSelected,
                                              checkIn: checkIn,
                                              checkOut: checkOut,
                                            )),
                                  );
                                },
                              ),
                              MyDivider(),
                              Buttons(
                                title: 'My extra services',
                                color: Colors.blue,
                                subtitle: '',
                                icon: Icons.spa,
                                function: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SetMyService(
                                              structure: structureSelected,
                                            )),
                                  );
                                },
                              ),
                              MyDivider(),
                              Buttons(
                                title: 'Set wi-fi of the structure',
                                color: Colors.blue,
                                subtitle: '',
                                icon: Icons.wifi,
                                function: () async {
                                  final databaseRef = FirebaseDatabase.instance.ref().child('structure/$structureSelected/wifi');
                                  final snapshot = await databaseRef.once();
                                  final wifiData = snapshot.snapshot.value as Map;
                                  setState(() {
                                    nameWifiData = '${wifiData['nome']}';
                                    passwordWifiData = '${wifiData['password']}';
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SetWifiPage(
                                              structure: structureSelected,
                                              nameWifi: nameWifiData,
                                              passWifi: passwordWifiData,
                                            )),
                                  );
                                },
                              ),
                              MyDivider(),
                              Buttons(
                                title: 'Orders',
                                color: Colors.blue,
                                subtitle: '',
                                icon: CupertinoIcons.cart,
                                function: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListaOrdini(
                                              structure: structureSelected,
                                            )),
                                  );
                                },
                              ),
                              MyDivider(),
                              Buttons(
                                title: 'Rules of the house',
                                color: Colors.green,
                                subtitle: '',
                                icon: Icons.rule,
                                function: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SetRulePage(
                                              structure: structureSelected,
                                            )),
                                  );
                                },
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: nameButton.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                              key: GlobalKey(),
                              initiallyExpanded: formOpenFlag,
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                              collapsedIconColor: textColor,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Row(
                                children: [
                                  /*Icon(
                                            iconButton[index],
                                            color: colorIcon[index],
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),*/
                                  Text(
                                    nameButton[index],
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textColor),
                                  ),
                                ],
                              ),
                              trailing: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(Icons.add),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchLocationScreen(
                                              ref: refs[index],
                                            ),
                                        fullscreenDialog: true),
                                  );
                                },
                              ),
                              childrenPadding: EdgeInsets.only(left: width * 0.15),
                              children: <Widget>[
                                FirebaseAnimatedList(
                                    query: refs[index],
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, snapshot, animation, index) {
                                      Map restaurant = snapshot.value as Map;
                                      restaurant['key'] = snapshot.key;
                                      return Slidable(
                                        startActionPane: ActionPane(motion: StretchMotion(), children: [
                                          SlidableAction(
                                            backgroundColor: Colors.red,
                                            icon: CupertinoIcons.delete,
                                            label: 'Delete',
                                            onPressed: (BuildContext context) {
                                              refs[index].child(restaurant['name']).remove();
                                            },
                                          )
                                        ]),
                                        child: ListTile(
                                          leading: Icon(
                                            CupertinoIcons.placemark,
                                            color: Colors.blue,
                                            size: 25,
                                          ),
                                          subtitle: Text(
                                            restaurant['indirizzo'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 12),
                                          ),
                                          title: Text(
                                            restaurant['name'],
                                            style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => DetailScreenLuoghi(
                                                        photos: restaurant['photos']!,
                                                        categories: '',
                                                        url: restaurant['website']!,
                                                        phone: restaurant['phone']!,
                                                        nome: restaurant['name']!,
                                                        distanza: '',
                                                        descrizione: restaurant['description']!,
                                                        weekDay:
                                                            restaurant['opening_hours'] != null ? restaurant['opening_hours']['weekday_text'] : [],
                                                        indirizzo: restaurant['indirizzo'],
                                                      ),
                                                  fullscreenDialog: true),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 5);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.2,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Function() function;
  const Buttons({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: function,
      child: Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            child: Row(
              children: [
                Container(
                  height: 27,
                  width: 27,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
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
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  final String email;
  final String structure;
  final String type;
  final String uid;
  Function(bool result) refreshCallback;
  MyBottomSheet({Key? key, required this.email, required this.structure, required this.type, required this.uid, required this.refreshCallback})
      : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final ref = FirebaseDatabase.instance.ref();
  String structureSelected3 = '';

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  void _getData() async {
    final email2 = await ref.child('users/$currentUser/email').get();
    final structureSelected2 = await ref.child('users/$currentUser/structureSelected').get();

    if (structureSelected2.exists) {
      setState(() {
        structureSelected3 = structureSelected2.value.toString();
      });
    } else {
      print('No data available.');
    }
  }

  List<dynamic> structuresSnapshot = [];
  List<dynamic> structures = [];
  List<dynamic> structureSelected = [];
  void _getUserPermission() async {
    var users = [];
    final snapshot = await FirebaseDatabase.instance.ref().child("users/$currentUser/structure").get();

    if (snapshot.exists && snapshot.value != null) {
      structuresSnapshot.add(snapshot.value);
      structures = structuresSnapshot.expand((element) => element).toList();
      print(structures);
    } else {}
  }

  @override
  void initState() {
    _getUserPermission();
    _getData();

    super.initState();
  }

  late Uri url;

  void getLink() async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://ichiani.page.link/homepage"),
      uriPrefix: "https://ichiani.page.link",
      androidParameters: const AndroidParameters(packageName: "com.ichiani.flutter"),
      iosParameters: const IOSParameters(bundleId: "com.ichiani.ichianiFlutter"),
    );
    final ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    url = dynamicLink.shortUrl;
    print('link: $url');
  }

  @override
  Widget build(BuildContext context) {
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Color.fromRGBO(245, 245, 252, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      height: height * .5,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: background),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 45,
                  height: 6,
                  child: Text(" "),
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(10))),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Strutture",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          widget.email,
                          style: TextStyle(fontWeight: FontWeight.w600, color: textColor2),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FirebaseAnimatedList(
                        query: ref.child('structure'),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, snapshot, animation, index) {
                          Map data = snapshot.value as Map;
                          data['key'] = snapshot.key;
                          //print(data['users'][currentUser]['structure'][])
                          if (data['members'][currentUser] == true) {
                            return CupertinoButton(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              onPressed: () async {
                                DatabaseReference ref = FirebaseDatabase.instance.ref("users/$currentUser");

                                await ref.update({'structureSelected': data['name']});
                                setState(() {});
                                Navigator.pop(context, true);
                                /* if (structureSelected.length == 1) {
                              setState(() {
                                structureSelected.clear();
                                structureSelected.add(data['name']);
                              });
                            }
                            Navigator.pop(context, structureSelected[0]);*/
                              },
                              child: Container(
                                width: width,
                                height: 65,
                                decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                  child: Row(
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Text(
                                          data["name"],
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor),
                                        ),
                                        /*Text(
                                      '40 Utenti',
                                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.grey),
                                    )*/
                                      ]),
                                      Spacer(),
                                      Visibility(
                                        visible: /*structureSelected.contains(data['name'])||*/ structureSelected3 == data['name'],
                                        child: Icon(
                                          CupertinoIcons.check_mark,
                                          size: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      PopupMenuButton(
                                        color: buttonColor,
                                        elevation: 5,
                                        onOpened: () {
                                          HapticFeedback.mediumImpact();
                                        },
                                        child: ClipOval(
                                            child: Icon(
                                          CupertinoIcons.ellipsis_circle,
                                          size: 24,
                                          color: Colors.grey,
                                        )),
                                        offset: Offset(0, 50),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                        itemBuilder: (_) => <PopupMenuEntry>[
                                          PopupMenuItem(
                                              child: ListTile(
                                            onTap: () async {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => ModifyStructure(
                                                        name: data['name'],
                                                        refreshCallback: (bool result) {
                                                          if (result == true) {
                                                            widget.refreshCallback(true);
                                                          }
                                                        },
                                                      ),
                                                  fullscreenDialog: true));

                                              HapticFeedback.lightImpact();
                                              //Navigator.pop(context);
                                            },
                                            leading: const Icon(
                                              CupertinoIcons.info,
                                              color: Colors.blue,
                                            ),
                                            title: const Text(
                                              'Info',
                                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
                                            ),
                                          )),
                                          PopupMenuItem(
                                              child: ListTile(
                                            onTap: () async {
                                              Share.share('Accedi alla mia struttura con questo codice: ${data['uid']}', subject: 'Codice struttura');
                                              HapticFeedback.lightImpact();
                                              Navigator.pop(context);
                                            },
                                            leading: Icon(
                                              CupertinoIcons.share_up,
                                              color: textColor,
                                            ),
                                            title: Text(
                                              'Condividi Link',
                                              style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
                                            ),
                                          )),
                                          PopupMenuItem(
                                              child: ListTile(
                                            onTap: () async {
                                              FirebaseDatabase.instance.ref().child('structure/${data['name']}/members/$currentUser').remove();
                                              FirebaseDatabase.instance.ref().child('structure/${data['name']}/IdMembers/$currentUser').remove();

                                              HapticFeedback.lightImpact();
                                              Navigator.pop(context);
                                            },
                                            leading: const Icon(
                                              CupertinoIcons.person_badge_minus,
                                              color: Colors.red,
                                            ),
                                            title: const Text(
                                              'Esci',
                                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreaStruttura(
                                    becomeHost: false,
                                  ),
                              fullscreenDialog: true),
                        );
                      },
                      child: Container(
                        width: width,
                        height: 50,
                        decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.add_circled),
                              SizedBox(width: 10),
                              Text(
                                "Aggiungi Struttura",
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity:  openContainer[index] == false ? 0 : 1,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: AnimatedContainer(
                              padding: EdgeInsets.only(left: width*.2,top: height*.05),
                              duration: Duration(milliseconds: 100),
                              width: width,
                              height: openContainer[index] == false ? 65 : 140,
                              child:  FirebaseAnimatedList(
                                              query: ref,
                                              itemBuilder: (context, snapshot, animation, index) {
                                                Map restaurant = snapshot.value as Map;
                                                restaurant['key'] = snapshot.key;
                                        
                                                return Row(
                                                  children: [
                                                    Icon(Icons.circle,size: 7,),
                                                    SizedBox(width: 5),
                                                    Text(restaurant['name'])
                                                  ],
                                                );
                                              }),
                                        
                            ),
                          ),
                        )*/

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Example"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Main Menu"),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("Item 1"),
              onTap: () {
                // Handle the selection
              },
            ),
            ListTile(
              title: Text("Item 2"),
              onTap: () {
                // Handle the selection
              },
            ),
            ExpansionTile(
              title: Text("Submenu"),
              children: <Widget>[
                ListTile(
                  title: Text("Submenu Item 1"),
                  onTap: () {
                    // Handle the selection
                  },
                ),
                ListTile(
                  title: Text("Submenu Item 2"),
                  onTap: () {
                    // Handle the selection
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
