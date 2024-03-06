/*import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ichiani_flutter/Screen/Cart/AddCardPage.dart';
import 'package:ichiani_flutter/Screen/Cart/OrdineEffettuato.dart';
import 'package:ichiani_flutter/Screen/Cart/Stripe/Payment_service.dart';
import 'package:ichiani_flutter/Screen/Cart/prodotti_item_it.dart';
import 'package:ichiani_flutter/Screen/Cart/themeColor.dart';
import 'package:ichiani_flutter/Screen/ScriviRecensione.dart';
import 'package:ichiani_flutter/Screen/bloc/cartlistBloc.dart';
import 'package:ichiani_flutter/Screen/bloc/listTileColorBloc.dart';
import 'package:lottie/lottie.dart';
//import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/ListView/ListAiuto.dart';
import 'Stripe/payment-service.dart';
import 'package:http/http.dart' as http;

class Cart extends StatelessWidget {
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
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    List<ProdottiItem> prodottiItems;
    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = (snapshot.data as List<ProdottiItem>);
          prodottiItems = data;
          return Scaffold(
            body: SafeArea(
              bottom: true,
              child: Stack(
                children: [
                  CartBody(prodottiItems),
                  /*SlidingUpPanel(
                    borderRadius: BorderRadius.circular(40),
                    backdropEnabled: true,
                    panelSnapping: true,
                    defaultPanelState: PanelState.CLOSED,
                    panelBuilder: (ScrollController sc) => ListView(
                      controller: sc,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                          ],
                        )
                      ],
                    ),
                    collapsed: Container(),
                  )*/
                  PayBar(prodottiItems)
                ],
              ),
            ),
          );
        } else {
          return Container(
            child: Text("Something returned null"),
          );
        }
      },
    );
  }
}

class PayBar extends StatefulWidget {
  final List<ProdottiItem> prodottiItems;

  PayBar(this.prodottiItems);

  @override
  State<PayBar> createState() => _PayBarState();
}

class _PayBarState extends State<PayBar> {
  //PaymentMethod? paymentMethod;

