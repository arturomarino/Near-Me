import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:near_me/Screen/Theme.dart';
import 'package:near_me/Screen/Verification/core/utils/size_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetRulePage extends StatefulWidget {
  final String structure;
  const SetRulePage({
    Key? key,
    required this.structure,
  }) : super(key: key);
  @override
  State<SetRulePage> createState() => _SetRulePageState();
}

class _SetRulePageState extends State<SetRulePage> {
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
        _ruleList.add(rule);
      });
    });
    dbRef2.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, values) {
        String prohibition = values["prohibitions"];
        _prohibitionList.add(prohibition);
      });
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {});
      print(_ruleList);
      print(_prohibitionList);
      if (_ruleList.isNotEmpty) {
        setState(() {
          ruleEmpty = false;
        });
      }else{
        setState(() {
          showNoData = true;
        });
      }
      if (_prohibitionList.isNotEmpty) {
        setState(() {
          proEmpty = false;
        });
      }else{
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

  @override
  Widget build(BuildContext context) {
    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
      backgroundColor: background,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: CupertinoIcons.xmark,
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        overlayOpacity: 0.4,
        overlayColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(
              CupertinoIcons.xmark_seal_fill,
              color: Colors.red,
            ),
            label: 'Add Prohibition',
            onTap: () {
              HapticFeedback.lightImpact();
              showModalBottomSheet(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return NewContentSheet(
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
          SpeedDialChild(
              child: Icon(
                Icons.verified,
                color: Colors.green,
              ),
              label: 'Add Rule',
              onTap: () async {
                HapticFeedback.lightImpact();
                showModalBottomSheet(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return NewContentSheet(
                      rule: true,
                      structure: widget.structure,
                    );
                  },
                ).then((value) {
                  Future.delayed(Duration(seconds: 1), () {
                    _refreshController.requestRefresh();
                  });
                });
              }),
        ],
      ),
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
                                  ? showNoData==false?Center(
                                      child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            color: textColor,
                                            strokeWidth: 3,
                                          ))):Text('No rules avaible',style: TextStyle(fontWeight: FontWeight.w500,color: textColor),)
                                  : ListView.separated(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _ruleList.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 15);
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
                                              'È consentito ' + _ruleList[index],
                                              style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
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
                                                                      .child("structure/${widget.structure}/rule")
                                                                      .child(_ruleList[index])
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
                                  ? showNoData2==false?Center(
                                      child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            color: textColor,
                                            strokeWidth: 3,
                                          ))):Text('No prohibitions avaible',style: TextStyle(fontWeight: FontWeight.w500,color: textColor),)
                                  : ListView.separated(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _prohibitionList.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 15);
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
                                              'È vietato ' + _prohibitionList[index],
                                              style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 17),
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
                                                                      .child("structure/${widget.structure}/prohibitions")
                                                                      .child(_prohibitionList[index])
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

class NewContentSheet extends StatefulWidget {
  final String structure;
  final bool rule;
  const NewContentSheet({
    Key? key,
    required this.rule,
    required this.structure,
  }) : super(key: key);

  @override
  State<NewContentSheet> createState() => _NewContentSheetState();
}

class _NewContentSheetState extends State<NewContentSheet> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: widget.rule
                            ? controller.text != ''
                                ? Colors.green
                                : Colors.grey
                            : controller.text != ''
                                ? Colors.red
                                : Colors.grey),
                  ),
                  onPressed: () async {
                    if (controller.text != '') {
                      if (widget.rule == true) {
                        await FirebaseDatabase.instance
                            .ref()
                            .child('structure/${widget.structure}/rule/${controller.text}')
                            .update({'rule': controller.text});
                      } else {
                        await FirebaseDatabase.instance
                            .ref()
                            .child('structure/${widget.structure}/prohibitions/${controller.text}')
                            .update({'prohibitions': controller.text});
                      }

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            Text(
              widget.rule ? 'New rule' : 'New prohibition',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: controller,
                style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: widget.rule ? 'Write your rule' : 'Write your prohibition',
                    prefixText: widget.rule ? 'It is allowed ' : 'It\'s forbidden ',
                    prefixStyle: TextStyle(color: widget.rule ? Colors.green : Colors.red, fontSize: 17, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
