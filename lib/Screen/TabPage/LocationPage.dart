import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:near_me/data/dataAlimentari.dart';
import 'package:near_me/data/dataRistoranti.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';
import 'package:open_settings/open_settings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/dataAttività.dart';
import '../../data/dataBenzine.dart';
import '../../data/dataShopping.dart';
import '../DetailsView/presentation/iphone_14_one_screen/DetailsViewLuoghi.dart';

class LocationPage extends StatefulWidget {
  LocationPage({Key? key}) : super(key: key);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  State<LocationPage> createState() => _LocationPageState();
  Position? _currentUserPosition;
  double? distanceInMeters = 0.0;

  double? distanceInKm = 0.0;
  DataRistoranti dataRistoranti = DataRistoranti();
  DataShopping dataShopping = DataShopping();
  DataBenzine dataBenzine = DataBenzine();
  DataAttivita dataAttivita = DataAttivita();
  DataAlimentari dataAlimentari = DataAlimentari();

  Future _getTheDistance() async {
    bool serviceEnabled;
    LocationPermission permission;
    bool permesso;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permesso = serviceEnabled;
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openLocationSettings;
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    _currentUserPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //POSIZIONE RISTORANTI
    for (int i = 0; i < dataRistoranti.allRistoranti.length; i++) {
      double storelat = dataRistoranti.allRistoranti[i]['lat'];
      double storelong = dataRistoranti.allRistoranti[i]['long'];

      distanceInMeters = await Geolocator.distanceBetween(_currentUserPosition!.latitude, _currentUserPosition!.longitude, storelat, storelong);

      var distance = distanceInMeters?.round().toInt();

      var distance2 = (distance! / 1000);

      dataRistoranti.allRistoranti[i]['distance'] = distance2.toStringAsFixed(1);

      setState(() {});
    }

    //POSIZIONE BENZINE
    for (int i = 0; i < dataBenzine.allBenzine.length; i++) {
      double storelat = dataBenzine.allBenzine[i]['lat'];
      double storelong = dataBenzine.allBenzine[i]['long'];

      distanceInMeters = await Geolocator.distanceBetween(_currentUserPosition!.latitude, _currentUserPosition!.longitude, storelat, storelong);

      var distance = distanceInMeters?.round().toInt();

      var distance2 = (distance! / 1000);
      dataBenzine.allBenzine[i]['distance'] = distance2.toStringAsFixed(1);
      setState(() {});
    }

    //ALIMENTARI BENZINE
    for (int i = 0; i < dataAlimentari.allAlimentari.length; i++) {
      double storelat = dataAlimentari.allAlimentari[i]['lat'];
      double storelong = dataAlimentari.allAlimentari[i]['long'];

      distanceInMeters = await Geolocator.distanceBetween(_currentUserPosition!.latitude, _currentUserPosition!.longitude, storelat, storelong);

      var distance = distanceInMeters?.round().toInt();

      var distance2 = (distance! / 1000);
      dataAlimentari.allAlimentari[i]['distance'] = distance2.toStringAsFixed(1);
      setState(() {});
    }

    //SHOPPING BENZINE
    for (int i = 0; i < dataShopping.allShopping.length; i++) {
      double storelat = dataShopping.allShopping[i]['lat'];
      double storelong = dataShopping.allShopping[i]['long'];

      distanceInMeters = await Geolocator.distanceBetween(_currentUserPosition!.latitude, _currentUserPosition!.longitude, storelat, storelong);

      var distance = distanceInMeters?.round().toInt();

      var distance2 = (distance! / 1000);
      dataShopping.allShopping[i]['distance'] = distance2.toStringAsFixed(1);
      setState(() {});
    }

    return await Geolocator.getCurrentPosition();
  }



  void initState() {
    //_getTheDistance();
    super.initState();
  }

  //refresh
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    setState(() {});
    _refreshController.loadComplete();
  }