  @override
  int temp_amount = 0;
  int amount = 0;
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 7),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(AppLocalizations.of(context)!.caricamento)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /*payViaNewCard(BuildContext context) async {
    await showLoaderDialog(context);
    var response = await StripeService.payWithNewCard(
        amount: "${returnTotalAmountPayment(widget.prodottiItems)}",
        currency: 'EUR');

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    if (response.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdineEffettuato()),
      );
    }
  }*/

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void initState() {
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent('10', 'EUR');
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.system,
                  merchantDisplayName: 'Arturo Marino'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
        //parameters: PresentPaymentSheetParameters(clientSecret: paymentIntent!['client_secret'],confirmPayment: true)
      ).then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }
  var currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'receipt_email': currentUserEmail,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  @override
  Widget build(BuildContext context) {
    final LinearGradient gradientLight = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 255, 236, 210),
        Color.fromARGB(255, 253, 184, 161)
      ],
    );
    final LinearGradient gradientLight1 = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 188, 197, 206),
        Color.fromARGB(255, 147, 159, 174)
      ],
    );
    final LinearGradient gradientDark = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 133, 197, 238),
        Color.fromARGB(255, 2, 80, 145)
      ],
    );
    return Column(
      children: [
        Expanded(child: Container()),
        Container(
          height: MediaQuery.of(context).size.height * 0.22,
          decoration: BoxDecoration(
              gradient:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? gradientDark
                      : gradientLight,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
            child: Column(
              children: <Widget>[
                totalAmount(widget.prodottiItems),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apple,
                                size: 30,
                              ),
                              Text(
                                "Pay",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 28),
                              ),
                            ],
                          ),
                          onPressed: () {
                            //print(paymentMethod!.id);
                            // PaymentService(
                            ////             widget.prodottiItems))
                            ///   .processPayment(paymentMethod!);
                          },
                          color: Colors.black,
                        ),
                      ),*/
                      SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.payment,
                                size: 28,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppLocalizations.of(context)!.paga,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ],
                          ),
                          onPressed: () async{
                            //print(itemCart(widget.prodottiItems));
                            if (returnTotalAmountPayment(
                                    widget.prodottiItems) ==
                                0) {
                              return;
                            } else {
                              //print(returnTotalAmount(widget.prodottiItems).toStringAsPrecision(2).toString());
                              await makePayment(returnTotalAmount(widget.prodottiItems).toStringAsPrecision(2).toString());
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddCardPage()),
                              );*/
                              //payViaNewCard(context);
                              FirebaseFirestore.instance
                                  .collection('Ordini')
                                  .doc(currentUserId)
                                  .set({
                                'order': {
                                  '001': {
                                    'itemList': {
                                      'item':
                                          '${itemCart(widget.prodottiItems)}'
                                    },
                                    'info': {}
                                  }
                                },
                              });
                            }
                          },
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
                //nextButtonBar(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container persons() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Persons",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              )),
          CustomPersonWidget(),
        ],
      ),
    );
  }

  Container totalAmount(List<ProdottiItem> prodottiItems) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.totale,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          Text(
            "\€${returnTotalAmount(prodottiItems)}0",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          )
        ],
      ),
    );
  }

  double returnTotalAmount(List<ProdottiItem> prodottiItems) {
    double totalAmount = 0.0;

    for (int i = 0; i < prodottiItems.length; i++) {
      totalAmount =
          totalAmount + prodottiItems[i].price * prodottiItems[i].quantity;
    }
    return totalAmount;
  }

  List itemCart(List<ProdottiItem> prodottiItems) {
    List totalItemCart = [];

    for (int i = 0; i < prodottiItems.length; i++) {
      totalItemCart = totalItemCart + [prodottiItems[i].name];
    }

    return totalItemCart;
  }

  int returnTotalAmountPayment(List<ProdottiItem> prodottiItems) {
    int totalAmountPayment = 0;

    for (int i = 0; i < prodottiItems.length; i++) {
      totalAmountPayment = returnTotalAmount(prodottiItems).toInt() * 100;
    }
    return totalAmountPayment;
  }

  Container nextButtonBar() {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Themes.color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: <Widget>[
          Text(
            "15-25 min",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          Spacer(),
          Text(
            "Next",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPersonWidget extends StatefulWidget {
  @override
  _CustomPersonWidgetState createState() => _CustomPersonWidgetState();
}

class _CustomPersonWidgetState extends State<CustomPersonWidget> {
  int noOfPersons = 1;

  double _buttonWidth = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: ElevatedButton(
              //padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  if (noOfPersons > 1) {
                    noOfPersons--;
                  }
                });
              },
              child: Text(
                "-",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ),
          Text(
            noOfPersons.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: ElevatedButton(
              //padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  noOfPersons++;
                });
              },
              child: Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartBody extends StatelessWidget {
  final List<ProdottiItem> prodottiItems;

  CartBody(this.prodottiItems);

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
    return Container(
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.mio,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 35,
                          color: textColor),
                    ),
                    Text(
                      AppLocalizations.of(context)!.carrello,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 35,
                          color: textColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
              flex: 1,
              child: prodottiItems.length > 0
                  ? foodItemList()
                  : Column(
                      children: [
                        SizedBox(
                            height: 320,
                            child: Opacity(
                              child: Lottie.asset('assets/cartAnimation.json'),
                              opacity: 0.5,
                            )),
                        Text(
                          AppLocalizations.of(context)!.nessun_articolo,
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 150,
                        )
                      ],
                    ))
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
        child: Opacity(
      child: SizedBox(child: Lottie.asset('assets/cartAnimation.json')),
      opacity: 0.5,
    ));
  }

  ListView foodItemList() {
    return ListView.builder(
      itemCount: prodottiItems.length,
      itemBuilder: (context, index) {
        return CartListItem(foodItem: prodottiItems[index]);
      },
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "My",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.black),
              ),
              Text(
                "Cart",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  final ProdottiItem foodItem;

  CartListItem({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      hapticFeedbackOnStart: false,
      maxSimultaneousDrags: 1,
      data: foodItem,
      feedback: DraggableChildFeedback(foodItem: foodItem),
      child: DraggableChild(foodItem: foodItem),
      childWhenDragging: foodItem.quantity > 1
          ? DraggableChild(foodItem: foodItem)
          : Container(),
    );
  }
}

class DraggableChild extends StatelessWidget {
  const DraggableChild({
    Key? key,
    required this.foodItem,
  }) : super(key: key);

  final ProdottiItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ItemContent(
        foodItem: foodItem,
      ),
    );
  }
}

class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    Key? key,
    required this.foodItem,
  }) : super(key: key);

  final ProdottiItem foodItem;

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return Opacity(
      opacity: 0.7,
      child: Material(
        child: StreamBuilder(
          stream: colorBloc.colorStream,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.95,
              child: ItemContent(foodItem: foodItem),
            );
          },
        ),
      ),
    );
  }
}

class ItemContent extends StatelessWidget {
  ItemContent({
    Key? key,
    required this.foodItem,
  }) : super(key: key);

  final ProdottiItem foodItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  removeFromList(ProdottiItem foodItem) {
    bloc.removeFromList(foodItem);
  }

  @override
  Widget build(BuildContext context) {
    final LinearGradient gradientLight = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 162, 197, 254),
        Color.fromARGB(255, 194, 233, 252)
      ],
    );
    final LinearGradient gradientDark = LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 188, 197, 206),
        Color.fromARGB(255, 147, 159, 174)
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
            gradient:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? gradientDark
                    : gradientLight,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(text: foodItem.quantity.toString()),
                      TextSpan(text: " x "),
                      TextSpan(
                        text: foodItem.name,
                      ),
                    ]),
              ),
              Text(
                "\€${foodItem.quantity * foodItem.price}",
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.w400),
              ),
              CupertinoButton(
                  child: Icon(CupertinoIcons.delete),
                  onPressed: () {
                    removeFromList(foodItem);
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      titleText: Text(
                        AppLocalizations.of(context)!.rimosso_1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: "ShadowsIntoLightTwo"),
                      ),
                      messageText: Text(
                        AppLocalizations.of(context)!.rimosso_2,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: "ShadowsIntoLightTwo"),
                      ),
                    )..show(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

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
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              CupertinoIcons.back,
              size: 35,
              color: textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
*/