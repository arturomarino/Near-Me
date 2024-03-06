import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../DetailsView/presentation/iphone_14_one_screen/DetailsViewLuoghi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database_platform_interface/src/transaction.dart' as db_transaction;

class HomeButtonPage extends StatefulWidget {
  final String structure;
  const HomeButtonPage({Key? key, required this.structure}) : super(key: key);

  @override
  State<HomeButtonPage> createState() => _HomeButtonPageState();
}

class _HomeButtonPageState extends State<HomeButtonPage> {
  String structureSelected = 'iChiani';
  final Stream<QuerySnapshot> _ristorantiStream = FirebaseFirestore.instance.collection('ristoranti').snapshots();
  int currentIndex = 0;

  List<IconData> icons = [Icons.restaurant, Icons.beach_access, Icons.ev_station, Icons.shopping_bag, Icons.local_cafe, Icons.nightlife];

  List<String> categoriesList = ['Ristoranti', 'Spiagge', 'Charge', 'Shop', 'Bar', 'Discoteche'];

  late PageController controller;
  late PageController controller2;

  @override
  void initState() {
    controller = PageController(initialPage: currentIndex);
    controller2 = PageController(keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  void addData(String parameter) async {
    DateTime now = DateTime.now();

    // Formatta la data con il formato "monda"
    String formattedDate = DateFormat('EEE', 'en_US').format(now).toUpperCase();
    DatabaseReference dataRef = FirebaseDatabase.instance.ref("structure/${widget.structure}");
    DatabaseReference dataAnalytics = dataRef.child('placeAnalytics/$parameter');

    await dataAnalytics.update({'count': 1, 'nameOfPlace': parameter.trim()});
  }

  void _updateAnalytics(String parameter) async {
    DateTime now = DateTime.now();

    // Formatta la data con il formato "monda"
    String formattedDate = DateFormat('EEE', 'en_US').format(now).toUpperCase();
    //print(formattedDate);

    DatabaseReference dataRef = FirebaseDatabase.instance.ref("structure/${widget.structure}/placeAnalytics/$parameter");

    TransactionResult result = await dataRef.runTransaction((Object? data) {
      // Ensure a post at the ref exists.
      if (data == null) {
        addData(parameter);
        return db_transaction.Transaction.abort();
      }

      Map<String, dynamic> _data = Map<String, dynamic>.from(data as Map);
      if (_data["count"] != null) {
        _data["count"] = _data["count"] + 1;
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
    final textColorCard = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final cardColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    final blueColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 16, 70, 114) : Color.fromARGB(255, 29, 134, 219);
    List<DatabaseReference> refs = [
      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/ristoranti'),
      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/spiagge'),
      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/charge'),
      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/shop'),
      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/bar'),
      FirebaseDatabase.instance.ref().child('structure/${widget.structure}/disco'),
    ];

    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: textColor,
          backgroundColor: background,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 15,top: 10),
                    child: Text('Esplora', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 28)),
                  ),
                  Container(
                    width: width,
                    height: 23,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 8);
                      },
                      itemBuilder: (context, index) {
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              currentIndex = index;
                            });
                            controller.animateToPage(currentIndex, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          },
                          pressedOpacity: 0.8,
                          child: Container(
                              decoration: BoxDecoration(color:currentIndex == index ? Colors.blue : Colors.blue[300] , borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    categoriesList[index],
                                    style: TextStyle(color: currentIndex == index ? Colors.white : Colors.white54, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 25),
                        child: PageView.builder(
                          itemCount: refs.length,
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FirebaseAnimatedList(
                                query: refs[index],
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, snapshot, animation, index) {
                                  Map data = snapshot.value as Map;
                                  data['key'] = snapshot.key;
                  
                                  if (currentIndex == 2) {
                                    return GestureDetector(
                                      onTap: () async {
                                        await FirebaseAnalytics.instance.logEvent(name: 'restaurant_pressed');
                                        _updateAnalytics(data['name']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) => DetailScreenLuoghi(
                                                    photos: data['photos'],
                                                    categories: categoriesList[currentIndex],
                                                    nome: data['name'],
                                                    phone: '',
                                                    url: data['website'] != null ? data['website'] : '',
                                                    distanza: '',
                                                    descrizione: '',
                                                    weekDay: [],
                                                    indirizzo: data['indirizzo'],
                                                  )),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                        child: Container(
                                          height: height * 0.19,
                                          width: width,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: cardColor,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 25, top: 25),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: new Container(
                                                        width: width * 0.48,
                                                        padding: new EdgeInsets.only(right: 13.0),
                                                        child: Text(data['name'],
                                                            overflow: TextOverflow.clip,
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColorCard)),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Container(
                                                        padding: new EdgeInsets.only(right: 13.0),
                                                        child: Text(
                                                          data['indirizzo'].length > 50 ? data['indirizzo'].substring(0, 50) + '...' : data['indirizzo'],
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons.map_pin_ellipse,
                                                            size: 15,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            " Km da te",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 25),
                                                child: Container(
                                                  child: Image.asset('assets/electric-car.png'),
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () async{
                                      await FirebaseAnalytics.instance.logEvent(name: 'restaurant_pressed');
                                        _updateAnalytics(data['name']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) => DetailScreenLuoghi(
                                                  photos: data['photos'],
                                                  categories: categoriesList[currentIndex],
                                                  nome: data['name'],
                                                  phone: '',
                                                  url: data['website'] != null ? data['website'] : '',
                                                  distanza: '',
                                                  descrizione: '',
                                                  weekDay: data['weekDay'] != null ? data['weekDay'] : [],
                                                  indirizzo: data['indirizzo'],
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                        height: height * .25,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Stack(
                                            children: [
                                              PageView.builder(
                                                  controller: controller2,
                                                  scrollDirection: Axis.horizontal,
                                                  physics: ClampingScrollPhysics(),
                                                  itemCount: data['photos'].length,
                                                  itemBuilder: (context, index) {
                                                    return ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.network(
                                                        data['photos'][index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  }),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SmoothPageIndicator(
                                                          controller: controller2,
                                                          count: data['photos'].length,
                                                          effect: ScrollingDotsEffect(
                                                              dotHeight: 3, dotWidth: 10, dotColor: Colors.grey, activeDotColor: Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Expanded(
                                                    child: Container(
                                                      //height: height * .07,
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: cardColor,
                                                      ),
                                                      child: new Container(
                                                        width: width,
                                                        padding: new EdgeInsets.only(right: 13.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(data['name'],
                                                                overflow: TextOverflow.clip,
                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColorCard)),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    data['indirizzo'].length > 60
                                                                        ? data['indirizzo'].substring(0, 60) + '...'
                                                                        : data['indirizzo'],
                                                                    style: TextStyle(
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    CupertinoIcons.map_pin_ellipse,
                                                                    size: 15,
                                                                    color: Colors.grey,
                                                                  ),
                                                                  SizedBox(width: 5),
                                                                  Text(
                                                                    " Km da te",
                                                                    style: TextStyle(
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        )),
                  )
                ],
              ),
            ),
          ),
        ));

    /* Scrollbar(
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverAppBar.medium(
              elevation: 0,
              backgroundColor: blueColor,
              title: Text(
                "Esplora",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: blueColor,
                height: height * .07,
                child: ListView.builder(
                    itemCount: icons.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CupertinoButton(
                          child: Container(
                              child: Row(
                            children: [
                              Icon(
                                icons[index],
                                color: currentIndex == index ? Colors.white : Colors.grey,
                                size: 18,
                              ),
                              SizedBox(width: 5),
                              Text(
                                text[index],
                                style:
                                    TextStyle(color: currentIndex == index ? Colors.white : Colors.grey, fontWeight: FontWeight.w800, fontSize: 13),
                              )
                            ],
                          )),
                          onPressed: () {
                            setState(() {
                              currentIndex = index;
                            });
                            controller.animateToPage(currentIndex, duration: Duration(milliseconds: 300), curve: Curves.linear);
                          });
                    }),
              ),
            ),
            SliverFillRemaining(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 5),
                    child: PageView.builder(
                      itemCount: refs.length,
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FirebaseAnimatedList(
                            query: refs[index],
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, snapshot, animation, index) {
                              Map data = snapshot.value as Map;
                              data['key'] = snapshot.key;

                              if (currentIndex == 2) {
                                return GestureDetector(
                                  onTap: () async {
                                    await FirebaseAnalytics.instance.logEvent(name: 'restaurant_pressed');
                                    _updateAnalytics(data['name']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => DetailScreenLuoghi(
                                                photos: data['photos'],
                                                categories: text[currentIndex],
                                                nome: data['name'],
                                                phone: '',
                                                url: data['website'] != null ? data['website'] : '',
                                                distanza: '',
                                                descrizione: '',
                                                weekDay: [],
                                                indirizzo: data['indirizzo'],
                                              )),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    child: Container(
                                      height: height * 0.19,
                                      width: width,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: cardColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 25, top: 25),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: new Container(
                                                    width: width * 0.48,
                                                    padding: new EdgeInsets.only(right: 13.0),
                                                    child: Text(data['name'],
                                                        overflow: TextOverflow.clip,
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColorCard)),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: new Container(
                                                    padding: new EdgeInsets.only(right: 13.0),
                                                    child: Text(
                                                      data['indirizzo'].length > 50 ? data['indirizzo'].substring(0, 50) + '...' : data['indirizzo'],
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons.map_pin_ellipse,
                                                        size: 15,
                                                        color: Colors.grey,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        " Km da te",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 25),
                                            child: Container(
                                              child: Image.asset('assets/electric-car.png'),
                                              width: 50,
                                              height: 50,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: () async{
                                  await FirebaseAnalytics.instance.logEvent(name: 'restaurant_pressed');
                                    _updateAnalytics(data['name']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => DetailScreenLuoghi(
                                              photos: data['photos'],
                                              categories: text[currentIndex],
                                              nome: data['name'],
                                              phone: '',
                                              url: data['website'] != null ? data['website'] : '',
                                              distanza: '',
                                              descrizione: '',
                                              weekDay: data['weekDay'] != null ? data['weekDay'] : [],
                                              indirizzo: data['indirizzo'],
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                    height: height * .25,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        children: [
                                          PageView.builder(
                                              controller: controller2,
                                              scrollDirection: Axis.horizontal,
                                              physics: ClampingScrollPhysics(),
                                              itemCount: data['photos'].length,
                                              itemBuilder: (context, index) {
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                    data['photos'][index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              }),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SmoothPageIndicator(
                                                      controller: controller2,
                                                      count: data['photos'].length,
                                                      effect: ScrollingDotsEffect(
                                                          dotHeight: 3, dotWidth: 10, dotColor: Colors.grey, activeDotColor: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                child: Container(
                                                  //height: height * .07,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: cardColor,
                                                  ),
                                                  child: new Container(
                                                    width: width,
                                                    padding: new EdgeInsets.only(right: 13.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(data['name'],
                                                            overflow: TextOverflow.clip,
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColorCard)),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                data['indirizzo'].length > 60
                                                                    ? data['indirizzo'].substring(0, 60) + '...'
                                                                    : data['indirizzo'],
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                CupertinoIcons.map_pin_ellipse,
                                                                size: 15,
                                                                color: Colors.grey,
                                                              ),
                                                              SizedBox(width: 5),
                                                              Text(
                                                                " Km da te",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    )))
          ],
        ),
      ),
    );*/
  }
}