//(context as Element).reassemble();
  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final backgroundCard =
        MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(235, 15, 15, 15) : Color.fromARGB(207, 255, 255, 255);
    final background2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;
    final textColorCard = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 20, 20, 20) : Colors.white;

    bool permesso;
    if (distanceInMeters == 0) {
      permesso = false;
    } else {
      permesso = true;
    }
    ;
    RefreshController _refreshController = RefreshController(initialRefresh: false);

    void _onRefresh() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      print('refresh');
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      print('loading');

      _refreshController.loadComplete();
    }
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    SystemChrome.setSystemUIOverlayStyle(
        MediaQuery.of(context).platformBrightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark); // 1
    double displayWidth = MediaQuery.of(context).size.width;
    final Stream<QuerySnapshot> _ristorantiStream = FirebaseFirestore.instance.collection('ristoranti').snapshots();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        top: true,
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(),
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.dove_andare,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: textColor)),
                              Expanded(child: Container()),
                              CupertinoButton(child: Icon(CupertinoIcons.refresh), onPressed: () {}),
                              if (permesso != true)
                                (ElevatedButton(
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                  child: const Icon(Icons.near_me, color: Colors.white, size: 22),
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.white,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(11),

                                  ),
                                )),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.ristoranti_e_pizzerie,
                                      style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                                child: Container(
                                    height: 150,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: _ristorantiStream,
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return new Text('Loading...');
                                          default:
                                            return PageView.builder(
                                                // Changes begin here
                                                clipBehavior: Clip.antiAlias,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: snapshot.data!.docs.length,
                                                itemBuilder: (context, position) {
                                                  final data = snapshot.data!.docs[position];


                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            fullscreenDialog: true,
                                                            builder: (context) => DetailScreenLuoghi(
                                                                  photos: data['photos'],
                                                                  categories: 'ristoranti',
                                                                  nome: data['nameOfPlace'],
                                                                  phone: '',
                                                                  url: data['website']!=null?data['website']:'',
                                                                  distanza: '',
                                                                  descrizione: '', weekDay: [], indirizzo: data['indirizzo'],
                                                                )),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      child: Container(
                                                        height: 100,
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                          color: background,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 10, top: 20, bottom: 0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                      padding: const EdgeInsets.only(left: 15),
                                                                      child: Expanded(
                                                                        child: new Container(
                                                                          width: width * 0.48,
                                                                          padding: new EdgeInsets.only(right: 13.0),
                                                                          child: Text(data['nameOfPlace'],
                                                                              overflow: TextOverflow.clip,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.bold, fontSize: 15, color: textColorCard)),
                                                                        ),
                                                                      )),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                                                    child: Text(
                                                                      " Km",
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.blueAccent,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  /*CupertinoButton(
                                                                      child: Container(
                                                                          width: displayWidth * 0.45,
                                                                          height: 30,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                              color: Colors.blueAccent),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                AppLocalizations.of(context)!.vai_button,
                                                                                style: TextStyle(
                                                                                    color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                      onPressed: () async {
                                                                        String textForLink = '';

                                                                        setState(() {
                                                                          textForLink = data['nameOfPlace'].replaceAll(' ', '+');
                                                                        });
                                                                        bool mappeLaunch = false;
                                                                        bool googleMapsLaunch = false;

                                                                        if (await canLaunch('https://maps.apple.com/?q=$textForLink')) {
                                                                          setState(() {
                                                                            mappeLaunch = true;
                                                                          });
                                                                        }
                                                                        if (await canLaunch('comgooglemaps://?q=$textForLink')) {
                                                                          setState(() {
                                                                            googleMapsLaunch = true;
                                                                          });
                                                                        }

                                                                        showCupertinoModalPopup(
                                                                          context: _scaffoldKey.currentContext!,
                                                                          builder: (context) => CupertinoActionSheet(
                                                                            cancelButton: CupertinoActionSheetAction(
                                                                              /// This parameter indicates the action would be a default
                                                                              /// defualt behavior, turns the action's text to bold text.
                                                                              isDefaultAction: true,
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text(
                                                                                'Cancel',
                                                                                style: TextStyle(fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                            actions: [
                                                                              Visibility(
                                                                                visible: mappeLaunch,
                                                                                child: Container(
                                                                                  color: Colors.white,
                                                                                  child: CupertinoActionSheetAction(
                                                                                    onPressed: () {
                                                                                      launch('https://maps.apple.com/?q=$textForLink');
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Text(
                                                                                      'Open with Mappe',
                                                                                      style: TextStyle(fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                visible: googleMapsLaunch,
                                                                                child: Container(
                                                                                  color: Colors.white,
                                                                                  child: CupertinoActionSheetAction(
                                                                                    onPressed: () {
                                                                                      launch('comgooglemaps://?q=$textForLink');
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Text(
                                                                                      'Open with Google Maps',
                                                                                      style: TextStyle(fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );

                                                                        await FirebaseAnalytics.instance.logEvent(
                                                                          name: "indicazioni_ristorante",
                                                                          parameters: {
                                                                            "restaurant_name": data['nameOfPlace'],
                                                                          },
                                                                        );
                                                                      })*/
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            AspectRatio(
                                                              aspectRatio: 80 / 80,
                                                              child: Container(
                                                                child: Image.network(
                                                                  data['photos'][0],
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                        }
                                      },
                                    )),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: background2),
                        ),
                        SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(color: background2, borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.dove_rifornirsi,
                                        style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0, bottom: 15),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.13,
                                    child: ListView.builder(
                                        clipBehavior: Clip.antiAlias,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: dataBenzine.allBenzine.length,
                                        itemBuilder: (context, index) {
                                          dataBenzine.allBenzine.sort((a, b) => a["distance"].compareTo(b["distance"]));
                                          return GestureDetector(
                                            onTap: (() {
                                              var url = "${dataBenzine.allBenzine[index]['link']}";
                                              launch(url);
                                            }),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Icon(
                                                          Icons.electric_car,
                                                          size: 40,
                                                        ),
                                                        Expanded(child: Container()),
                                                        Text(dataBenzine.allBenzine[index]['name'],
                                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                        Row(
                                                          children: [
                                                            Text("${dataBenzine.allBenzine[index]['distance']} km",
                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                            Expanded(child: Container()),
                                                          ],
                                                        ),
                                                        Expanded(child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [Color.fromARGB(255, 31, 150, 248), Color.fromARGB(255, 15, 69, 112)],
                                                    ),
                                                    borderRadius: BorderRadius.circular(15),
                                                  )),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            )
                            /*ListView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            children: [
                              CardRifornimento(title: "$distanceInMeters km"),
                              CardRifornimento(title: "$distanceInMeters km"),
                              CardRifornimento(title: "$distanceInMeters km"),
                              CardRifornimento(title: "$distanceInMeters km"),
                            ],
                          ),*/
                            ),
                        SizedBox(height: 20),
                        Container(
                            //height: 150,
                            decoration: BoxDecoration(color: background2, borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.alimentari,
                                            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.14,
                                  child: ListView.builder(
                                      clipBehavior: Clip.antiAlias,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dataAlimentari.allAlimentari.length,
                                      itemBuilder: (context, index) {
                                        dataAlimentari.allAlimentari.sort((a, b) => a["distance"].compareTo(b["distance"]));
                                        return GestureDetector(
                                          onTap: (() {
                                            var url = "${dataAlimentari.allAlimentari[index]['link']}";
                                            launch(url);
                                          }),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15, bottom: 15),
                                            child: Container(
                                                height: 100,
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Icon(
                                                        Icons.shopping_basket,
                                                        size: 40,
                                                      ),
                                                      Expanded(child: Container()),
                                                      Text(dataAlimentari.allAlimentari[index]['name'],
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                      Row(
                                                        children: [
                                                          Text("${dataAlimentari.allAlimentari[index]['distance']} km",
                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                          Expanded(child: Container()),
                                                        ],
                                                      ),
                                                      Expanded(child: Container()),
                                                      SizedBox(height: 10)
                                                    ],
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color.fromARGB(255, 245, 102, 13),
                                                      Color.fromARGB(255, 222, 14, 14),
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(15),
                                                )),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            )

                            /*ListView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            children: [
                              CardAlimentari(title: "$distanceInMeters km"),
                              CardAlimentari(title: "$distanceInMeters km"),
                              CardAlimentari(title: "$distanceInMeters km"),
                              CardAlimentari(title: "$distanceInMeters km"),
                            ],
                          ),*/
                            ),
                        SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(color: background2, borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.shopping,
                                            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.14,
                                    child: ListView.builder(
                                        clipBehavior: Clip.antiAlias,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: dataShopping.allShopping.length,
                                        itemBuilder: (context, index) {
                                          dataShopping.allShopping.sort((a, b) => a["distance"].compareTo(b["distance"]));
                                          return GestureDetector(
                                            onTap: (() {
                                              var url = "${dataShopping.allShopping[index]['link']}";
                                              launch(url);
                                            }),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Container(
                                                  height: 100,
                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Icon(
                                                          Icons.shopping_bag,
                                                          size: 40,
                                                        ),
                                                        Expanded(child: Container()),
                                                        Text(dataShopping.allShopping[index]['name'],
                                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                        Row(
                                                          children: [
                                                            Text("${dataShopping.allShopping[index]['distance']} km",
                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                            Expanded(child: Container()),
                                                          ],
                                                        ),
                                                        Expanded(child: Container()),
                                                      ],
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        Color.fromARGB(255, 255, 247, 0),
                                                        Color.fromARGB(255, 211, 181, 7),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
                                                  )),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 100)
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initPlatformState() {}
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    style: ElevatedButton.styleFrom(),
    child: const Text("Non adesso"),
    onPressed: () => Navigator.pop(context, true),
  );

  Widget continueButton = ElevatedButton(
    style: ElevatedButton.styleFrom(),
    child: const Text("Apri Impostazioni"),
    onPressed: () {
      OpenSettings.openWIFISetting();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    buttonPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    contentPadding: const EdgeInsets.all(23),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: const Text("Attiva Localizzazione"),
    content: const Text(
        "Se desideri sapere la distanza, devi attivare i servizi di localizzazione per questa applicazione. \n\nImpostazioni > Privacy > Servizi di Localizzazione"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/*class CardRistoranti extends StatelessWidget {
  CardRistoranti({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  DataRistoranti data = DataRistoranti();

  get index => null;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        print("Tupped");
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black)),
                            Text(title)
                          ],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: const Radius.circular(20.0),
                            bottomRight: const Radius.circular(20.0),
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
                  bottomLeft: const Radius.circular(25),
                  bottomRight: const Radius.circular(25),
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
              image: const DecorationImage(
                  image: const AssetImage("assets/ristorante.jpg"),
                  fit: BoxFit.cover),
            )),
      ),
    );
  }
}*/

/*class CardRifornimento extends StatelessWidget {
  const CardRifornimento({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        print("Tupped");
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  const Icon(
                    Icons.electric_car,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text("E-Charge",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10))
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 31, 150, 248),
                  Color.fromARGB(255, 15, 69, 112)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 9.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0, 7), // shadow direction: bottom right
                )
              ],
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }
}*/

class CardAlimentari extends StatelessWidget {
  const CardAlimentari({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        print("Tupped");
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  const Icon(
                    Icons.electric_car,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text("E-Charge", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 49, 248, 31),
                  Color.fromARGB(255, 29, 87, 24),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 9.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0, 7), // shadow direction: bottom right
                )
              ],
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    num mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
