import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:near_me/Screen/Theme.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translator/translator.dart';

class ServicePage extends StatefulWidget {
  final String nomeCognome;
  final String structure;
  const ServicePage({Key? key, required this.structure, required this.nomeCognome}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<String> _serviceList = [];
  List<String> _servicePriceList = [];

  bool serviceEmpty = true;
  bool showNoData = false;

  @override
  void initState() {
    _getData();
    super.initState();
  }
  GoogleTranslator translator = GoogleTranslator();

  void _onRefresh() async {
    // monitor network fetch
    _serviceList.clear();
    _getData();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 100));
    // if failed,use refreshFailed()
    HapticFeedback.heavyImpact();
    _refreshController.refreshCompleted();
  }

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/servizi");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String nameService = values["nome_servizio"];
        String price = values["prezzo"];
        translator.translate(nameService, to: Localizations.localeOf(context).languageCode).then((value) {
          _serviceList.add(value.toString());
        });
        _servicePriceList.add(price);
      });
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {});
      print(_serviceList);
      print(_servicePriceList);
      if (_serviceList.isNotEmpty) {
        setState(() {
          serviceEmpty = false;
        });
      } else {
        setState(() {
          showNoData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          foregroundColor: textColor,
          elevation: 0,
        ),
        body: SafeArea(
            bottom: false,
            child: SmartRefresher(
              enablePullUp: false,
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(10)),
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Extra services',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
                                ),
                                serviceEmpty
                                    ? showNoData == false
                                        ? Center(
                                            child: SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: CircularProgressIndicator(
                                                  color: textColor,
                                                  strokeWidth: 3,
                                                )))
                                        : Text(
                                            'No service avaible',
                                            style: TextStyle(fontWeight: FontWeight.w500, color: textColor2),
                                          )
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _serviceList.length,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 10);
                                        },
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _serviceList[index],
                                                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    '€ ' + _servicePriceList[index].toUpperCase(),
                                                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              CupertinoButton(
                                                child: Container(
                                                  child: Center(
                                                      child: Text(
                                                    "Request service",
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.green),
                                                  )),
                                                  height: 25,
                                                  width: width * .3,
                                                  decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(20)),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.selectionClick();
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      //enableDrag: false,
                                                      isDismissible: false,
                                                      builder: (context) => _bottomSheets(
                                                            servizio: _serviceList[index],
                                                            prezzo: _servicePriceList[index],
                                                            structure: widget.structure,
                                                            nomeCognome: widget.nomeCognome,
                                                          ),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)));
                                                },
                                                padding: EdgeInsets.zero,
                                              )
                                            ],
                                          );
                                        },
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
    /* CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  /*ExpansionTile(title: Text(""),children: [ FirebaseAnimatedList(
                        query: FirebaseDatabase.instance.ref().child('structure/${widget.structure}/servizi'),
                        shrinkWrap: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, snapshot, animation, index) {
                          Map data = snapshot.value as Map;
                          data['key'] = snapshot.key;

                          return ListTile(
                            enableFeedback: true,
                            title: Text(data['nome_servizio']),
                          );
                        })],),*/

                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _services.length,
                      itemBuilder: (context, index2) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              enableFeedback: true,
                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text(_services[index2],style: TextStyle(color: textColor),),
                              value: _serviceDatabase.contains(_services[index2]) ? true : _checked[index2],
                              onChanged: (value) {
                                setState(() {
                                  _checked[index2] = value!;
                                });
                              },
                            ),
                            Visibility(
                              visible: _serviceDatabase.contains(_services[index2]) ? true : false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                child: Text(
                                  'Prezzo'.toUpperCase(),
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor2),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _serviceDatabase.contains(_services[index2]) ? true : false,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      child: CupertinoTextField(
                                        //focusNode: _focusNode,
                                        prefix: Text('€'),
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        controller: _controllers[index2],
                                      ),
                                      width: width * 0.3,
                                    ),
                                    SizedBox(width: 5),
                                    CupertinoButton(
                                      child: Text(
                                        "Salva",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () async {
                                        double number = double.parse(_controllers[index2].text.replaceAll(',', '.'));
                                        String prezzo = NumberFormat("#,##0.00", "it_IT").format(number);
                                        await FirebaseDatabase.instance
                                            .ref()
                                            .child('structure/${widget.structure}/servizi/${_services[index2]}')
                                            .update({'prezzo': prezzo});
                                      },
                                      padding: EdgeInsets.zero,
                                    ),
                                    Spacer(),
                                    CupertinoButton(
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child('structure/${widget.structure}/servizi')
                                            .child(_services[index2])
                                            .remove();
                                        Future.delayed(Duration(seconds: 2), () {
                                          _serviceDatabase.clear();
                                          _getData();
                                          setState(() {});
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 2,
                          color: textColor2,
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));*/
  }
}
class _bottomSheets extends StatefulWidget {
  final String nomeCognome;
  final String structure;
  final String servizio;
  final String prezzo;
  const _bottomSheets({Key? key, required this.servizio, required this.prezzo, required this.structure, required this.nomeCognome}) : super(key: key);

  @override
  State<_bottomSheets> createState() => _bottomSheetsState();
}

class _bottomSheetsState extends State<_bottomSheets> {
  void _showSnackBarRichiesta(BuildContext context) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      content: Row(
        children: [
          Text(
            'Thank you for your request, see you soon!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ),
      backgroundColor: Colors.blue,
      //Color.fromARGB(255, 35, 34, 34),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
     final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      height: height * .3,
      color: buttonColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CupertinoButton(
                child: Text(AppLocalizations.of(context)!.annulla),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: width * .12,
            ),
            
            Text(
              "Confirm request",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,color: textColor),
            ),
            Spacer()
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              widget.servizio,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              'The host will receive the request and will contact you.\nYou can cancel the request simply by contacting the host',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              widget.prezzo != '' ? '€' + widget.prezzo : '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  child: Center(child: Text("Request service", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
                  width: width,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  await FirebaseDatabase.instance.ref().child('structure/${widget.structure}/richiesteServizi/${widget.nomeCognome}').update({
                    'ospite': widget.nomeCognome,
                    'orders': {'servizio_richiesto': widget.servizio, 'prezzo': '€${widget.prezzo}'}
                  });
                  Navigator.pop(context);
                  _showSnackBarRichiesta(context);
                  HapticFeedback.lightImpact();
                }),
          )
        ],
      ),
    );
  }
}


