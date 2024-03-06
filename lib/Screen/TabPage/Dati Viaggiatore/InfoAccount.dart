

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../DetailsView/core/utils/size_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoAccount extends StatefulWidget {
  const InfoAccount({Key? key}) : super(key: key);

  @override
  State<InfoAccount> createState() => _InfoAccountState();
}

class _InfoAccountState extends State<InfoAccount> {
  final ref = FirebaseDatabase.instance.ref();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  var email = FirebaseAuth.instance.currentUser!.email;
  String name = '';
  String surname = '';

  bool _isSubscribed = false;
  String typeSub = '';
  bool _hidePlan = false;
  String _dateRenew = '';

  Future _updateCustumerStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();
    print(customerInfo.latestExpirationDate);
    DateTime dateTime = DateTime.parse(customerInfo.latestExpirationDate.toString());
    String formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);

    setState(() {
      _dateRenew = formattedDate;
    });

    if (customerInfo.activeSubscriptions[0] == 'nm_2999_1y') {
      setState(() {
        typeSub = 'Annual';
      });
    } else if (customerInfo.activeSubscriptions[0] == 'nm_1899_6mt') {
      setState(() {
        typeSub = 'Semiannual';
      });
    } else if (customerInfo.activeSubscriptions[0] == 'nm_499_1m') {
      setState(() {
        typeSub = 'Monthly';
      });
    } else if (customerInfo.activeSubscriptions.isEmpty) {
      setState(() {
        _hidePlan = true;
      });
    }

    if (customerInfo.entitlements.active.isNotEmpty) {
      setState(() {
        _isSubscribed = true;
      });
    }
    print('L\'utente è abbonato: $_isSubscribed');
  }

  _getData() async {
    final name2 = await ref.child('users/$currentUser/name').get();
    final surname2 = await ref.child('users/$currentUser/surname').get();

    if (name2.exists && surname2.exists) {
      setState(() {
        name = name2.value.toString();
        surname = surname2.value.toString();
      });
    } else {
      print('No data available.');
    }
  }

  @override
  void initState() {
    _updateCustumerStatus();
    _getData();
    super.initState();
  }

  void showSnackBarCopy(BuildContext context) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      content: Row(
        children: [
          Text(
            'ID copiato nella clipboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ),
      backgroundColor: Colors.grey,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black54;
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          foregroundColor: textColor,
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.informazioni_account,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
                    ),
                    SizedBox(height: height * 0.05),
                    Text(
                       AppLocalizations.of(context)!.informazioni_account,
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    Text(
                      '$name $surname',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                    ),
                    Divider(
                      height: 20,
                      color: Colors.grey,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    Text(
                      '$email',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                    ),
                    Divider(
                      height: 20,
                      color: Colors.grey,
                    ),
                    Text(
                      'ID utente',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    Row(
                      children: [
                        Text(
                          '$currentUser',
                          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.share,
                            size: 20,
                          ),
                          onPressed: () async {
                            Share.share('Ecco il mio ID NearMe: $currentUser');
                          },
                          padding: EdgeInsets.only(bottom: 10, right: 20),
                        ),
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.doc_on_clipboard,
                            size: 20,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: currentUser));
                            showSnackBarCopy(context);
                            HapticFeedback.lightImpact();
                          },
                          padding: EdgeInsets.only(bottom: 10, right: 20),
                        )
                      ],
                    ),
                    Visibility(
                      visible: !_hidePlan,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            'Abbonamento',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          Text(
                            '$typeSub Plan',
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'The subscription will automatically renew on the day $_dateRenew',
                            style: TextStyle(color: textColor2, fontWeight: FontWeight.normal,fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
