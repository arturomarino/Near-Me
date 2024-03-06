import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/ScriviRecensione.dart';


class RecensioniPage extends StatefulWidget {
  const RecensioniPage({Key? key}) : super(key: key);

  @override
  _RecensioniPageState createState() => _RecensioniPageState();
}

class _RecensioniPageState extends State<RecensioniPage> {
  final Stream<QuerySnapshot> _prodottiStream =
      FirebaseFirestore.instance.collection('recensioni').snapshots();

  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  int index = 0;
  final valuestar = ['-', '5', '4.5', '4', '3.5', '3', '2.5'];

  final DateTime now1 = DateTime.now();
  DateFormat formatterDatePickerIdeal = DateFormat('dd/MM/yyyy');
  late String formattedDatePickerIdeal = formatterDatePickerIdeal.format(now1);

  final LinearGradient gradient1 = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 255, 156, 160),
      Color.fromARGB(255, 255, 207, 239)
    ],
  );

  final LinearGradient gradient2 = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 255, 236, 210),
      Color.fromARGB(255, 253, 184, 161)
    ],
  );

  final LinearGradient gradient3 = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 162, 197, 254),
      Color.fromARGB(255, 194, 233, 252)
    ],
  );
  final LinearGradient gradient4 = LinearGradient(
    colors: <Color>[
      Color.fromARGB(150, 255, 0, 225),
      Color.fromARGB(150, 7, 19, 237)
    ],
  );
  final Shader textGradient = LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 255, 0, 225),
      Color.fromARGB(197, 7, 19, 237)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  bool up = false;
  bool down = false;
  String name = "";
  String paese = "";
  String title = "";
  String mess = "";





  @override
  Widget build(BuildContext context) {
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(198, 54, 51, 51)
            : Colors.white;
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;

    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    CupertinoButton(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: textColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dicono,
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = textGradient),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _prodottiStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(AppLocalizations.of(context)!.errorNet));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              Text(AppLocalizations.of(context)!.loadingNet));
                    }

                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: GestureDetector(
                            onDoubleTap: () {
                              
                              if(data['like'][currentUser]!=true){
                                                  FirebaseFirestore.instance
                                                    .collection('recensioni')
                                                    .doc(document.id)
                                                    .update({
                                                  'like.$currentUser': true
                                                });
                                                FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'likeCounter':
                                                        data['likeCounter'] + 1,
                                                    'dislikeCounter': data[
                                                                'dislikeCounter'] ==
                                                            0
                                                        ? data['dislikeCounter'] -
                                                            0
                                                        : data['dislikeCounter'] -
                                                            1
                                                  });
                                                }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.20),
                                        blurRadius: 30,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                    gradient: data['color'] == "arancione"
                                        ? gradient2
                                        : data['color'] == 'blu'
                                            ? gradient3
                                            : gradient1,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: NetworkImage(data[
                                                        'image'] ==
                                                    ""
                                                ? "https://firebasestorage.googleapis.com/v0/b/ichiani-flutter.appspot.com/o/userImage%2FiOS%20icon%20person.jpeg?alt=media&token=c7185158-8b31-42f7-892e-fef03a8ff150"
                                                : data['image']),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['cliente'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Row(
                                                children: [
                                                  Text(data['rating'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15)),
                                                  SizedBox(width: 3),
                                                  Icon(
                                                    CupertinoIcons.star_fill,
                                                    color: Colors.black,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Expanded(child: Container()),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                data['date'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                              ),
                                              Text(data['location'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Colors.black
                                                          .withOpacity(0.5))),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      /*Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                data['cliente'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                              Expanded(child: Container()),
                                              Text(
                                                data['date'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black
                                                        .withOpacity(0.5)),
                                              )
                                            ],
                                          ),
                                          Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(data['rating'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),
                                          SizedBox(width: 3),
                                          Icon(
                                            CupertinoIcons.star_fill,
                                            color: Colors.black,
                                            size: 13,
                                          ),
                                          Expanded(child: Container()),
                                          Text(data['location'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(0.5)))
                                        ],
                                      ),
                                        ],
                                      ),*/

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              data['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              data['subtitle'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CupertinoButton(
                                              onPressed: () {
                                                if (data['like'][currentUser] !=
                                                    true) {
                                                  FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'like.$currentUser': true
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'likeCounter':
                                                        data['likeCounter'] + 1,
                                                    'dislikeCounter': data[
                                                                'dislikeCounter'] ==
                                                            0
                                                        ? data['dislikeCounter'] -
                                                            0
                                                        : data['dislikeCounter'] -
                                                            1
                                                  });
                                                } else if (data['like']
                                                        [currentUser] ==
                                                    true) {
                                                  FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'like.$currentUser': false
                                                  });

                                                  FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'likeCounter':
                                                        data['likeCounter'] - 1,
                                                    'dislikeCounter': data[
                                                                'dislikeCounter'] ==
                                                            0
                                                        ? data['dislikeCounter'] -
                                                            0
                                                        : data['dislikeCounter'] -
                                                            1
                                                  });
                                                }
                                                /*FirebaseFirestore.instance
                                                    .collection('recensioni')
                                                    .doc(document.id)
                                                    .update({
                                                  'like.$currentUser': true
                                                });
                          
                                                if (data['like'][currentUser] !=
                                                    true) {
                                                  FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'likeCounter':
                                                        data['likeCounter'] + 1,
                                                    'dislikeCounter': data[
                                                                'dislikeCounter'] ==
                                                            0
                                                        ? data['dislikeCounter'] -
                                                            0
                                                        : data['dislikeCounter'] -
                                                            1
                                                  });
                                                }
                          
                                                if(data['like.$currentUser']==true){
                                                  FirebaseFirestore.instance
                                                    .collection('recensioni')
                                                    .doc(document.id)
                                                    .update({
                                                  'like.$currentUser': false
                                                });
                                                }*/
                                              },
                                              child: Icon(
                                                data['like']['$currentUser'] !=
                                                        true
                                                    ? CupertinoIcons.heart
                                                    : CupertinoIcons.heart_fill,
                                                color: data['like']
                                                            ['$currentUser'] !=
                                                        true
                                                    ? Colors.black
                                                    : Colors.red,
                                                size: data['like']
                                                            ['$currentUser'] !=
                                                        true
                                                    ? 15
                                                    : 22,
                                              )),
                                          Expanded(
                                              child: Text(data['likeCounter']
                                                  .toString())),
                                          /*CupertinoButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('recensioni')
                                                    .doc(document.id)
                                                    .update({
                                                  'like.$currentUser': false
                                                });
                          
                                                if (down == false) {
                                                  FirebaseFirestore.instance
                                                      .collection('recensioni')
                                                      .doc(document.id)
                                                      .update({
                                                    'dislikeCounter':
                                                        data['dislikeCounter'] +
                                                            1,
                                                    'likeCounter': data[
                                                                'likeCounter'] ==
                                                            0
                                                        ? data['likeCounter'] - 0
                                                        : data['likeCounter'] - 1
                                                  });
                                                }
                          
                                                setState(() {
                                                  down = true;
                                                  up = false;
                                                });
                                              },
                                              child: Icon(
                                                data['like']['$currentUser'] ==
                                                        true
                                                    ? CupertinoIcons
                                                        .hand_thumbsdown
                                                    : data['like'][
                                                                '$currentUser'] ==
                                                            null
                                                        ? CupertinoIcons
                                                            .hand_thumbsdown
                                                        : CupertinoIcons
                                                            .hand_thumbsdown_fill,
                                                color: Colors.black,
                                              ))*/
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScriviRecensione()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(AppLocalizations.of(context)!.lascia,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = textGradient)),
                        SizedBox(
                          width: 5,
                        ),
                        LinearGradientMask(
                          child: Icon(
                            CupertinoIcons.star_fill,
                            size: 22,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          )),
    );
  }
}

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 0, 225),
            Color.fromARGB(197, 7, 19, 237)
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
