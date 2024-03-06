import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:near_me/l10n/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:translator/translator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RulePage extends StatefulWidget {
  final String structure;
  const RulePage({
    Key? key,
    required this.structure,
  }) : super(key: key);
  @override
  State<RulePage> createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<String> _ruleList = [];
  List<String> _prohibitionList = [];

  bool ruleEmpty = true;
  bool proEmpty = true;
  bool showNoData = false;
  bool showNoData2 = false;

  @override
  void initState() {
    _getData();

    super.initState();
  }

  _getData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/rule");
    DatabaseReference dbRef2 = FirebaseDatabase.instance.ref().child("structure/${widget.structure}/prohibitions");
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String rule = values["rule"];
        translator.translate(rule, to: Localizations.localeOf(context).languageCode).then((value) {
          _ruleList.add(value.toString());
        });
      });
    });
    dbRef2.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String prohibition = values["prohibitions"];
         translator.translate(prohibition, to: Localizations.localeOf(context).languageCode).then((value) {
          _prohibitionList.add(value.toString());
        });
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
      print(_ruleList);
      print(_prohibitionList);
      //tranlate();
      if (_ruleList.isNotEmpty) {
        setState(() {
          ruleEmpty = false;
        });
      } else {
        setState(() {
          showNoData = true;
        });
      }
      if (_prohibitionList.isNotEmpty) {
        setState(() {
          proEmpty = false;
        });
      } else {
        setState(() {
          showNoData2 = true;
        });
      }
    });
  }

  void _onRefresh() async {
    setState(() {
      proEmpty = true;
      ruleEmpty = true;
      showNoData = false;
      showNoData2 = false;
    });
    // monitor network fetch
    _ruleList.clear();
    _prohibitionList.clear();
    _getData();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 100));
    // if failed,use refreshFailed()
    HapticFeedback.heavyImpact();
    _refreshController.refreshCompleted();
  }

  GoogleTranslator translator = GoogleTranslator();

  void tranlate() {
    for (int i = 0; i < _ruleList.length; i++) {
      translator.translate(_ruleList[i], to: Localizations.localeOf(context).languageCode).then((value) {
        setState(() {
          _ruleList[i] = value.toString();
        });
      });
    }
    for (int i = 0; i < _prohibitionList.length; i++) {
      translator.translate(_prohibitionList[i], to: Localizations.localeOf(context).languageCode).then((value) {
        setState(() {
          _prohibitionList[i] = value.toString();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: textColor,
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
                                'Rule'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
                              ),
                              ruleEmpty == true
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
                                          'No rules avaible',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        )
                                  : ListView.separated(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _ruleList.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 7);
                                      },
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${AppLocalizations.of(context)!.e_consentito} ' + _ruleList[index],
                                              style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
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
                                'Prohibition'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
                              ),
                              proEmpty
                                  ? showNoData2 == false
                                      ? Center(
                                          child: SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                color: textColor,
                                                strokeWidth: 3,
                                              )))
                                      : Text('No prohibitions avaible')
                                  : ListView.separated(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _prohibitionList.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 7);
                                      },
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.xmark_seal_fill,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${AppLocalizations.of(context)!.e_vietato} ' + _prohibitionList[index],
                                              style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.2,
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
