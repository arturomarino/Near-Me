/*import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/instance_manager.dart';
import 'package:http/io_client.dart';
import 'package:ichiani_flutter/Screen/Cart/cart.dart';
import 'package:ichiani_flutter/Screen/Cart/prodotti_item_En.dart';
import 'package:ichiani_flutter/Screen/bloc/cartlistBloc.dart';
import 'package:ichiani_flutter/Screen/Cart/prodotti_item_it.dart';
import 'package:url_launcher/url_launcher.dart';



class ListWelness extends StatefulWidget {
  const ListWelness({Key? key}) : super(key: key);

  @override
  State<ListWelness> createState() => _ListWelnessState();
}

class _ListWelnessState extends State<ListWelness> {
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

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> _prodottiStream =
        AppLocalizations.of(context)!.language == "English"
            ? FirebaseFirestore.instance.collection('wellness').snapshots()
            : FirebaseFirestore.instance.collection('benessere').snapshots();
    SystemChrome.setSystemUIOverlayStyle(
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: buttonColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: Text(AppLocalizations.of(context)!.well,
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Row(
                    children: [
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
                      Expanded(child: Container()),
                      CustomAppBar()
                    ],
                  ),
                ),
                
                for (var prodottiItem in prodottiItemsList.prodottiItems)
                  Builder(
                    builder: (context) {
                      return ItemContainer(prodottItem: prodottiItem);
                    },
                  ),
                /*ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(index: index);
                    }),
                CupertinoButton(
                    child: Text("Go to cart"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartProducts()),
                      );
                    }),*/

                /*StreamBuilder<QuerySnapshot>(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ListTile(
                              //trailing: CupertinoButton(child: Icon(CupertinoIcons.cart_badge_plus,size: 30,),onPressed: (){},),
                              subtitle: Text(
                                "${data['prezzo']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: textColor),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              title: Text(
                                "${data['nome']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),*/
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//ITALIANO
class ItemContainer extends StatelessWidget {
  ItemContainer({
    required this.prodottItem,
  });

  final ProdottiItem prodottItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(ProdottiItem prodottItem) {
    bloc.addToList(prodottItem);
    print(prodottItem.name);
  }

  removeFromList(ProdottiItem prodottItem) {
    bloc.removeFromList(prodottItem);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //addToCart(foodItem);
        //print("${foodItem.title}");
        final snackBar = SnackBar(
          content: Text(
              '${prodottItem.name} ${AppLocalizations.of(context)!.aggiunto}'),
          duration: Duration(milliseconds: 550),
        );

        //Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Items(
          itemName: prodottItem.name,
          itemPrice: prodottItem.price,
          leftAligned: (prodottItem.id % 2) == 0 ? true : false,
          prodottItem: prodottItem,),
    );
  }
}

class Items extends StatelessWidget {

  Items(
      {required this.leftAligned,
      required this.itemName,
      required this.itemPrice,
      required this.prodottItem});

  final bool leftAligned;
  final ProdottiItem prodottItem;
  final String itemName;
  final int itemPrice;

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(ProdottiItem prodottItem) {
    bloc.addToList(prodottItem);
  }

  removeFromList(ProdottiItem prodottItem) {
    bloc.removeFromList(prodottItem);
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

    final LinearGradient gradient2 = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 255, 236, 210),
        Color.fromARGB(255, 253, 184, 161)
      ],
    );

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
            '€ ' + '${itemPrice}',
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
            child: Icon(
              CupertinoIcons.cart_badge_plus,
              size: 29,
            ),
            onPressed: () {
              addToCart(prodottItem);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 500),
                  backgroundColor: Colors.green,
                  content: Text(
                      "${prodottItem.name} added to cart ${prodottItem.quantity}x")));
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
    final bwColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    final background =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(236, 0, 0, 0)
            : Colors.white;
    final buttonColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Color.fromARGB(255, 20, 20, 20)
            : Colors.white;

    final textColor =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
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

                return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart()));
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            CupertinoIcons.cart,
                            size: 30,
                            color: textColor,
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 3,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
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
                ;
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
         // Navigator.push(
           //   context, MaterialPageRoute(builder: (context) => Cart()));
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                CupertinoIcons.cart_fill,
                size: 28,
              ),
            ),
            Positioned(
                top: 0,
                right: 3,
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