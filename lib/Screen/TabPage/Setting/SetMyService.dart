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

class SetMyService extends StatefulWidget {
  final String structure;
  const SetMyService({Key? key, required this.structure}) : super(key: key);

  @override
  _SetMyServiceState createState() => _SetMyServiceState();
}

class _SetMyServiceState extends State<SetMyService> {
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
        _serviceList.add(nameService);
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

/*  void _resetController() {
    _controllers = List.generate(
      _services.length, // Numero di TextField
      (index) => TextEditingController(),
    );
  }

  String _selectedValue = ''; // valore selezionato dalla lista

  List<String> _services = [
    'Pulizia e cambio lenzuola',
    'Servizio di lavanderia e stiratura',
    'Servizio di cucina e preparazione pasti',
    'Servizio di consegna spesa a domicilio',
    'Trasporto privato per spostamenti',
    'Servizio di guida turistica per visite ai dintorni',
    'Massaggi e trattamenti estetici a domicilio',
    'Personal trainer e lezioni di fitness',
    'Noleggio di biciclette o altri mezzi di trasporto',
    'Servizio di baby-sitting',
    'Organizzazione di eventi e feste private',
    'Servizio di assistenza tecnica per eventuali problemi nell\'abitazione',
    'Servizio di riparazione e manutenzione giardino e piscina',
    'Noleggio attrezzature sportive e ricreative',
    'Servizio di concierge per prenotazioni e informazioni turistiche',
    'Servizio di sicurezza per garantire la tranquillità degli ospiti',
    'Servizio di prenotazione ristoranti e locali',
    'Servizio di personal shopping e consegna di acquisti',
    'Organizzazione di corsi di cucina, degustazioni e wine tasting',
    'Servizio di noleggio yacht e barche'
  ];

  List<bool> _checked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  bool _isLoading = false;

  Future<void> _waitAndHideIndicator() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  final ref = FirebaseDatabase.instance.ref();
  List<String> _serviceDatabase = [];

  _getData() async {
    DatabaseReference dbRef = ref.child("structure/${widget.structure}/servizi");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String servizio = values["nome_servizio"];
        _serviceDatabase.add(servizio);
      });
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  late List<TextEditingController> _controllers;

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();*/

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
        backgroundColor: background,
        floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          child: Icon(
            CupertinoIcons.add,
            color: Colors.blue,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return NewServiceSheet(
                  rule: false,
                  structure: widget.structure,
                );
              },
            ).then((value) {
              Future.delayed(Duration(seconds: 1), () {
                _refreshController.requestRefresh();
              });
            });
            ;
          },
        ),
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
                                  'Your services',
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
                                        : Text('No rules avaible',style: TextStyle(fontWeight: FontWeight.w500,color: textColor2),)
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
                                              GestureDetector(
                                                child: Icon(
                                                  CupertinoIcons.minus,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (BuildContext context) => CupertinoTheme(
                                                            data: MediaQuery.of(context).platformBrightness == Brightness.dark
                                                                ? MyThemeDark.darkTheme
                                                                : MyThemeLight.lightTheme,
                                                            child: CupertinoActionSheet(
                                                              title: Text(
                                                                'Are you sure you want to delete?',
                                                                style: TextStyle(color: textColor, fontWeight: FontWeight.normal),
                                                              ),
                                                              cancelButton: CupertinoActionSheetAction(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text(
                                                                  AppLocalizations.of(context)!.annulla,
                                                                  style: TextStyle(fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                              actions: [
                                                                CupertinoActionSheetAction(
                                                                  onPressed: () {
                                                                    FirebaseDatabase.instance
                                                                        .ref()
                                                                        .child("structure/${widget.structure}/servizi")
                                                                        .child(_serviceList[index])
                                                                        .remove();

                                                                    HapticFeedback.lightImpact();
                                                                    Navigator.pop(context);
                                                                    Future.delayed(Duration(seconds: 1), () {
                                                                      _refreshController.requestRefresh();
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ));
                                                },
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

class NewServiceSheet extends StatefulWidget {
  final String structure;
  final bool rule;
  const NewServiceSheet({
    Key? key,
    required this.rule,
    required this.structure,
  }) : super(key: key);

  @override
  State<NewServiceSheet> createState() => _NewServiceSheetState();
}

class _NewServiceSheetState extends State<NewServiceSheet> {
  late TextEditingController _nameC;
  late TextEditingController _priceC;

  @override
  void initState() {
    _nameC = TextEditingController();
    _priceC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Container(
      height: height * .8,
      width: width,
      decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Add',
                    style: TextStyle(fontWeight: FontWeight.w600, color: _nameC.text != '' && _priceC.text != '' ? Colors.blue : Colors.grey),
                  ),
                  onPressed: () async {
                    if (_nameC.text != '' && _priceC != '') {
                      double number = double.parse(_priceC.text.replaceAll(',', '.'));
                      String prezzo = NumberFormat("#,##0.00", "it_IT").format(number);
                      await FirebaseDatabase.instance
                          .ref()
                          .child('structure/${widget.structure}/servizi/${_nameC.text}')
                          .update({'nome_servizio': _nameC.text, 'prezzo': prezzo});
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            Text(
              'New service',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: _nameC,
                style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w500),
                decoration: InputDecoration(labelText: 'Write the name of your service', labelStyle: TextStyle(color: textColor),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: _priceC,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  prefix: Text('€ ',style: TextStyle(color: textColor),),
                  labelText: 'Assign a price to your service',
                  labelStyle: TextStyle(color: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
