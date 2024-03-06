/*import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ichiani_flutter/Screen/Cart/cart.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Cart/prodotti_item_it.dart';
import '../bloc/cartlistBloc.dart';
import '../Cart/ListWelness.dart';

class OrderPage extends StatelessWidget {
  OrderPage({Key? key}) : super(key: key);
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.black
            : Color.fromRGBO(239, 238, 243, 1);
    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;


    final background2 =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> _prodottiStream =
        AppLocalizations.of(context)!.language == "Italiano"
            ? FirebaseFirestore.instance.collection('servizi').snapshots()
            : FirebaseFirestore.instance.collection('services').snapshots();

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.servizi,
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      Expanded(child: Container()),
                      CupertinoButton(
                        onPressed: () {
                          launch("tel://+393456046302");
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .verifica_la_disponibilita,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      /*ElevatedButton(
                        onPressed: () {
                          launch("tel://+393456046302");
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .verifica_la_disponibilita,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: background,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(13),
                          primary: buttonColor,
                        ),
                      ),*/
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.20),
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                ),
                              ],
                              color: background2,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListWelness()),
                                );
                              },
                              subtitle: Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: textColor),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              title: Text(
                                AppLocalizations.of(context)!.well,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                              /*leading: CircleAvatar(backgroundImage: AssetImage("lib/background/coop.PNG")),*/
                              trailing: Icon(
                                Icons.arrow_forward,
                                color: textColor,
                                size: 30,
                              )),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _prodottiStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    AppLocalizations.of(context)!.errorNet));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Text(
                                    AppLocalizations.of(context)!.loadingNet));
                          }

                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.20),
                                          blurRadius: 30,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                      color: background2,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: ListTile(
                                    subtitle: Text(
                                      "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          color: textColor),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 20),
                                    title: Text(
                                      "${data['nome']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor),
                                    ),
                                    trailing: Icon(
                                      data['tipo'] == "bici"
                                          ? Icons.pedal_bike
                                          : data['tipo'] == "ncc"
                                              ? CupertinoIcons.person
                                              : data['tipo'] == "water"
                                                  ? Icons.water
                                                  : data['tipo'] == "barca"
                                                      ? Icons.map
                                                      : data['tipo'] == "car"
                                                          ? CupertinoIcons
                                                              .car_detailed
                                                          : data['tipo'] ==
                                                                  "yoga"
                                                              ? Icons
                                                                  .fitness_center
                                                              : Icons.abc,
                                      color: textColor,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  ItemContainer({
    required this.foodItem,
  });

  final ProdottiItem foodItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(ProdottiItem foodItem) {
    bloc.addToList(foodItem);
    print(foodItem.name);
  }

  removeFromList(ProdottiItem foodItem) {
    bloc.removeFromList(foodItem);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //addToCart(foodItem);
        //print("${foodItem.title}");
        final snackBar = SnackBar(
          content: Text('${foodItem.name} added to Cart'),
          duration: Duration(milliseconds: 550),
        );

        //Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Items(
          itemName: foodItem.name,
          itemPrice: foodItem.price,
          leftAligned: (foodItem.id % 2) == 0 ? true : false,
          foodItem: foodItem),
    );
  }
}

class Items extends StatelessWidget {
  Items(
      {required this.leftAligned,
      required this.itemName,
      required this.itemPrice,
      required this.foodItem});

  final bool leftAligned;
  final ProdottiItem foodItem;
  final String itemName;
  final int itemPrice;

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(ProdottiItem foodItem) {
    bloc.addToList(foodItem);
    print(foodItem.name);
  }

  removeFromList(ProdottiItem foodItem) {
    bloc.removeFromList(foodItem);
  }

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

    double containerPadding = 45;
    double containerBorderRadius = 10;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            color: background.withOpacity(0.9),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: ListTile(
          subtitle: Text(
            'EUR ' + '${itemPrice}',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 11, color: textColor),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          title: Text(
            itemName,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          trailing: CupertinoButton(
            child: Icon(CupertinoIcons.cart_badge_plus),
            onPressed: () {
              addToCart(foodItem);
            },
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          StreamBuilder(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = (snapshot.data as List<ProdottiItem>);
                List<ProdottiItem> prodottiItems = data;
                int length = prodottiItems != null ? prodottiItems.length : 0;

                return buildGestureDetector(length, context, prodottiItems);
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int length, BuildContext context, List<ProdottiItem> prodottiItems) {
    return GestureDetector(
        onTap: () {
          if (length > 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Cart()));
          } else {
            return;
          }
        },
        child: Stack(
          children: [
            Icon(
              CupertinoIcons.cart_fill,
              size: 28,
            ),
            Positioned(
                top: 4,
                right: 10,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Text(length.toString()),
                ))
          ],
        )
        /* Container(
        margin: EdgeInsets.only(right: 30),
        child: Text(length.toString()),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.yellow[800], borderRadius: BorderRadius.circular(50)),
      ),*/
        );
  }
}
*/